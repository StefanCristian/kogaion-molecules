# Use abs path, otherwise daily builds automagic won't work
%env %import ${ROGENTOS_MOLECULE_HOME:-/kogaion}/molecules/rx86xfce.common
%env %import ${ROGENTOS_MOLECULE_HOME:-/kogaion}/molecules/x86.common

# Release Version
release_version: 2

# Release Version string description
release_desc: x86 Xfce

# 32bit chroot
prechroot: linux32

# Path to source ISO file (MANDATORY)
%env source_iso: ${ROGENTOS_MOLECULE_HOME:-/kogaion}/Kogaion_Linux_DAILY_x86_SpinBase.iso

# Destination ISO image name, call whatever you want.iso, not mandatory
destination_iso_image_name: /kogaion/iso/Kogaion_x86_2.0_XFCE.iso
