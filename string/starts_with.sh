string_starts_with () {
	local result=

	var result $ '#' "$1" "$2"

	test "$1" = "${2}${result}"
}
