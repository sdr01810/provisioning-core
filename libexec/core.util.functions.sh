#!/bin/sh source'd
##

[ -z "$core_util_functions_p" ] || return 0 ; core_util_functions_p=t

##

[ -n "${provisioning_root_dpn}" ] ||
provisioning_root_dpn="${PWD:?}" # global

[ -n "${provisioning_core_root_dpn}" ] ||
provisioning_core_root_dpn="/opt/provisioning-core" # global

##

function xx() {

	echo 1>&2 "+" "$@"
	"$@"
}

function xxq() {

	xx "$@"
}

function xxv() {

	xx "$@" || echo 1>&2 "+" "FAILED: $?"
}

##

function os_release() { (

	source /etc/os-release

	for vn in "$@" ; do

		eval "echo \${${vn}}"
	done

)}

##

