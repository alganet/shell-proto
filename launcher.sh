#!/usr/bin/env sh

. internal/compat.sh
_compat

# remover subshell plz n pod
eval "$(
	_translate_file echo $1
)"

shift

$@

