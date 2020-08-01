echo ======= ALL NEW TESTS
{
	{ results="$(printf %s "$(dash $@)")" ; echo "DASH $(echo "$results" | wc -l)	${results}"; }    # This is one of our main targets (dash é basicão)
	{ results="$(printf %s "$(ksh93 $@)")" ; echo "KSH $(echo "$results" | wc -l) 	${results}"; }   
	{ results="$(printf %s "$(ksh $@)")" ; echo "KSH2 $(echo "$results" | wc -l) 	${results}"; }     # This is one of our main targets (new ksh2020) <- https://github.com/att/ast/tree/2020.0.0
	{ results="$(printf %s "$(oksh $@)")" ; echo "OKSH $(echo "$results" | wc -l)	${results}"; }
	{ results="$(printf %s "$(busybox sh $@)")" ; echo "BBOX $(echo "$results" | wc -l)	${results}"; } # This is one of our main targets (android stuff)
	{ results="$(printf %s "$(mksh $@)")" ; echo "MKSH $(echo "$results" | wc -l)	${results}"; }
	#{ results="$(printf %s "$(posh $@)")" ; echo "POSH $(echo "$results" | wc -l)	${results}"; }
	{ results="$(printf %s "$(bash $@)")" ; echo "BASH $(echo "$results" | wc -l)	${results}"; } # This is one of our main targets (it's damn popular)
	{ results="$(printf %s "$(yash $@)")" ; echo "YASH $(echo "$results" | wc -l)	${results}"; }
	{ results="$(printf %s "$(zsh $@)")" ; echo "ZSH $(echo "$results" | wc -l) 	${results}"; } # This is one of our main targets (it's popular, osx default)
}

exit
