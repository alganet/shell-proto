tap_suite () {
	_module eval $1
	IFS='	'
	set -- ${_source_funcs:-}
	IFS="$_ifs"

	while test $# -gt 0
	do
		tap_suite_line "$1"
		shift
	done
}

tap_suite_line () {
	if test "$1" = "assert_${1#assert_}"
	then
		$1 &&
			_send "ok	${1}\n" ||
			_send "not ok	${1}\n"
	fi
}