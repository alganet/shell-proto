echo ======= ALL NEW TESTS
{
	{ results="$(printf %s "$(dash ./tester.sh)")" ; echo "DASH $(echo "$results" | wc -l)	${results}"; }    # This is one of our main targets (dash é basicão)
	{ results="$(printf %s "$(ksh93 ./tester.sh)")" ; echo "KSH $(echo "$results" | wc -l) 	${results}"; }   
	{ results="$(printf %s "$(ksh ./tester.sh)")" ; echo "KSH2 $(echo "$results" | wc -l) 	${results}"; }     # This is one of our main targets (new ksh2020) <- https://github.com/att/ast/tree/2020.0.0
	{ results="$(printf %s "$(oksh ./tester.sh)")" ; echo "OKSH $(echo "$results" | wc -l)	${results}"; }
	{ results="$(printf %s "$(busybox sh ./tester.sh)")" ; echo "BBOX $(echo "$results" | wc -l)	${results}"; } # This is one of our main targets (android stuff)
	{ results="$(printf %s "$(mksh ./tester.sh)")" ; echo "MKSH $(echo "$results" | wc -l)	${results}"; }
	#{ results="$(printf %s "$(posh ./tester.sh)")" ; echo "POSH $(echo "$results" | wc -l)	${results}"; }
	{ results="$(printf %s "$(bash ./tester.sh)")" ; echo "BASH $(echo "$results" | wc -l)	${results}"; } # This is one of our main targets (it's damn popular)
	{ results="$(printf %s "$(yash ./tester.sh)")" ; echo "YASH $(echo "$results" | wc -l)	${results}"; }
	{ results="$(printf %s "$(zsh ./tester.sh)")" ; echo "ZSH $(echo "$results" | wc -l) 	${results}"; } # This is one of our main targets (it's popular, osx default)
}


exit

src="$(cat internal/compat.sh)
_compat
"

echo "$src
_source_file ./myapp.sh
myapp
" > bench_compiled

echo

echo ======= ALL OUTPUT TESTS
{
	{ echo "DASH	$(printf %q "$(dash bench_compiled)")" ;}    # This is one of our main targets (dash é basicão)
	{ echo "KSH 	$(printf %q "$(ksh93 bench_compiled)")" ;}   
	{ echo "KSH2 	$(printf %q "$(ksh bench_compiled)")" ;}     # This is one of our main targets (new ksh2020) <- https://github.com/att/ast/tree/2020.0.0
	{ echo "OKSH	$(printf %q "$(oksh bench_compiled)")" ;}
	{ echo "BBOX	$(printf %q "$(busybox sh bench_compiled)")" ;} # This is one of our main targets (android stuff)
	{ echo "MKSH	$(printf %q "$(mksh bench_compiled)")" ;}
	{ echo "POSH	$(printf %q "$(posh bench_compiled)")" ;}
	{ echo "BASH	$(printf %q "$(bash bench_compiled)")" ;} # This is one of our main targets (it's damn popular)
	{ echo "YASH	$(printf %q "$(yash bench_compiled)")" ;}
	{ echo "ZSH 	$(printf %q "$(zsh bench_compiled)")" ;} # This is one of our main targets (it's popular, osx default)
} | sort


echo ======= ALL DOCKER TESTS
{
	{ echo "BASH3.0	$(printf %q "$(docker run -it --rm -v "$(pwd):/use" -w "/use" bash:3.0 bash bench_compiled)")" ;}
	{ echo "BASH3.1	$(printf %q "$(docker run -it --rm -v "$(pwd):/use" -w "/use" bash:3.1 bash bench_compiled)")" ;}
	{ echo "BASH3.2	$(printf %q "$(docker run -it --rm -v "$(pwd):/use" -w "/use" bash:3.2 bash bench_compiled)")" ;}
	{ echo "BASH4.0	$(printf %q "$(docker run -it --rm -v "$(pwd):/use" -w "/use" bash:4.0 bash bench_compiled)")" ;}
	{ echo "BASH4.1	$(printf %q "$(docker run -it --rm -v "$(pwd):/use" -w "/use" bash:4.1 bash bench_compiled)")" ;}
	{ echo "BASH4.2	$(printf %q "$(docker run -it --rm -v "$(pwd):/use" -w "/use" bash:4.2 bash bench_compiled)")" ;}
	{ echo "BASH4.3	$(printf %q "$(docker run -it --rm -v "$(pwd):/use" -w "/use" bash:4.3 bash bench_compiled)")" ;}
	{ echo "BASH4.4	$(printf %q "$(docker run -it --rm -v "$(pwd):/use" -w "/use" bash:4.4 bash bench_compiled)")" ;}
	{ echo "BASH5.0	$(printf %q "$(docker run -it --rm -v "$(pwd):/use" -w "/use" bash:5.0 bash bench_compiled)")" ;}
	{ echo "BASHl	$(printf %q "$(docker run -it --rm -v "$(pwd):/use" -w "/use" bash:latest bash bench_compiled)")" ;}
	{ echo "BASHrc	$(printf %q "$(docker run -it --rm -v "$(pwd):/use" -w "/use" bash:rc bash bench_compiled)")" ;}
	{ echo "BASHdv	$(printf %q "$(docker run -it --rm -v "$(pwd):/use" -w "/use" bash:devel bash bench_compiled)")" ;}
} | sort


src="$(cat internal/compat.sh); _compat; "

echo "
cont=0
while test \$cont -lt 20
do
	cont=\$((cont + 1));
	$src
	_source_file ./myapp.sh
	myapp
done >/dev/null

myapp
" > bench_compiled

echo ======= FASTEST '(20 times)'

{
	{ echo -n "$(/usr/bin/env time -f'DASH	%e' dash bench_compiled >/dev/null)" ;}
	{ echo -n "$(/usr/bin/env time -f'KSH 	%e' ksh93 bench_compiled >/dev/null)" ;}
	{ echo -n "$(/usr/bin/env time -f'KSH2 	%e' ksh bench_compiled >/dev/null)" ;}
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
	{ /usr/bin/env time -f'KSH 	%e' dash bench_looper '/usr/bin/ksh93 bench_compiled' ;}
	{ /usr/bin/env time -f'KSH2	%e' dash bench_looper '/usr/bin/ksh bench_compiled' ;}
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
} 2>&1 | sort -n -k2

echo