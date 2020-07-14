#!/usr/bin/env sh

. internal/compat.sh
_compat
_source_file $1
funcs
${1%'.sh'}
