echo ======= ALL NEW TESTS
{
	{ results="$(printf %s "$(bash $@ 2>/dev/null)")" ; echo "BASH $(echo "$results" | wc -l)	$(echo "${results}" | grep "not ok")"; } &
	{ results="$(printf %s "$(busybox sh $@ 2>/dev/null)")" ; echo "BBOX $(echo "$results" | wc -l)	$(echo "${results}" | grep "not ok")"; } &
	{ results="$(printf %s "$(dash $@ 2>/dev/null)")" ; echo "DASH $(echo "$results" | wc -l)	$(echo "${results}" | grep "not ok")"; } &
	{ results="$(printf %s "$(ksh $@ 2>/dev/null)")" ; echo "KSH2 $(echo "$results" | wc -l) 	$(echo "${results}" | grep "not ok")"; } &
	{ results="$(printf %s "$(ksh93 $@ 2>/dev/null)")" ; echo "KSH $(echo "$results" | wc -l) 	$(echo "${results}" | grep "not ok")"; } &
	{ results="$(printf %s "$(mksh $@ 2>/dev/null)")" ; echo "MKSH $(echo "$results" | wc -l)	$(echo "${results}" | grep "not ok")"; } &
	{ results="$(printf %s "$(oksh $@ 2>/dev/null)")" ; echo "OKSH $(echo "$results" | wc -l)	$(echo "${results}" | grep "not ok")"; } &
	{ results="$(printf %s "$(yash $@ 2>/dev/null)")" ; echo "YASH $(echo "$results" | wc -l)	$(echo "${results}" | grep "not ok")"; } &
	{ results="$(printf %s "$(zsh $@ 2>/dev/null)")" ; echo "ZSH $(echo "$results" | wc -l) 	$(echo "${results}" | grep "not ok")"; } &
	wait
}

exit
