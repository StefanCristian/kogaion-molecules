# Use abs path, otherwise daily builds automagic won't work
%env %import ${KOGAION_MOLECULE_HOME:-/kogaion}/molecules/legacy-xfce.common

# Release Version
release_version: 1

# Release Version string description
release_desc: amd64 Xfce

# Path to source ISO file (MANDATORY)
%env source_iso: ${KOGAION_MOLECULE_HOME:-/kogaion}/Kogaion_Linux_SpinBase_DAILY_amd64.iso

# Destination ISO image name, call whatever you want.iso, not mandatory
destination_iso_image_name: /kogaion/iso/Kogaion_amd64_Legacy_xfce.iso
