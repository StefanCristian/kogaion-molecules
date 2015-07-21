#!/bin/bash

/usr/sbin/env-update
. /etc/profile

# Path to molecules.git dir
KOGAION_MOLECULE_HOME="${KOGAION_MOLECULE_HOME:-/kogaion}"
export KOGAION_MOLECULE_HOME

boot_dir="${CHROOT_DIR}/boot"
cdroot_boot_dir="${CDROOT_DIR}/boot"

kernels=( "${boot_dir}"/kernel-* )
# get the first one and see if it exists
kernel="${kernels[0]}"
#if [ ! -f "${kernel}" ]; then
#        echo "No kernels in ${boot_dir}" >&2
#        exit 1
#fi

initramfss=( "${boot_dir}"/initramfs-genkernel-* )
# get the first one and see if it exists
initramfs="${initramfss[0]}"
#if [ ! -f "${initramfs}" ]; then
#        echo "No initramfs in ${boot_dir}" >&2
#        exit 1
#fi

remaster_type="${1}"
isolinux_source="${KOGAION_MOLECULE_HOME}/remaster/minimal_isolinux.cfg"
grub_source="${KOGAION_MOLECULE_HOME}/remaster/minimal_grub.cfg"
isolinux_destination="${CDROOT_DIR}/isolinux/txt.cfg"
grub_destination="${CDROOT_DIR}/boot/grub/grub.cfg"

isolinux_img="${CHROOT_DIR}/usr/share/backgrounds/isolinux/back.jpg"
isolinux_dir="/kogaion/boot/core/isolinux/"
syslinux_img="${CHROOT_DIR}/usr/share/backgrounds/isolinux/back.jpg"
syslinux_dir="/kogaion/boot/core/syslinux/"
if [ -f "${isolinux_img}" ]; then
        mkdir -p "${CDROOT_DIR}/isolinux/"
        cp -R "${isolinux_dir}"/* "${CDROOT_DIR}/isolinux/" || exit 1
	cp "${isolinux_img}" "${CDROOT_DIR}/isolinux/" || exit 1
	mkdir -p "${CDROOT_DIR}/syslinux/"
	cp -R "${syslinux_dir}"/* "${CDROOT_DIR}"/syslinux || exit 1
	cp "${syslinux_img}" "${CDROOT_DIR}/syslinux/" || exit 1
fi

if [ -d "/home/kogaionuser/.gvfs" ]; then
        echo "All is doomed"
        umount /home/kogaionuser/.gvfs
        chown -R kogaionuser:kogaionuser /home/kogaionuser/.gvfs
fi

boot_kernel=$(find "${CHROOT_DIR}/boot" -name "kernel-*" | sort | head -n 1)
boot_ramfs=$(find "${CHROOT_DIR}/boot" -name "initramfs-genkernel-*" | sort | head -n 1)
if [ -n "${boot_kernel}" ] && [ -f "${boot_kernel}" ]; then
	#cp "${boot_kernel}" "${CDROOT_DIR}/boot/kogaion" || exit 1
	#cp "${boot_ramfs}" "${CDROOT_DIR}/boot/kogaion.igz" || exit 1
	cp "${KOGAION_MOLECULE_HOME}"/boot/kogaion_kernel/live-brrc "${cdroot_boot_dir}"/kogaion
	cp "${KOGAION_MOLECULE_HOME}"/boot/kogaion_kernel/live-brrc.igz "${cdroot_boot_dir}"/kogaion.igz || exit 1
fi

if [ "${remaster_type}" = "KDE" ] || [ "${remaster_type}" = "GNOME" ] || [ "${remaster_type}" = "MATE" ] || [ "${remaster_type}" = "XFCE" ] ; then
	isolinux_source="${KOGAION_MOLECULE_HOME}/remaster/standard_isolinux.cfg"
	grub_source="${KOGAION_MOLECULE_HOME}/remaster/standard_grub.cfg"
elif [ "${remaster_type}" = "ServerBase" ]; then
	echo "ServerBase trigger, copying server kernel over"
	boot_kernel=$(find "${CHROOT_DIR}/boot" -name "kernel-*" | sort | head -n 1)
	boot_ramfs=$(find "${CHROOT_DIR}/boot" -name "initramfs-*" | sort | head -n 1)
	cp "${boot_kernel}" "${CDROOT_DIR}/boot/kogaion" || exit 1
	cp "${boot_ramfs}" "${CDROOT_DIR}/boot/kogaion.igz" || exit 1
	isolinux_source="${KOGAION_MOLECULE_HOME}/remaster/serverbase_isolinux.cfg"
	grub_source="${KOGAION_MOLECULE_HOME}/remaster/serverbase_grub.cfg"
elif [ "${remaster_type}" = "HardenedServer" ]; then
	echo "HardenedServer trigger, copying server kernel over"
	boot_kernel=$(find "${CHROOT_DIR}/boot" -name "kernel-*" | sort | head -n 1)
	boot_ramfs=$(find "${CHROOT_DIR}/boot" -name "initramfs-*" | sort | head -n 1)
	cp "${boot_kernel}" "${CDROOT_DIR}/boot/kogaion" || exit 1
	cp "${boot_ramfs}" "${CDROOT_DIR}/boot/kogaion.igz" || exit 1
	isolinux_source="${KOGAION_MOLECULE_HOME}/remaster/hardenedserver_isolinux.cfg"
	grub_source="${KOGAION_MOLECULE_HOME}/remaster/hardenedserver_grub.cfg"
fi
cp "${isolinux_source}" "${isolinux_destination}" || exit 1
cp "${grub_source}" "${grub_destination}" || exit 1

# Generate Language and Keyboard menus for GRUB-2
"${KOGAION_MOLECULE_HOME}"/scripts/make_grub_langs.sh "${grub_destination}" \
	|| exit 1

# generate EFI GRUB
"${KOGAION_MOLECULE_HOME}"/scripts/make_grub_efi.sh || exit 1

ver="${RELEASE_VERSION}"
[[ -z "${ver}" ]] && ver="${CUR_DATE}"
[[ -z "${ver}" ]] && ver="1"

sed -i "s/__VERSION__/${ver}/g" "${isolinux_destination}" || exit 1
sed -i "s/__FLAVOUR__/${remaster_type}/g" "${isolinux_destination}" || exit 1
sed -i "s/__VERSION__/${ver}/g" "${grub_destination}" || exit 1
sed -i "s/__FLAVOUR__/${remaster_type}/g" "${grub_destination}" || exit 1

kms_string=""
# should KMS be enabled?
if [ -f "${CHROOT_DIR}/.enable_kms" ]; then
	rm "${CHROOT_DIR}/.enable_kms"
	kms_string="radeon.modeset=1"
else
	# enable vesafb-tng then
	kms_string="video=vesafb:ywrap,mtrr:3"
fi
sed -i "s/__KMS__/${kms_string}/g" "${isolinux_destination}" || exit 1
sed -i "s/__KMS__/${kms_string}/g" "${grub_destination}" || exit 1

kogaion_pkgs_file="${CHROOT_DIR}/etc/kogaion-pkglist"
if [ -f "${kogaion_pkgs_file}" ]; then
	cp "${kogaion_pkgs_file}" "${CDROOT_DIR}/pkglist"
	if [ -n "${ISO_PATH}" ]; then # molecule 0.9.6 required
		# copy pkglist over to ISO path + pkglist
		cp "${kogaion_pkgs_file}" "${ISO_PATH}".pkglist
	fi
fi

# copy back.jpg to proper location
#if [ -f "${isolinux_img}" ]; then
	#mkdir -p "${CDROOT_DIR}/isolinux/"
        #cp "${isolinux_img}" "${CDROOT_DIR}/isolinux/" || exit 1
	#mkdir -p "${CDROOT_DIR}/syslinux/"
	#cp -R "${syslinux_dir}"/* "${CDROOT_DIR}"/syslinux || exit
        #cp "${syslinux_img}" "${CDROOT_DIR}/syslinux/" || exit 1
#fi

# Generate livecd.squashfs.md5
"${KOGAION_MOLECULE_HOME}"/scripts/pre_iso_script_livecd_hash.sh
