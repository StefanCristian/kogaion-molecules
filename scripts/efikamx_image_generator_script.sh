#!/bin/sh

export BOOT_PART_MKFS_ARGS="-L boot"
export BOOT_PART_TYPE=ext3
export BOOT_PART_TYPE_MBR=83
export BOOT_PART_TYPE_INSIDE_ROOT=1
export ROOT_PART_TYPE=ext4
export MAKE_TARBALL=0

# Path to molecules.git dir
ROGENTOS_MOLECULE_HOME="${ROGENTOS_MOLECULE_HOME:-/sabayon}"
export ROGENTOS_MOLECULE_HOME

exec "${ROGENTOS_MOLECULE_HOME}"/scripts/mkloopcard.sh "${ROGENTOS_MOLECULE_HOME}"/scripts/mkloopcard_efikamx_chroot_hook.sh "$@"
