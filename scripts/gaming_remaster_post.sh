#!/bin/sh

# execute parent script
/rogentos/scripts/remaster_post.sh $@

# Christmas TIME !
GAMING_XMAS_DIR="/rogentos/remaster/gaming-xmas"
cp "${GAMING_XMAS_DIR}"/rogentoslinux.png "${CHROOT_DIR}/usr/share/backgrounds/rogentoslinux.png"
cp "${GAMING_XMAS_DIR}"/rogentoslinux.jpg "${CHROOT_DIR}/usr/share/backgrounds/rogentoslinux.jpg"
cp "${GAMING_XMAS_DIR}"/rogentoslinux.jpg "${CHROOT_DIR}/usr/share/backgrounds/kgdm.jpg"
