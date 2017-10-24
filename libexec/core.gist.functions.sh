#!/bin/sh source'd
##

[ -z "$core_gist_functions_p" ] || return 0 ; core_gist_functions_p=t

source core.util.functions.sh

##

provisioning_core_gist_script_fpn="${provisioning_core_root_dpn:?}"/bin/gist.script-thunk.sh # global

##

function install_gist() { # gist_name_stem gist_repo_url

	local gist_name_stem="${1:?}"
	local gist_repo_url="${2:?}"

	local gist_sandbox_dpn="${gist_name_stem}".gist.d
	local gist_main_script_fbn="${gist_name_stem}".sh

	if ! [ -e "${gist_sandbox_dpn}" ] ; then

		xx git clone "${gist_repo_url}" "${gist_sandbox_dpn}"
	else
	(
		cd "${gist_sandbox_dpn}" 2>&-

		echo ; pwd

		xx git reset --hard
		xx git clean -f -d
	)
	fi

	xx ln -snf "${provisioning_core_gist_script_fpn:?}" "${gist_main_script_fbn}"
}

