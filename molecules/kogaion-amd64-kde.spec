# Use abs path, otherwise daily builds automagic won't work
%env %import ${ROGENTOS_MOLECULE_HOME:-/kogaion}/molecules/rkde.common

# Release Version
release_version: 2

# Release Version string description
release_desc: amd64 KDE

# Path to source ISO file (MANDATORY)
%env source_iso: ${ROGENTOS_MOLECULE_HOME:-/kogaion}/Kogaion_Linux_DAILY_amd64_SpinBase.iso

# Destination ISO image name, call whatever you want.iso, not mandatory
destination_iso_image_name: Kogaion_amd64_2.0_KDE.iso
