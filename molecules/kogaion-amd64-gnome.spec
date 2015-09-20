# Use abs path, otherwise daily builds automagic won't work
%env %import ${KOGAION_MOLECULE_HOME:-/kogaion}/molecules/gnome.common
%env %import ${KOGAION_MOLECULE_HOME:-/kogaion}/molecules/amd64.common

# Release Version
%env release_version: ${KOGAION_RELEASE:-2.0}

# Release Version string description
release_desc: amd64 GNOME

# Path to source ISO file (MANDATORY)
%env source_iso: ${KOGAION_MOLECULE_HOME:-/kogaion}/iso/Kogaion_Linux_SpinBase_2_amd64.iso

# Destination ISO image name, call whatever you want.iso, not mandatory
%env destination_iso_image_name: Kogaion_amd64_2.0_GNOME.iso
