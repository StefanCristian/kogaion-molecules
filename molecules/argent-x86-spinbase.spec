# Use abs path, otherwise daily builds automagic won't work
%env %import ${ROGENTOS_MOLECULE_HOME:-/argent}/molecules/spinbase.common

# 32bit build
prechroot: linux32

# Release Version
# Keep this here, otherwise daily builds automagic won't work
release_version: 10

# Release Version string description
release_desc: x86 SpinBase

# Source chroot directory, where files are pulled from
%env source_chroot: ${ROGENTOS_MOLECULE_HOME:-/argent}/sources/x86

# Destination ISO image name, call whatever you want.iso, not mandatory
# Keep this here and set, otherwise daily builds automagic won't work
destination_iso_image_name: Argent_Linux_SpinBase_2_x86.iso
