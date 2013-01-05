#!/bin/bash

# Path to molecules.git dir
ROGENTOS_MOLECULE_HOME="${ROGENTOS_MOLECULE_HOME:-/sabayon}"
export ROGENTOS_MOLECULE_HOME

exec "${ROGENTOS_MOLECULE_HOME}"/scripts/iso_build.sh "daily" "$@"
