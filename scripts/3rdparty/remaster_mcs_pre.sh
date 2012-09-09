#!/bin/sh

# call parent script
/rogentos/scripts/remaster_pre.sh

# copy mcs data over
mkdir -p "${CHROOT_DIR}/.mcs"
cp /rogentos/remaster/mcs/* "${CHROOT_DIR}"/.mcs/ -Rap

# setup non-interactive mode
echo "ETP_NONINTERACTIVE=1" > "${CHROOT_DIR}"/etc/env.d/00mcs-etp-noninteractive

exit 0
