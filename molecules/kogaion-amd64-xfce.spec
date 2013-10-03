# Use abs path, otherwise daily builds automagic won't work
%env %import ${ROGENTOS_MOLECULE_HOME:-/sabayon}/molecules/rxfce.common
%env %import ${ROGENTOS_MOLECULE_HOME:-/sabayon}/molecules/amd64.common

# Release Version
release_version: 2

# Release Version string description
release_desc: amd64 Xfce

# Path to source ISO file (MANDATORY)
%env source_iso: ${ROGENTOS_MOLECULE_HOME:-/sabayon}/Sabayon_Linux_DAILY_amd64_SpinBase.iso

# Destination ISO image name, call whatever you want.iso, not mandatory
destination_iso_image_name: /sabayon/iso/Kogaion_amd64_1~9_xfce.iso
