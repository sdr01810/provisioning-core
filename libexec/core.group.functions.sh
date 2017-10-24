#!/bin/sh source'd
##

[ -z "$core_group_functions_p" ] || return 0 ; core_group_functions_p=t

source core.util.functions.sh

##

function is_existing_group() { # group_name

	getent group "${1:?}" >/dev/null 2>&1
}

function provision_group() { # group_name

	echo 1>&2 "not yet implemented: provision_group" # XXX: stub
	false
}

##

function list_standard_admin_groups() {

	local g1

	case "$(os_release ID)" in
	alpine)
		for g1 in wheel ; do # XXX: stub
			echo "$g1"
		done
		;;

	centos|fedora|rhel)
		for g1 in wheel ; do # XXX: stub
			echo "$g1"
		done
		;;

	debian|ubuntu)
		for g1 in cdrom dip lpadmin plugdev sambashare ; do
			echo "$g1"
		done
		;;
	esac

	for g1 in adm docker libvirtd root sudo ; do
		echo "$g1"
	done
}

function list_standard_staff_groups() {

	local g1

	case "$(os_release ID)" in
	alpine)
		for g1 in users ; do
			echo "$g1"
		done
		;;

	centos|fedora|rhel)
		for g1 in users ; do
			echo "$g1"
		done
		;;

	debian|ubuntu)
		for g1 in staff ; do
			echo "$g1"
		done
		;;
	esac
}

function list_standard_devops_groups() {

	list_standard_admin_groups
	list_standard_staff_groups
}

##

