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

	test "$haystack" != "${haystack#*$needle*}"
}

string_length_bytes () {
	send "${#1}"
}

string_position_bytes () {
	local haystack=$1 needle=$2 piece=

	var piece = ${haystack%"$needle"*}

	if test "$piece" = "$haystack"
	then
		return 1
	fi

	while test "$piece" != "$haystack"
	do
		haystack=$piece
		var piece = ${haystack%"$needle"*}
	done

	send "${#piece}"
}

string_position_reverse_bytes () {
	local haystack=$1 needle=$2 piece=

	var piece = ${haystack%"$needle"*}

	if test "$piece" = "$haystack"
	then
		return 1
	fi

	send "${#piece}"
}

string_sub () {
	local string=$1      \
		  start_count=$2 \
		  end_count=$3   \
		  sub_string=

	while test $start_count -gt 0
	do string="${string#?}" start_count=$((start_count - 1))
	done

	while test $end_count -gt 0
	do
		tail="${string#?}"
		first_char="${string%${tail}}"
		sub_string="${sub_string}${first_char}"
		string=$tail
		end_count=$((end_count - 1))
	done

	send $sub_string
}

