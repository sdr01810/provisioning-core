#!/bin/sh source'd
##

[ -z "$core_user_functions_p" ] || return 0 ; core_user_functions_p=t

source core.util.functions.sh
source core.group.functions.sh
source core.pathname.functions.sh

##

function is_existing_user() { # user_name

	getent passwd "${1:?}" >/dev/null 2>&1
}

function provision_user() { # user_name gecos_info group_name ...

	local user_name="${1:?}" ; shift
	local gecos_info="${1:?}" ; shift

	if ! is_existing_user "${user_name}" ; then

		case "$(os_release ID)" in
		alpine)
			xx adduser -g "${gecos_info}" -D "${user_name}"
			;;

		centos|fedora|rhel)
			xx adduser --comment "${gecos_info}" "${user_name}"
			;;

		debian|ubuntu)
			xx adduser --gecos "${gecos_info}" --disabled-password "${user_name}"
			;;
		esac
	fi

	xx passwd -l "${user_name}"

	add_group_memberships_for_user "${user_name}" "$@"

	provision_file_for_user "${user_name}" .gitconfig share/git/config-for-user-"${user_name}"

	provision_file_for_user "${user_name}" .quiltrc share/quilt/config-for-user-"${user_name}"
}

##

add_group_memberships_for_user() { # user_name group_name ...

	local user_name="${1:?}" ; shift
	local g1

	for g1 in "$@" ; do

		is_existing_group "$g1" || continue

		xx usermod --append --groups "$g1" "${user_name}"
	done
}

##

function provision_file_for_user() { # user_name user_file_pn user_file_template_pn

	local user_name="${1:?}"
	local user_file_pn="${2:?}"
	local user_file_template_pn="${3:?}"
	local d1

	if ! is_existing_user "${user_name}" ; then

		echo 1>&2 "user does not exist: ${user_name}"
		false
	fi

	if ! is_absolute_pathname "${user_file_pn}" ; then

		d1="$(home_directory_of_user "${user_name}")"

		user_file_pn="${d1}/${user_file_pn}"
	fi

	if ! is_absolute_pathname "${user_file_template_pn}" ; then

		for d1 in \
			"${provisioning_root_dpn:?}" \
			"${provisioning_core_root_dpn:?}" \
		;do
			! [ -e "${d1}/${user_file_template_pn}" ] || break
		done

		user_file_template_pn="${d1}/${user_file_template_pn}"
	fi

	xx cp "${user_file_template_pn}" "${user_file_pn}"
	xx chown "${user_name}:${user_name}" "${user_file_pn}"
	xx chmod 0600 "${user_file_pn}"
}

##

function home_directory_of_user() {

	local result="$(getent passwd "${1:?}" | cut -d: -f 6)"

	echo "$result" ; [ -n "$result" ]
}

##

function name_of_devops_user() {

	case "${provisioning_xc_type}" in
	vagrant)
		echo vagrant
		;;
	*|'')
		echo devops
		;;
	esac
}

function name_of_devops_group() {

	name_of_devops_user
}

function provision_devops_user() {

	provision_user "$(name_of_devops_user)" "DevOps Administrator,,," $(list_standard_devops_groups)
}

##

