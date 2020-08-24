string_contains () {
	local result=

	var result $ '#*' "$1" "$2" "*"

	test "$1" != "${result}"
}
