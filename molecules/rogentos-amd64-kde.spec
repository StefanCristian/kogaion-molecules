# Use abs path, otherwise daily builds automagic won't work
%env %import ${ROGENTOS_MOLECULE_HOME:-/sabayon}/molecules/kde.common

# Release Version
release_version: 1.4

# Release Version string description
release_desc: amd64 KDE

# Path to source ISO file (MANDATORY)
%env source_iso: ${ROGENTOS_MOLECULE_HOME:-/sabayon}/Sabayon_Linux_SpinBase_DAILY_amd64.iso

# Destination ISO image name, call whatever you want.iso, not mandatory
destination_iso_image_name: Rogentos_amd64_1.4_KDE.iso
