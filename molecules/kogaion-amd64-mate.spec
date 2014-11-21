# Use abs path, otherwise daily builds automagic won't work
%env %import ${ROGENTOS_MOLECULE_HOME:-/kogaion}/molecules/rmate.common
%env %import ${ROGENTOS_MOLECULE_HOME:-/kogaion}/molecules/amd64.common

# Release Version
release_version: 2

# Release Version string description
release_desc: amd64 MATE

# Path to source ISO file (MANDATORY)
%env source_iso: ${ROGENTOS_MOLECULE_HOME:-/kogaion}/Sabayon_Linux_DAILY_amd64_SpinBase.iso

# Destination ISO image name, call whatever you want.iso, not mandatory
destination_iso_image_name: /kogaion/iso/Kogaion_amd64_2.0_MATE.iso
