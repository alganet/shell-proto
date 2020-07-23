codename "use"
==============

"Language" reference:

Declaring Functions

-------------------

The same as in shell script

```sh
my_function () {
	echo 123
}
```

Declaring Variables
-------------------

```sh
my_function () {
	local my_text=
	
	send $my_text
}
```

Creating Tests
--------------

```sh
test_my_function () {
	assert true = true
}
```
