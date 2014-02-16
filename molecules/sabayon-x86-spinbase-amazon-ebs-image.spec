# Use abs path, otherwise daily builds automagic won't work
%env %import ${ROGENTOS_MOLECULE_HOME:-/sabayon}/molecules/spinbase-amazon-ami-ebs-image.common

# pre chroot command, example, for 32bit chroots on 64bit system, you always
# have to append "linux32" this is useful for inner_chroot_script
prechroot: linux32

# Path to source ISO file (MANDATORY)
%env source_iso: ${ROGENTOS_MOLECULE_HOME:-/sabayon}/iso/Sabayon_Linux_${ISO_TAG:-DAILY}_x86_SpinBase.iso

%env release_version: ${ROGENTOS_RELEASE:-2}
%env tar_name: Sabayon_Linux_SpinBase_${ROGENTOS_RELEASE:-2}_x86_Amazon_EBS_ext4_filesystem_image.tar.gz
