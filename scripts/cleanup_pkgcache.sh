#!/bin/sh
# Remove tarballs not accessed in the last 30 days
# concurrency wrt scripts is handled in crontab

# Path to molecules.git dir
KOGAION_MOLECULE_HOME="${KOGAION_MOLECULE_HOME:-/sabayon}"

DIR="${KOGAION_MOLECULE_HOME}/pkgcache"
find "${DIR}" -atime +30 -type f -delete
