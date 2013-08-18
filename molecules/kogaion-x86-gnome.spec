# Use abs path, otherwise daily builds automagic won't work
%env %import ${ROGENTOS_MOLECULE_HOME:-/sabayon}/molecules/gnome.common

prechroot: linux32

# Release Version
%env release_version: ${ROGENTOS_RELEASE:-2}

# Release Version string description
release_desc: x86 GNOME

# Path to source ISO file (MANDATORY)
%env source_iso: ${ROGENTOS_MOLECULE_HOME:-/sabayon}/iso/Sabayon_Linux_${ISO_TAG:-DAILY}_x86_SpinBase.iso

# Destination ISO image name, call whatever you want.iso, not mandatory
%env destination_iso_image_name: Kogaion_Linux_${ROGENTOS_RELEASE:-2}_x86_GNOME.iso
