#!/usr/bin/env sh

_module () {
	test -n "${1:-}"
	test -n "${2:-}"

	_target_function="$1"
	_source_path="./${2%%_*}/${2#*_}.sh"
	_source_line=''
	_source_funcs="${_source_funcs:-}"

	test -f "${_source_path}"

	while read -r _source_line || test -n "${_source_line}"
	do
		_maybe_dependency="${_source_line#use }"

		if
			test "${_source_line}" = "use ${_maybe_dependency}" &&
			test "${_source_funcs}" = "${_source_funcs#*${_maybe_dependency}*}"
		then
			_source_funcs="${_source_funcs:-}	${_maybe_dependency}"
			_module $_target_function "${_maybe_dependency}"
			unset _maybe_dependency
			continue
		fi

		_maybe_function_name="${_source_line%' () {'}"

		if test "${_source_line}" = "${_maybe_function_name} () {"
		then
			_source_funcs="${_source_funcs:-}	${_maybe_function_name}"
			_source_code="${_source_code:-}
				_declare_external ${_maybe_function_name}
				__${_source_line}"
			unset _maybe_function_name
			continue
		fi

		_source_code="${_source_code:-}
			${_source_line}"
	done < "${_source_path}"

	unset _source_line

	_source_code="${_source_code:-}
		_source_funcs='${_source_funcs}'"

	$_target_function "${_source_code:-}"
}
