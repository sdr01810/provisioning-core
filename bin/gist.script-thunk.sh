#!/bin/sh
## Delegate to a gist-provided script.
##

set -e

this_delegate="${0%.sh}.gist.d/${0##*/}"

##

chmod +rx "${this_delegate}"

exec "${this_delegate}" "$@"

