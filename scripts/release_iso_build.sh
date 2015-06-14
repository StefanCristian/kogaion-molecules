#!/bin/bash

# Path to molecules.git dir
KOGAION_MOLECULE_HOME="${KOGAION_MOLECULE_HOME:-/kogaion}"
export KOGAION_MOLECULE_HOME
export MAKE_TORRENTS="1"

KOGAION_RELEASE="${1}"
if [ -z "${KOGAION_RELEASE}" ]; then
	echo "${0} <release version>" >&2
	exit 1
fi
shift

export KOGAION_RELEASE
exec "${KOGAION_MOLECULE_HOME}"/scripts/iso_build.sh "release" "$@"
