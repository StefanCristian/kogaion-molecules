# Use abs path, otherwise daily builds automagic won't work
# For further documentation, see the file above:
%env %import ${ROGENTOS_MOLECULE_HOME:-/sabayon}/molecules/spinbase-amazon-ami-image-template.common

# pre chroot command, example, for 32bit chroots on 64bit system, you always
# have to append "linux32" this is useful for inner_chroot_script
# prechroot:

# Path to source ISO file (MANDATORY)
%env source_iso: ${ROGENTOS_MOLECULE_HOME:-/sabayon}/iso/Sabayon_Linux_${ISO_TAG:-DAILY}_amd64_SpinBase.iso

%env release_version: ${ROGENTOS_RELEASE:-2}
%env image_name: Sabayon_Linux_SpinBase_${ROGENTOS_RELEASE:-2}_amd64_ami.img
