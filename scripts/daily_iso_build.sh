#!/bin/bash

# Path to molecules.git dir
KOGAION_MOLECULE_HOME="${KOGAION_MOLECULE_HOME:-/sabayon}"
export KOGAION_MOLECULE_HOME

exec "${KOGAION_MOLECULE_HOME}"/scripts/iso_build.sh "daily" "$@"
