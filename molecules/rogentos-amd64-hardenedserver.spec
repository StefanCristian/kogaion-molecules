# Use abs path, otherwise daily iso build won't work
%env %import ${ROGENTOS_MOLECULE_HOME:-/kogaion}/molecules/rhardenedserver.common

release_version: 1
release_desc: amd64 Hardened Server

# Path to source ISO file (MANDATORY)
%env source_iso: ${ROGENTOS_MOLECULE_HOME:-/kogaion}/Sabayon_Linux_SpinBase_DAILY_amd64.iso

# Destination ISO image name, call whatever you want.iso, not mandatory
destination_iso_image_name: /kogaion/iso/Rogentos_HardenedServer_1_amd64.iso
