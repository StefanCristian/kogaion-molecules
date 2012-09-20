# use abs path, otherwise daily iso build automagic won't work
%env %import ${ROGENTOS_MOLECULE_HOME:-/sabayon}/molecules/rhardenedserver.common

release_version: 1
release_desc: x86 Hardened Server

# pre chroot command, example, for 32bit chroots on 64bit system, you always
# have to append "linux32" this is useful for inner_chroot_script
prechroot: linux32

# Path to source ISO file (MANDATORY)
%env source_iso: ${ROGENTOS_MOLECULE_HOME:-/sabayon}/Sabayon_Linux_SpinBase_DAILY_x86.iso

# Destination ISO image name, call whatever you want.iso, not mandatory
destination_iso_image_name: /sabayon/iso/Rogentos_HardenedServer_1_x86.iso
