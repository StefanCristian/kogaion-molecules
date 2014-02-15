# Use abs path, otherwise daily builds automagic won't work
%env %import ${ROGENTOS_MOLECULE_HOME:-/sabayon}/molecules/spinbase.common
%env %import ${ROGENTOS_MOLECULE_HOME:-/sabayon}/molecules/x86.common

# 32bit build
prechroot: linux32

# Release Version
# Keep this here, otherwise daily builds automagic won't work
release_version: 2

# Release Version string description
release_desc: x86 SpinBase

# Source chroot directory, where files are pulled from
%env source_chroot: ${ROGENTOS_MOLECULE_HOME:-/sabayon}/sources/x86

# Destination ISO image name, call whatever you want.iso, not mandatory
# Keep this here and set, otherwise daily builds automagic won't work
%env destination_iso_image_name: Kogaion_Linux_2_x86_SpinBase.iso
