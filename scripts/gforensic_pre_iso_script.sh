#!/bin/bash

# Path to molecules.git dir
ROGENTOS_MOLECULE_HOME="${ROGENTOS_MOLECULE_HOME:-/sabayon}"
export ROGENTOS_MOLECULE_HOME

# Call parent script, generates ISOLINUX and other stuff
"${ROGENTOS_MOLECULE_HOME}"/scripts/generic_pre_iso_script.sh "Forensic"

GFORENSIC_DIR="${ROGENTOS_MOLECULE_HOME}/remaster/gforensic"
cp "${GFORENSIC_DIR}"/isolinux/back.jpg "${CDROOT_DIR}/isolinux/back.jpg"
