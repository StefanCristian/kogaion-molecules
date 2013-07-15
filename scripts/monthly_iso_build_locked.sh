#!/bin/sh

ROGENTOS_MOLECULE_HOME="${ROGENTOS_MOLECULE_HOME:-/sabayon}"

exec "${ROGENTOS_MOLECULE_HOME}/scripts/iso_build_locked.sh" \
    "monthly_iso_build.sh" "${@}"
