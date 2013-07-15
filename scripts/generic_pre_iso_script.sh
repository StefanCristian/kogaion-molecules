#!/bin/bash

/usr/sbin/env-update
. /etc/profile

# Path to molecules.git dir
ROGENTOS_MOLECULE_HOME="${ROGENTOS_MOLECULE_HOME:-/sabayon}"
export ROGENTOS_MOLECULE_HOME

remaster_type="${1}"
isolinux_source="${ROGENTOS_MOLECULE_HOME}/remaster/minimal_isolinux.cfg"
grub_source="${ROGENTOS_MOLECULE_HOME}/remaster/minimal_grub.cfg"
isolinux_destination="${CDROOT_DIR}/isolinux/txt.cfg"
grub_destination="${CDROOT_DIR}/boot/grub/grub.cfg"

rm "${CDROOT_DIR}/autorun.inf"
rm "${CDROOT_DIR}/sabayon.ico"
rm "${CDROOT_DIR}/sabayon.bat"
echo "Moving the right files where they rightfully belong"
cp /sabayon/boot/core/autorun.inf "${CDROOT_DIR}/"
cp /sabayon/boot/core/rogentos.ico "${CDROOT_DIR}/"
cp /sabayon/boot/core/rogentos.bat "${CDROOT_DIR}/"
echo "Copying them into the ISO image"

if [ -d "/home/rogentosuser/.gvfs" ]; then
        echo "All is doomed"
        umount /home/rogentosuser/.gvfs
        chown -R rogentosuser:rogentosuser /home/rogentosuser/.gvfs
fi

#mv "${CDROOT_DIR}/boot/sabayon.igz" "${CDROOT_DIR}/boot/rogentos.igz"
#mv "${CDROOT_DIR}/boot/sabayon" "${CDROOT_DIR}/boot/rogentos"

boot_kernel=$(find "${CHROOT_DIR}/boot" -name "kernel-*" | sort | head -n 1)
boot_ramfs=$(find "${CHROOT_DIR}/boot" -name "initramfs-genkernel-*" | sort | head -n 1)
if [ -n "${boot_kernel}" ] && [ -f "${boot_kernel}" ]; then
	cp "${boot_kernel}" "${CDROOT_DIR}/boot/rogentos" || exit 1
	cp "${boot_ramfs}" "${CDROOT_DIR}/boot/rogentos.igz" || exit 1
fi

if [ "${remaster_type}" = "KDE" ] || [ "${remaster_type}" = "GNOME" ]; then
	isolinux_source="${ROGENTOS_MOLECULE_HOME}/remaster/standard_isolinux.cfg"
	grub_source="${ROGENTOS_MOLECULE_HOME}/remaster/standard_grub.cfg"
elif [ "${remaster_type}" = "ServerBase" ]; then
	echo "ServerBase trigger, copying server kernel over"
	boot_kernel=$(find "${CHROOT_DIR}/boot" -name "kernel-*" | sort | head -n 1)
	boot_ramfs=$(find "${CHROOT_DIR}/boot" -name "initramfs-*" | sort | head -n 1)
	cp "${boot_kernel}" "${CDROOT_DIR}/boot/rogentos" || exit 1
	cp "${boot_ramfs}" "${CDROOT_DIR}/boot/rogentos.igz" || exit 1
	isolinux_source="${ROGENTOS_MOLECULE_HOME}/remaster/serverbase_isolinux.cfg"
	grub_source="${ROGENTOS_MOLECULE_HOME}/remaster/serverbase_grub.cfg"
elif [ "${remaster_type}" = "HardenedServer" ]; then
	echo "HardenedServer trigger, copying server kernel over"
	boot_kernel=$(find "${CHROOT_DIR}/boot" -name "kernel-*" | sort | head -n 1)
	boot_ramfs=$(find "${CHROOT_DIR}/boot" -name "initramfs-*" | sort | head -n 1)
	cp "${boot_kernel}" "${CDROOT_DIR}/boot/rogentos" || exit 1
	cp "${boot_ramfs}" "${CDROOT_DIR}/boot/rogentos.igz" || exit 1
	isolinux_source="${ROGENTOS_MOLECULE_HOME}/remaster/hardenedserver_isolinux.cfg"
	grub_source="${ROGENTOS_MOLECULE_HOME}/remaster/hardenedserver_grub.cfg"
fi
cp "${isolinux_source}" "${isolinux_destination}" || exit 1
cp "${grub_source}" "${grub_destination}" || exit 1

# Generate Language and Keyboard menus for GRUB-2
"${ROGENTOS_MOLECULE_HOME}"/scripts/make_grub_langs.sh "${grub_destination}" \
	|| exit 1

# generate EFI GRUB
"${ROGENTOS_MOLECULE_HOME}"/scripts/make_grub_efi.sh || exit 1

ver=${RELEASE_VERSION}
[[ -z "${ver}" ]] && ver=${CUR_DATE}
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

rogentos_pkgs_file="${CHROOT_DIR}/etc/rogentos-pkglist"
if [ -f "${rogentos_pkgs_file}" ]; then
	cp "${rogentos_pkgs_file}" "${CDROOT_DIR}/pkglist"
	if [ -n "${ISO_PATH}" ]; then # molecule 0.9.6 required
		# copy pkglist over to ISO path + pkglist
		cp "${rogentos_pkgs_file}" "${ISO_PATH}".pkglist
	fi
fi

# copy back.jpg to proper location
isolinux_img="/sabayon/boot/core/isolinux/back.jpg"
syslinux_img="/sabayon/boot/core/syslinux/back.jpg"
if [ -f "${isolinux_img}" ]; then
	mkdir -p "${CDROOT_DIR}/isolinux/"
        cp "${isolinux_img}" "${CDROOT_DIR}/isolinux/" || exit 1
	mkdir -p "${CDROOT_DIR}/syslinux/"
        cp "${syslinux_img}" "${CDROOT_DIR}/syslinux/" || exit 1
fi

rm "${CDROOT_DIR}"/sabayon
rm "${CDROOT_DIR}"/sabayon.igz
rm "${CDROOT_DIR}"/boot/sabayon
rm "${CDROOT_DIR}"/boot/sabayon.igz


# Generate livecd.squashfs.md5
"${ROGENTOS_MOLECULE_HOME}"/scripts/pre_iso_script_livecd_hash.sh
