#!/bin/sh
## Entry point for the Docker container.
##

set -e

xx() {
	echo "+" "$@"
	"$@"
}

printenv_sorted() {
	xx printenv | xx env LC_ALL=C sort
}

##

echo
echo "Environment variables:"
xx :
printenv_sorted

xx :
xx pwd

xx :
xx ls -al

xx :
xx ls -al /opt/provisioning-core

##

echo
echo "Launching a shell..."
xx :
xx sh -l

##

