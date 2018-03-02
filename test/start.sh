#!/bin/sh
## Entry point for the Docker container.
##

set -e

umask 0002

function xx() {
	echo "+" "$@"
	"$@"
}

function printenv_sorted() {
	xx printenv | xx env LC_ALL=C sort
}

##

echo
echo "Environment variables:"
xx :
printenv_sorted

##

xx :
xx cd "${provisioning_core_docker_image_home}"

if [ $# -gt 0 ] ; then
	echo
	echo "Running command..."
	xx :
	xx exec "$@"
else
if [ -t 0 ] ; then
	echo
	echo "Launching shell..."
	xx :
	xx exec sh -l
fi;fi

##

