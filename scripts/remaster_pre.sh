#!/bin/sh

# Path to molecules.git dir
KOGAION_MOLECULE_HOME="${KOGAION_MOLECULE_HOME:-/kogaion}"
export KOGAION_MOLECULE_HOME

PKGS_DIR="${KOGAION_MOLECULE_HOME}/pkgcache"
CHROOT_PKGS_DIR="${CHROOT_DIR}/var/lib/entropy/client/packages"

[[ ! -d "${PKGS_DIR}" ]] && mkdir -p "${PKGS_DIR}"
[[ ! -d "${CHROOT_PKGS_DIR}" ]] && mkdir -p "${CHROOT_PKGS_DIR}"

# make sure it's all clean before mounting
echo "Mounting bind to ${CHROOT_PKGS_DIR}"
mkdir -p "${CHROOT_PKGS_DIR}" || exit 1
mount --bind "${PKGS_DIR}" "${CHROOT_PKGS_DIR}" || exit 1

content=$(ls -1 "${CHROOT_DIR}/proc" | wc -l)
if [ "${content}" -le 3 ]; then
	echo "Mounting /proc ..."
	mount -t proc proc "${CHROOT_DIR}/proc"
fi

exit 0
