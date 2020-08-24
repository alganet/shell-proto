
string_sub () {
	local string="$1" start="$2" count="$3" result=

	while test "$start" -gt 0
	do 
		var string $ '#' "$string" '' '?'
		var start = $((start - 1))
	done

	while test $count -gt 0
	do
		var tail $ '#' "$string" '' '?'
		var first_char $ '%' "$string" "$tail"
		var result = "${result}${first_char}"
		var string = "$tail"
		var count = $((count - 1))
	done

	send "$result"
}

