string_bla () {
	send "bla"
}

string_starts_with () {
	local haystack=$1 needle=$2

	test "$haystack" = "$needle${haystack#$needle}"
}

string_ends_with () {
	local haystack=$1 needle=$2

	test "$haystack" = "${haystack%$needle}$needle"
}

string_contains () {
	local haystack=$1 needle=$2

	test "$haystack" != "${haystack#*"$needle"*}"
}

string_length_bytes () {
	send "${#1}"
}

string_position_bytes () {
	local haystack=$1 needle=$2 piece=

	var piece = "${haystack%"$needle"*}"

	if test "$piece" = "$haystack"
	then
		return 1
	fi

	send "${#piece}"
}