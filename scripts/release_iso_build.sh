#!/bin/bash

# Path to molecules.git dir
ROGENTOS_MOLECULE_HOME="${ROGENTOS_MOLECULE_HOME:-/sabayon}"
export ROGENTOS_MOLECULE_HOME
export MAKE_TORRENTS="1"

ROGENTOS_RELEASE="${1}"
if [ -z "${ROGENTOS_RELEASE}" ]; then
	echo "${0} <release version>" >&2
	exit 1
fi
shift

export ROGENTOS_RELEASE
exec "${ROGENTOS_MOLECULE_HOME}"/scripts/iso_build.sh "release" "$@"
