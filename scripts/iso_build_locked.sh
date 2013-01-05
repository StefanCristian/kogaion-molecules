#!/bin/sh

if [ -z "${1}" ]; then
    echo "${0} <build script name>" >&2
    exit 1
fi

BUILD_SCRIPT_NAME="${1}"
shift

ROGENTOS_MOLECULE_HOME="${ROGENTOS_MOLECULE_HOME:-/sabayon}"
. "${ROGENTOS_MOLECULE_HOME}/scripts/iso_build.include"

# Pull new data from Git
(
    flock --timeout ${LOCK_TIMEOUT} -x 9
    if [ "${?}" != "0" ]; then
        echo "[git pull] cannot acquire lock, stale process holding it?" >&2
        kill_stale_process || exit 1
    fi
    cd /sabayon && git pull --quiet
) 9> "${ISO_BUILD_LOCK}"

# Execute build
(
    flock --timeout ${LOCK_TIMEOUT} -x 9
    if [ "${?}" != "0" ]; then
        echo "[build] cannot acquire lock, stale process holding it?" >&2
        kill_stale_process || exit 1
    fi

    "${ROGENTOS_MOLECULE_HOME}/scripts/${BUILD_SCRIPT_NAME}" "${@}"

) 9> "${ISO_BUILD_LOCK}"

exit ${?}
