
myapp () {
	local foo bar err

	var foo : myapp_foo y
	var foo : myapp_foo x
	bar=$foo

	send $foo
	send 'ok inner bufferx' 'zooz\n'
}

myapp_foo () {
	local foo bar hello

	send 'ok inner buffer2\n'

	var foo = 'ok buffer foo\n'
	var bar = 'ok buffer append bar\n'
	var bar = '>'${#IFS}'ok buffer append bar2\n'

	var hello : myapp_hello hello

	send $foo
	send $hello
	send $bar
}

myapp_hello () {
	local foo bar

	if ! test $_buffer_level -lt 5
	then 
		var foo = "${1:-}"
	else
		var foo : myapp_hello "$1a	a$1"
	fi

	send ${foo:-} NOTHERE
}
