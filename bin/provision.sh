#!/bin/sh
## Provision the system.
##
## Usage:
##
##     sudo ./provision.sh xc_type
##
## Typical uses:
##
##     sudo ./provision.sh
##     sudo ./provision.sh native
##
##     sudo ./provision.sh docker
##
##     sudo ./provision.sh vagrant
##

if [ "$(id -u)" -ne 0 ] ; then
	echo 1>&2 "effective user is not root; aborting."
	exit 2
fi

case "$(grep '^ID=' /etc/os-release)" in
ID=debian|ID=ubuntu)
	case "$(readlink /bin/sh)" in
	dash|*/dash)
		update-alternatives --install /bin/sh sh /bin/bash 100
		exec "$0" "$@"
	esac
	;;
esac

##

set -e

provisioning_root_dpn="${provisioning_root_dpn:-${PWD:?}}" # global

provisioning_xc_type="${provisioning_xc_type:-${1:-native}}" # global

PATH="/opt/provisioning-core/libexec":"$PATH"

source core.package.functions.sh
source core.user.functions.sh

##

install_packages_needed && scrub_package_management_caches

provision_devops_user

