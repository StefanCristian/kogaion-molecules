#!/bin/sh

ROGENTOS_MOLECULE_HOME="${ROGENTOS_MOLECULE_HOME:-/rogentos}"

exec "${ROGENTOS_MOLECULE_HOME}/scripts/iso_build_locked.sh" \
    "weekly_iso_build.sh"