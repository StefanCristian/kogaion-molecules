# Use abs path, otherwise daily builds automagic won't work
%env %import ${KOGAION_MOLECULE_HOME:-/kogaion}/molecules/kde.common
%env %import ${KOGAION_MOLECULE_HOME:-/kogaion}/molecule/x86.common

prechroot: linux32

# Release Version
release_version: 1.4

# Release Version string description
release_desc: x86 KDE

# Path to source ISO file (MANDATORY)
%env source_iso: ${KOGAION_MOLECULE_HOME:-/kogaion}/iso/Kogaion_Linux_SpinBase_2_x86.iso

# Destination ISO image name, call whatever you want.iso, not mandatory
destination_iso_image_name: /kogaion/iso/Kogaion_x86_1.4_KDE.iso
