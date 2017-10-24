#!/bin/sh source'd
##

[ -z "$core_pathname_functions_p" ] || return 0 ; core_pathname_functions_p=t

source core.util.functions.sh

##

function is_absolute_pathname() { # pathname

	case "${1:?}" in
	/*) true ;; *) false ;;
	esac
}

##

