# Path to molecules.git dir
KOGAION_MOLECULE_HOME="${KOGAION_MOLECULE_HOME:-/sabayon}"
. "${KOGAION_MOLECULE_HOME}/scripts/iso_build.include"

(
    flock --timeout ${LOCK_TIMEOUT} -x 9
    if [ "${?}" != "0" ]; then
        echo "[cleanup] cannot acquire lock, stale process holding it?" >&2
        kill_stale_process || exit 1
    fi
    "${KOGAION_MOLECULE_HOME}/scripts/cleanup_pkgcache.sh"
) 9> "${ISO_BUILD_LOCK}"

exit ${?}