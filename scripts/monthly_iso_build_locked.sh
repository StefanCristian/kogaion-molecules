#!/bin/sh

KOGAION_MOLECULE_HOME="${KOGAION_MOLECULE_HOME:-/sabayon}"

exec "${KOGAION_MOLECULE_HOME}/scripts/iso_build_locked.sh" \
    "monthly_iso_build.sh" "${@}"
