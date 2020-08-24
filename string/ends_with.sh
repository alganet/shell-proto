string_ends_with () {
	local result=

	var result $ '%' "$1" "$2"

	test "$1" = "${result}${2}"
}

