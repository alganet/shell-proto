


foo="Hello"
bar="$(echo $foo)"
echo $bar


cont=1000
while test $cont -gt 0
do
	foo="Hello"
	bar="$(echo $foo)"
	echo $bar

	cont=$((cont - 1))
done > /dev/null

