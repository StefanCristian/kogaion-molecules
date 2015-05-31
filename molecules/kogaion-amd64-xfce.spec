# Use abs path, otherwise daily builds automagic won't work
%env %import ${ROGENTOS_MOLECULE_HOME:-/kogaion}/molecules/rxfce.common
%env %import ${ROGENTOS_MOLECULE_HOME:-/kogaion}/molecules/amd64.common

# Release Version
release_version: 2

# Release Version string description
release_desc: amd64 Xfce

# Path to source ISO file (MANDATORY)
%env source_iso: ${ROGENTOS_MOLECULE_HOME:-/kogaion}/iso/Kogaion_Linux_SpinBase_2_amd64.iso

# Destination ISO image name, call whatever you want.iso, not mandatory
destination_iso_image_name: /kogaion/iso/Kogaion_amd64_2.0_XFCE.iso
