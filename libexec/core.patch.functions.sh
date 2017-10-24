#!/bin/sh source'd
##

[ -z "$core_patch_functions_p" ] || return 0 ; core_patch_functions_p=t

source core.util.functions.sh

##

function apply_patch() { # patch_fpn target_dpn

	local p1 f2

	for p1 in "${1:?}" ; do
	for f2 in "${2:?}/$(basename "$p1" .patch)" ; do
	(
		[ -e "$p1" ] || continue
		[ -e "$f2" -a ! -e "$f2".orig ] || continue

		cd "$(dirname "$f2")"

		xx cp -p "$f2"{,.orig}

		xx patch -p1 --fuzz 10 -i "$p1" || xx mv "$f2"{.orig,}
	)
	done;done
}

