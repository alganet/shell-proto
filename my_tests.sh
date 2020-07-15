_intermediate_send () {
	send "Foo"
}

_intermediate_variable () {
	local myvar2

	var myvar2 : send "Foo"

	send "$myvar2"
}

test_var_assignment () {
	local myvar

	var myvar = "Foo"

	test "Foo" = $myvar
}

test_var_return () {
	local myvar

	var myvar : send "Foo"
	
	test "Foo" = $myvar
}

test_var_return_custom_func () {
	local myvar

	var myvar : _intermediate_send "Foo"

	test "Foo" = $myvar
}

test_var_return_nesting () {
	local myvar

	var myvar : _intermediate_variable "Foo"

	test "Foo" = $myvar
}

# ========

test_string_bla () {
	local bla

	var bla : string_bla

	test $bla = "bla" 
}

test_string_starts_with () {
	local haystack needle result

	var haystack = "Hello World"
	var needle = "Hello"

	var result : string_starts_with $haystack $needle
}

test_string_starts_with_should_fail_when_not_starts_with () {
	local haystack needle result

	var haystack = "Hello World"
	var needle = "Lorem"

	! var result : string_starts_with $haystack $needle
}


test_string_ends_with () {
	local haystack needle result

	var haystack = "Hello World"
	var needle = "World"

	var result : string_ends_with $haystack $needle
}

test_string_ends_with_should_fail_when_not_ends_with () {
	local haystack needle result

	var haystack = "Hello World"
	var needle = "Ipsum"

	! var result : string_ends_with $haystack $needle
}

test_string_contains () {
	local haystack needle result

	var haystack = "Hello World"
	var needle = "lo W"

	var result : string_contains $haystack $needle
}

test_string_contains_should_fail_if_not_contains () {
	local haystack needle result

	var haystack = "Hello World"
	var needle = "2222222222222"

	! var result : string_contains $haystack $needle
}

test_string_length_bytes () {
	local target hello_length

	var target = "Hello"

	var hello_length : string_length_bytes $target

	test 5 = $hello_length
}

test_string_position_bytes () {
	local haystack needle world_position

	var haystack = "Hello World"
	var needle = "World"

	var world_position : string_position_bytes $haystack $needle

	test 6 = $world_position
}

test_string_position_bytes_beginning () {
	local haystack needle world_position

	var haystack = "Hello World"
	var needle = "Hello"

	var world_position : string_position_bytes $haystack $needle

	test 0 = $world_position
}

# strpos
# strrpos
test_string_position_bytes_no_contains () {
	local haystack needle world_position

	var haystack = "Hello World"
	var needle = "Lorem"

	! var world_position : string_position_bytes $haystack $needle
}

#substr
test_string_sub_happy_path () {
	local haystack sub_string

	var haystack = "Hello World"

	var sub_string : string_sub $haystack 2 5

	# TODO REMOVE QUOTES
	test "llo W" = "$sub_string"
}


#substr -1
# TODO test_string_sub_reverse

