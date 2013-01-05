#!/bin/sh

# Path to molecules.git dir
ROGENTOS_MOLECULE_HOME="${ROGENTOS_MOLECULE_HOME:-/sabayon}"
export ROGENTOS_MOLECULE_HOME

exec "${ROGENTOS_MOLECULE_HOME}"/scripts/mkloopcard.sh "${ROGENTOS_MOLECULE_HOME}"/scripts/mkloopcard_beaglebone_chroot_hook.sh "$@"
