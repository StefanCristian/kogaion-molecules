#!/bin/bash

# Path to molecules.git dir
KOGAION_MOLECULE_HOME="${KOGAION_MOLECULE_HOME:-/kogaion}"
export KOGAION_MOLECULE_HOME

exec "${KOGAION_MOLECULE_HOME}"/scripts/iso_build.sh "dailybase" "$@"
