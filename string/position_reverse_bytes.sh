
string_position_reverse_bytes () {
	local haystack="$1" needle="$2" piece=

	var piece $ '%' "$haystack" "$needle" "*"

	if test "$piece" = "$haystack"
	then
		return 1
	fi

	length "${piece}"
}
