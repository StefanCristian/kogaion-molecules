# Use abs path, otherwise daily builds automagic won't work
%import iso_to_tar.common

# pre chroot command, example, for 32bit chroots on 64bit system, you always
# have to append "linux32" this is useful for inner_chroot_script
prechroot: linux32

# Path to source ISO file (MANDATORY)
source_iso: specs/data/Kogaion_Linux_SpinBase_DAILY_x86.iso

release_version: 5.3
tar_name: Kogaion_Linux_SpinBase_5.3_x86_openvz.tar.bz2
