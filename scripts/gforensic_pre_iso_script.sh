#!/bin/bash

# Path to molecules.git dir
KOGAION_MOLECULE_HOME="${KOGAION_MOLECULE_HOME:-/sabayon}"
export KOGAION_MOLECULE_HOME

# Call parent script, generates ISOLINUX and other stuff
"${KOGAION_MOLECULE_HOME}"/scripts/generic_pre_iso_script.sh "Forensic"

GFORENSIC_DIR="${KOGAION_MOLECULE_HOME}/remaster/gforensic"
cp "${GFORENSIC_DIR}"/isolinux/back.jpg "${CDROOT_DIR}/isolinux/back.jpg"
