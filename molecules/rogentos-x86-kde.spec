# Use abs path, otherwise daily builds automagic won't work
%env %import ${ROGENTOS_MOLECULE_HOME:-/sabayon}/molecules/rkde.common

prechroot: linux32

# Release Version
release_version: 1~3

# Release Version string description
release_desc: x86 KDE

# Path to source ISO file (MANDATORY)
%env source_iso: ${ROGENTOS_MOLECULE_HOME:-/sabayon}/Sabayon_Linux_SpinBase_DAILY_x86.iso

# Destination ISO image name, call whatever you want.iso, not mandatory
destination_iso_image_name: Rogentos_x86_K.iso
