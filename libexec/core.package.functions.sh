#!/bin/sh source'd
##

[ -z "$core_package_functions_p" ] || return 0 ; core_package_functions_p=t

source core.util.functions.sh

##

function list_packages_needed() {

	local standard_provisioning_helpers="bash bzip2 curl diffutils git less patchutils rsync tar vim"
	(
		for p1 in ${standard_provisioning_helpers} ; do echo "$p1" ; done

		cat "${provisioning_root_dpn:?}"/conf/packages.needed.*.txt | egrep -v '^\s*#'

	) | sort -u
}

function install_packages() { # package_name ...

	case "$(os_release ID)" in
	alpine)
		xx apk update
		xx apk add shadow
		xx apk add "$@"
		;;

	centos|fedora|rhel)
		xx yum update -y
		xx yum install -y epel-release
		xx yum install -y "$@"
		;;

	debian|ubuntu)
		xx apt-get update
		xx apt-get install -y apt-utils debconf
		xx apt-get install -y "$@"
		;;
	*|'')
		echo 1>&2 "unrecognized OS release ID; aborting"
		exit 2
		;;
	esac
}

function install_packages_needed() {

	install_packages $(list_packages_needed)
}

function scrub_package_management_caches() {

	case "$(os_release ID)" in
	alpine)
		rm -rf /var/cache/apk/* # package lists
		! [ -e /etc/apk/cache ] || rm -rf /etc/apk/cache/*
		;;

	centos|fedora|rhel)
		yum clean all
		;;

	debian|ubuntu)
		rm -rf /var/lib/apt/lists/* # package lists
		! [ -e /var/cache/apt ] || rm -rf /var/cache/apt/*
		;;
	esac
}

##
