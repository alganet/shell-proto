#!/usr/bin/env sh

_compat () {
	_silent _compat_detect_builtins

	_ifs=$'\r'
	test ${#_ifs} = 1 || _ifs="$(_send \\r)"
	IFS=$_ifs
	
	_declare_internal var
	_declare_internal send
	_declare_internal funcs
}

_compat_detect_builtins () {
	set -euf

	PATH=

	LC_ALL=C

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

_funcs () {
	IFS='	'
	set -- ${_funcs:-}
	IFS="$_ifs"
	while test $# -gt 0
	do
		send "$1\n"
		shift
	done
}

_source_file () {
	test -f "${1}"

	REPLY=''
	while read -r REPLY || test -n "${REPLY}"
	do
		if test "${REPLY}" = "${REPLY%' () {'} () {"
		then
			set -- "$1" "${2:-}
				_funcs=\"\${_funcs:-}	${REPLY%' () {'}\"
				_declare_external ${REPLY%' () {'}
				__${REPLY##'	'}"
		else
			set -- "$1" "${2:-}
				${REPLY##'	'}"
		fi
	done < "${1}"
	REPLY=''

	eval "${2:-:}"
}

_run_tests () {
	# TODO remove this pipe
	_funcs | while read -r REPLY || test -n "$REPLY"
	do
		_run_single_test "$REPLY"
	done
}

_run_single_test () {
	if test "$REPLY" = "test_${REPLY#test_}"
	then
		(
			$REPLY &&
				_send "ok	${REPLY}\n" ||
				_send "not ok	${REPLY}\n"
		)
	fi
}