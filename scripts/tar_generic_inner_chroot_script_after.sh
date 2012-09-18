#!/bin/bash

/usr/sbin/env-update && source /etc/profile

# Generate list of installed packages
equo query list installed -qv > /etc/rogentos-pkglist

# remove hw hash
rm -f /etc/entropy/.hw.hash
# remove entropy pid file
rm -f /var/run/entropy/entropy.lock

exit 0
