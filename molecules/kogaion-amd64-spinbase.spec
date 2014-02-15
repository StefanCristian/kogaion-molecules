# Use abs path, otherwise daily builds automagic won't work
%env %import ${ROGENTOS_MOLECULE_HOME:-/sabayon}/molecules/spinbase.common

# Release Version
# Keep this here, otherwise daily builds automagic won't work
release_version: 1

# Release Version string description
release_desc: amd64 SpinBase

# Source chroot directory, where files are pulled from
%env source_chroot: ${ROGENTOS_MOLECULE_HOME:-/sabayon}/sources/amd64

# Destination ISO image name, call whatever you want.iso, not mandatory
# Keep this here and set, otherwise daily builds automagic won't work
destination_iso_image_name: Kogaion_Linux_SpinBase_2_amd64.iso
