# Use abs path, otherwise daily builds automagic won't work
%env %import ${KOGAION_MOLECULE_HOME:-/kogaion}/molecules/spinbase.common
%env %import ${KOGAION_MOLECULE_HOME:-/kogaion}/molecules/amd64.common

# Release Version
# Keep this here, otherwise daily builds automagic won't work
release_version: 1

# Release Version string description
release_desc: amd64 SpinBase

# Source chroot directory, where files are pulled from
%env source_chroot: ${KOGAION_MOLECULE_HOME:-/kogaion}/sources/amd64_core-2010

%env destination_chroot: ${KOGAION_MOLECULE_HOME:-/kogaion}/chroots/default
%env inner_chroot_script: ${KOGAION_MOLECULE_HOME:-/kogaion}/scripts/inner_chroot_script.sh
%env destination_livecd_root: ${KOGAION_MOLECULE_HOME:-/kogaion}/chroots/default

# Destination ISO image name, call whatever you want.iso, not mandatory
# Keep this here and set, otherwise daily builds automagic won't work
destination_iso_image_name: Kogaion_Linux_SpinBase_2_amd64.iso
