#!/bin/sh
PKGS_DIR="/sabayon/pkgcache"
CHROOT_PKGS_DIR="${CHROOT_DIR}/var/lib/entropy/client/packages"

[[ ! -d "${PKGS_DIR}" ]] && mkdir -p "${PKGS_DIR}"
[[ ! -d "${CHROOT_PKGS_DIR}" ]] && mkdir -p "${CHROOT_PKGS_DIR}"

# make sure it's all clean before mounting
rm -rf "${CHROOT_PKGS_DIR}"/*
echo "Mounting bind to ${CHROOT_PKGS_DIR}"
mount --bind "${PKGS_DIR}" "${CHROOT_PKGS_DIR}" || exit 1

content=$(ls -1 "${CHROOT_DIR}/proc" | wc -l)
if [ "${content}" -le 3 ]; then
	mount -t proc proc "${CHROOT_DIR}/proc"
fi

rm "${CHROOT_DIR}/autorun.inf"
rm "${CHROOT_DIR}/sabayon.ico"
rm "${CHROOT_DIR}/sabayon.bat"
cp /sabayon/boot/core/autorun.inf "${CHROOT_DIR}/" || exit 1
cp /sabayon/boot/core/rogentos.ico "${CHROOT_DIR}/" || exit 1
cp /sabayon/boot/core/rogentos.bat "${CHROOT_DIR}/" || exit 1
mkdir "${CHROOT_DIR}/syslinux/"
cp -r /sabayon/boot/core/isolinux/* "${CHROOT_DIR}/syslinux/" || exit 1

exit 0
