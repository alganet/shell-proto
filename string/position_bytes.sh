
string_position_bytes () {
	local haystack="$1" needle="$2" piece=

	var piece $ '%' "$haystack" "$needle" "*"

	if test "$piece" = "$haystack"
	then
		return 1
	fi

	while test "$piece" != "$haystack"
	do
		var haystack = "$piece"
		var piece $ '%' "$haystack" "$needle" "*"
	done

	length "${piece}"
}
