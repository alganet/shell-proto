
src="$(cat internal/compat.sh)"

echo "
$src
. ./myapp.sh
_declare_external myapp
_declare_external myapp_foo
_declare_external myapp_hello
myapp
" > bench_compiled

echo ======= ALL OUTPUT TESTS
{
	{ echo "DASH	$(printf %q "$(dash bench_compiled)")" ;}
	{ echo "KSH 	$(printf %q "$(ksh bench_compiled)")" ;}
	{ echo "OKSH	$(printf %q "$(oksh bench_compiled)")" ;}
	{ echo "BBOX	$(printf %q "$(busybox sh bench_compiled)")" ;}
	{ echo "MKSH	$(printf %q "$(mksh bench_compiled)")" ;}
	{ echo "POSH	$(printf %q "$(posh bench_compiled)")" ;}
	{ echo "BASH	$(printf %q "$(bash bench_compiled)")" ;}
	{ echo "YASH	$(printf %q "$(yash bench_compiled)")" ;}
	{ echo "ZSH 	$(printf %q "$(zsh bench_compiled)")" ;}
} | sort

src="$(cat internal/compat.sh)"

echo "
cont=0
while test \$cont -lt 20; do cont=\$((cont + 1));
$src
. ./myapp.sh
_declare_external myapp
_declare_external myapp_foo
_declare_external myapp_hello
myapp
done >/dev/null
myapp
" > bench_compiled

echo ======= FASTEST '(20 times)'

{
	{ echo -n "$(/usr/bin/env time -f'DASH	%e' dash bench_compiled >/dev/null)" ;}
	{ echo -n "$(/usr/bin/env time -f'KSH 	%e' ksh bench_compiled >/dev/null)" ;}
	{ echo -n "$(/usr/bin/env time -f'OKSH	%e' oksh bench_compiled >/dev/null)" ;}
	{ echo -n "$(/usr/bin/env time -f'BBOX	%e' busybox sh bench_compiled >/dev/null)" ;}
	{ echo -n "$(/usr/bin/env time -f'MKSH	%e' mksh bench_compiled >/dev/null)" ;}
	{ echo -n "$(/usr/bin/env time -f'POSH	%e' posh bench_compiled >/dev/null)" ;}
	{ echo -n "$(/usr/bin/env time -f'BASH	%e' bash bench_compiled >/dev/null)" ;}
	{ echo -n "$(/usr/bin/env time -f'YASH	%e' yash bench_compiled >/dev/null)" ;}
	{ echo -n "$(/usr/bin/env time -f'ZSH 	%e' zsh bench_compiled >/dev/null)" ;}
} 2>&1 | sort -n -k2

echo ======= FASTEST INIT BENCH '(20 times)'

echo "cont=0
while test \$cont -lt 20; do cont=\$((cont + 1));

eval \"\$1\"

done
" > bench_looper

echo "
$src
" > bench_compiled

{
	{ /usr/bin/env time -f'DASH	%e' dash bench_looper '/bin/dash bench_compiled' ;}
	{ /usr/bin/env time -f'KSH 	%e' dash bench_looper '/usr/bin/ksh bench_compiled' ;}
	{ /usr/bin/env time -f'OKSH	%e' dash bench_looper '/usr/bin/oksh bench_compiled' ;}
	{ /usr/bin/env time -f'BBOX	%e' dash bench_looper '/bin/busybox sh bench_compiled' ;}
	{ /usr/bin/env time -f'MKSH	%e' dash bench_looper '/bin/mksh bench_compiled' ;}
	{ /usr/bin/env time -f'POSH	%e' dash bench_looper '/usr/bin/posh bench_compiled' ;}
	{ /usr/bin/env time -f'BASH	%e' dash bench_looper '/bin/bash bench_compiled' ;}
	{ /usr/bin/env time -f'YASH	%e' dash bench_looper '/usr/bin/yash bench_compiled' ;}
	{ /usr/bin/env time -f'ZSH 	%e' dash bench_looper '/usr/bin/zsh bench_compiled' ;}
	{ /usr/bin/env time -f'PYT2	%e' dash bench_looper "/usr/bin/python2 -c ''" ;}
	{ /usr/bin/env time -f'PYT3	%e' dash bench_looper "/usr/bin/python3 -c ''" ;}
	{ /usr/bin/env time -f'PHP 	%e' dash bench_looper "/usr/bin/php -r ';'" ;}
	{ /usr/bin/env time -f'PERL	%e' dash bench_looper "/usr/bin/perl -E ''" ;}
	{ /usr/bin/env time -f'NODE	%e' dash bench_looper "/home/ubuntu/.asdf/installs/nodejs/13.3.0/bin/node -e ''" ;}
} 2>&1 | sort -n -k2

echo