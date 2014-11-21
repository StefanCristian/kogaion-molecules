# Use abs path, otherwise daily iso build won't work
%env %import ${ROGENTOS_MOLECULE_HOME:-/kogaion}/molecules/hardenedserver.common

%env release_version: ${ROGENTOS_RELEASE:-2}
release_desc: amd64 Hardened Server

# Path to source ISO file (MANDATORY)
%env source_iso: ${ROGENTOS_MOLECULE_HOME:-/kogaion}/iso/Sabayon_Linux_${ISO_TAG:-DAILY}_amd64_SpinBase.iso

# Destination ISO image name, call whatever you want.iso, not mandatory
%env destination_iso_image_name: Sabayon_Linux_${ROGENTOS_RELEASE:-2}_amd64_HardenedServer.iso
