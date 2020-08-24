#!/usr/bin/env sh

_compat () {
	_silent _compat_detect_builtins

	_ifs=$'\r'
	test ${#_ifs} = 1 || _ifs="$(_send \\r)"
	IFS=$_ifs

	_declare_internal var
	_declare_internal send
	_declare_internal length
}

_compat_detect_builtins () {
	set -euf

	PATH=

	LC_ALL=C
	
	if command -v setopt
	then
		setopt SH_WORD_SPLIT NOGLOB
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
	_buffer_level="$((_buffer_level - 1))"
	
	if test $_buffer_level -lt 1
	then _declare_internal send
	fi

	return ${1:-0}
}

_buffer_get () {
	eval "$1=\"\${_buffer${_buffer_level}:-}\""
	return "${2:-0}"
}


_buffer_start () {
	_declare_internal send _buffer
	_buffer_level="$((${_buffer_level:-0} + 1))"
}

_buffer () {
	eval "IFS=' ' _buffer$_buffer_level=\"\${_buffer$_buffer_level:-}\$*\""
	IFS="$_ifs"
}

_buffer_var () {
	_buffer_start

	if _shift_invoke 3 "$@"
	then _buffer_get "$1" $?
	else return $?
	fi

	_buffer_stop $?
}

_shift_invoke () {
	shift "$1"
	$@
}

_silent () {
	$@ >/dev/null 2>&1
}

_var () {
	case $2 in
		'=' ) eval "$1=\"\${3:-}\"";;
		':' ) _buffer_var $@;;
		'$' ) eval "$1=\"\${4${3:-}${5:+\"}${5:-}${5:+\"}${6:-}}\"";;
	esac
}

_length () {
	send "${#1}"
}