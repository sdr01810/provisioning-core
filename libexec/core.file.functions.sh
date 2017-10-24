#!/bin/sh source'd
##

[ -z "$core_file_functions_p" ] || return 0 ; core_file_functions_p=t

source core.util.functions.sh

##

function remove_everything_in_directory_tree() { # directory_pn

	local d1="${1:?missing argument: directory_pn}"

	xx find -H "$d1" -mindepth 1 -delete
}

function remove_all_dirs_in_directory_tree() { # directory_pn

	local d1="${1:?missing argument: directory_pn}"

	xx find -H "$d1" -mindepth 1 -type d -delete
}

function remove_non_dirs_in_directory_tree() { # directory_pn

	local d1="${1:?missing argument: directory_pn}"

	xx find -H "$d1" -mindepth 1 ! -type d -delete
}

##

function scrub_system_log_files() {

	local d1

	for d1 in /var/log ; do
		[ -e "$d1" ] || continue

		xx ls -AHl "$d1"
		remove_non_dirs_in_directory_tree "$d1"
	done
}

function scrub_system_tmp_files() {

	local d1

	for d1 in /var/tmp /tmp ; do
		[ -e "$d1" ] || continue

		remove_everything_in_directory_tree "$d1"
	done
}

##
