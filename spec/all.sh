use string_contains
use string_ends_with
use string_position_bytes
use string_position_reverse_bytes
use string_starts_with
use string_sub

intermediate_send () {
	send "Foo"
}

intermediate_variable () {
	local myvar2=

	var myvar2 : send "Foo"

	send "$myvar2"
}

assert_var_assignment () {
	local myvar=

	var myvar = "Foo"

	test "Foo" = "$myvar"
}


assert_unquoted_param () {
	local myvar=

	var myvar = "Foo Bar"

	test "Foo Bar" = "$myvar"
}

assert_var_return () {
	local myvar=

	var myvar : send "Foo"
	
	test "Foo" = "$myvar"
}

assert_var_return_custom_func () {
	local myvar

	var myvar : intermediate_send "Foo"

	test "Foo" = "$myvar"
}

assert_var_return_nesting () {
	local myvar

	var myvar : intermediate_variable "Foo"

	test "Foo" = "$myvar"
}

assert_string_starts_with () {
	local haystack= needle= result=

	var haystack = "Hello World"
	var needle = "Hello"

	string_starts_with "$haystack" "$needle"
}


assert_string_starts_with_should_fail_when_not_starts_with () {
	local haystack= needle= result=

	var haystack = "Hello World"
	var needle = "Lorem"

	! var result : string_starts_with "$haystack" "$needle"
}


assert_string_ends_with () {
	local haystack= needle= result=

	var haystack = "Hello World"
	var needle = "World"

	var result : string_ends_with "$haystack" "$needle"
}

assert_string_ends_with_should_fail_when_not_ends_with () {
	local haystack= needle= result=

	var haystack = "Hello World"
	var needle = "Ipsum"

	! var result : string_ends_with "$haystack" "$needle"
}

assert_string_contains () {
	local haystack= needle= result=

	var haystack = "Hello World"
	var needle = "lo W"

	var result : string_contains "$haystack" "$needle"
}

assert_string_contains_should_fail_if_not_contains () {
	local haystack= needle= result=

	var haystack = "Hello World"
	var needle = "2222222222222"

	! var result : string_contains "$haystack" "$needle"
}

assert_length () {
	local target= hello_length=

	var target = "Hello"
	var hello_length : length "$target"

	test 5 = "$hello_length"
}

assert_string_position_reverse_bytes () {
	local haystack= needle= world_position=

	var haystack = "Hello World"
	var needle = "World"

	var world_position : string_position_reverse_bytes "$haystack" "$needle"

	test 6 = "$world_position"
}

assert_string_position_reverse_bytes_beginning () {
	local haystack= needle= world_position=

	var haystack = "Hello World"
	var needle = "Hello"

	var world_position : string_position_reverse_bytes "$haystack" "$needle"

	test 0 = "$world_position"
}

assert_string_position_reverse_bytes_duplicate () {
	local haystack= needle= world_position=

	var haystack = "Hello World World"
	var needle = "World"

	var world_position : string_position_reverse_bytes "$haystack" "$needle"

	test 12 = "$world_position"
}

assert_string_position_bytes () {
	local haystack= needle= world_position=

	var haystack = "Hello World"
	var needle = "World"

	var world_position : string_position_bytes "$haystack" "$needle"

	test 6 = "$world_position"
}

assert_string_position_bytes_beginning () {
	local haystack= needle= world_position=1

	var haystack = "Hello World"
	var needle = "Hello"

	var world_position : string_position_bytes "$haystack" "$needle"

	test 0 = "$world_position"
}

assert_string_position_bytes_duplicate () {
	local haystack= needle= world_position=

	var haystack = "Hello World World"
	var needle = "World"

	var world_position : string_position_bytes "$haystack" "$needle"

	test 6 = "$world_position"
}


assert_string_position_reverse_bytes_no_contains () {
	local haystack needle world_position

	var haystack = "Hello World"
	var needle = "Lorem"

	! var world_position : string_position_reverse_bytes "$haystack" "$needle"
}

assert_string_position_bytes_no_contains () {
	local haystack needle world_position

	var haystack = "Hello World"
	var needle = "Lorem"

	! var world_position : string_position_bytes "$haystack" "$needle"
}

#substr
assert_string_sub_happy_path () {
	local haystack sub_string

	var haystack = "Hello World"

	var sub_string : string_sub $haystack 2 5

	# TODO REMOVE QUOTES
	test "llo W" = "$sub_string"
}


assert_var_subst () {
	local result=

	var result $ '#' "foo bar baz" 'foo'
	test " bar baz" = "$result"
}


assert_var_subst2 () {
	local result=

	var result $ '##*' "foo foo bar baz" 'foo '
	test "bar baz" = "$result"
}

assert_var_subst3 () {
	local result=

	var result $ '%' "foo foo bar baz" 'baz'
	test "foo foo bar " = "$result"
}

assert_var_subst4 () {
	local result=

	var result $ '%%' "foo foo bar baz baz" 'baz' "*"
	test "foo foo bar " = "$result"
}

assert_var_subst5 () {
	local result=

	var result $ '%%*' "foo foo bar baz baz" 'baz' "*"
	test -z "$result"
}
