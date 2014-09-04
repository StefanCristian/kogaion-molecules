# use abs path, otherwise daily iso build automagic won't work
%env %import ${ROGENTOS_MOLECULE_HOME:-/sabayon}/molecules/aminimal.common

%env release_version: ${ROGENTOS_RELEASE:-2}
release_desc: x86 CoreCDX

# pre chroot command, example, for 32bit chroots on 64bit system, you always
# have to append "linux32" this is useful for inner_chroot_script
prechroot: linux32

# Path to source ISO file (MANDATORY)
%env source_iso: ${ROGENTOS_MOLECULE_HOME:-/sabayon}/Sabayon_Linux_${ISO_TAG:-DAILY}_x86_SpinBase.iso

# Destination ISO image name, call whatever you want.iso, not mandatory
%env destination_iso_image_name: Argent_Linux_${ROGENTOS_RELEASE:-2}_x86_Minimal.iso
