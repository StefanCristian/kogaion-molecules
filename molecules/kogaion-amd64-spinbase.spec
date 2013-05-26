# Use abs path, otherwise daily builds automagic won't work
%env %import ${ROGENTOS_MOLECULE_HOME:-/sabayon}/molecules/rspinbase.common

# Release Version
# Keep this here, otherwise daily builds automagic won't work
%env release_version: ${ROGENTOS_RELEASE:-2}

# Release Version string description
release_desc: amd64 SpinBase

# Source chroot directory, where files are pulled from
%env source_chroot: ${ROGENTOS_MOLECULE_HOME:-/sabayon}/sources/amd64_core-2010

# Destination ISO image name, call whatever you want.iso, not mandatory
# Keep this here and set, otherwise daily builds automagic won't work
%env destination_iso_image_name: Rogentos_Linux_${ROGENTOS_RELEASE:-2}_amd64_SpinBase.iso
