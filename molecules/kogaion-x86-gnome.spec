# Use abs path, otherwise daily builds automagic won't work
%env %import ${ROGENTOS_MOLECULE_HOME:-/sabayon}/molecules/rx86gnome.common
%env %import ${ROGENTOS_MOLECULE_HOME:-/sabayon}/molecules/x86.common

# Release Version
%env release_version: ${ROGENTOS_RELEASE:-1~9}

# Release Version string description
release_desc: x86 GNOME

# Path to source ISO file (MANDATORY)
%env source_iso: ${ROGENTOS_MOLECULE_HOME:-/sabayon}/Sabayon_Linux_${ISO_TAG:-DAILY}_x86_SpinBase.iso

# Destination ISO image name, call whatever you want.iso, not mandatory
%env destination_iso_image_name: Kogaion_x86_1~9_GNOME.iso
