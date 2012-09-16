#!/bin/sh

/usr/sbin/env-update
. /etc/profile

rc-update del installer-gui boot
rc-update del x-setup boot
rc-update del hald boot
rc-update del avahi-daemon default

# A RUNNING NetworkManager is required by Anaconda !!
# re-enable rc_hotplug
# sed -i 's:^rc_hotplug=.*:rc_hotplug="*":g' /etc/rc.conf
# rc-update del NetworkManager default

# install-data dir is really not needed
rm -rf /install-data

mount -t proc proc /proc
/lib/rc/bin/rc-depend -u

# Generate openrc cache
touch /lib/rc/init.d/softlevel
[[ -d "/run/openrc" ]] && touch /run/openrc/softlevel
/etc/init.d/savecache start
/etc/init.d/savecache zap

ldconfig
ldconfig
umount /proc

emaint --fix world

rm -rf /var/lib/entropy/*cache*

exit 0
