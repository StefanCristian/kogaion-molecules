#!/bin/sh

KOGAION_MOLECULE_HOME="${KOGAION_MOLECULE_HOME:-/kogaion}"

exec "${KOGAION_MOLECULE_HOME}/scripts/iso_build_locked.sh" "daily_iso_build.sh" "${@}"
