#!/usr/bin/env sh

_compat () {
	_silent _compat_detect_builtins

	_ifs=$'\r'
	test ${#_ifs} = 1 || _ifs="$(_send \\r)"
	IFS=$_ifs
	
	_declare_internal var
	_declare_internal send
	_declare_internal assert
	_declare_internal use
}

_compat_detect_builtins () {
	set -euf

	PATH=

	LC_ALL=C
	
	if command -v setopt
	then
		setopt SH_WORD_SPLIT
	fi

	if ! command -v command
	then 
		_send () { IFS=' ' echo -n "$*" ;}
		return
	fi

	if command -v printf
	then _send () { IFS=' ' printf %b "$*" ;}

	elif command -v print 
	then _send () { IFS=' ' builtin print -n "$*" ;}
	fi

	if ! command -v local && command -v typeset && command -v alias
	then alias local=typeset
	fi

	if  command -v function
	then _declare_external () { _declare_body "function $1 { ${2:-__$1}" ;}
	fi
}

_assert () {
	test "${1:-}" "${2:-}" "${3:-}"
}

_declare_body () {
	eval "$1 \"\${@:-}\" ;}"
}

_declare_internal () {
	_declare_body "$1 () { ${2:-_$1}"
}

_declare_external () {
	_declare_internal "$1" "${2:-__$1}"
}

_buffer_stop () {
	unset _buffer$_buffer_level
	_buffer_level=$((_buffer_level - 1))
	
	if test $_buffer_level -lt 1
	then _declare_internal send
	fi

	return ${1:-0}
}

_buffer_get () {
	eval "$1=\"\${_buffer${_buffer_level}:-}\""
	return ${2:-0}
}


_buffer_start () {
	_declare_internal send _buffer
	_buffer_level=$((${_buffer_level:-0} + 1))
}

_buffer () {
	eval "IFS=' ' _buffer$_buffer_level=\"\${_buffer$_buffer_level:-}\$*\""
	IFS="$_ifs"
}

_buffer_var () {
	_buffer_start

	if _shift_invoke 3 $@
	then _buffer_get $1 $?
	else return $?
	fi

	_buffer_stop $?
}

_shift_invoke () {
	shift $1
	$@
}

_silent () {
	$@ >/dev/null 2>&1
}

_var () {
	case $2 in
		'=' ) eval "${1##_}=\"\${3:-}\"";;
		':' ) _buffer_var $@;;
	esac
}


# =====

_use () {
	:
}

_source_file () {
	_translate_file eval "$1"
}

_translate_file () {
	test -n "${2:-}"
	test -f "${2}"

	_target_function="$1"
	_source_path="$2"
	_source_line=''
	_source_funcs="${_source_funcs:-}"
	
	while read -r _source_line || test -n "${_source_line}"
	do
		_maybe_token="${_source_line#use }"

		if
			test "${_source_line}" = "use ${_maybe_token}" &&
			test "${_source_funcs}" = "${_source_funcs#*${_maybe_token}*}"
		then
			_source_funcs="${_source_funcs:-}	${_maybe_token}"
			_translate_file $_target_function "./${_maybe_token}.sh"
		fi

		_maybe_token="${_source_line%' () {'}"

		if test "${_source_line}" = "${_maybe_token} () {"
		then
			_source_funcs="${_source_funcs:-}	${_maybe_token}"
			_source_code="${_source_code:-}
				_declare_external ${_maybe_token}
				__${_source_line}"
		else
			_source_code="${_source_code:-}
				${_source_line}"
		fi
	done < "${_source_path}"

	_source_line=''

	_source_code="${_source_code:-}
		_source_funcs='${_source_funcs}'"

	$_target_function "${_source_code:-}"
}

_run_tests () {
	IFS='	'
	set -- ${_source_funcs:-}
	IFS="$_ifs"
	while test $# -gt 0
	do
		_run_single_test "$1"
		shift
	done
}

_run_single_test () {
	if test "$1" = "test_${1#test_}"
	then
		$1 &&
			_send "ok	${1}\n" ||
			_send "not ok	${1}\n"
	fi
}