#!/bin/bash

/usr/sbin/env-update && source /etc/profile

ROGENTOS_MOLECULE_HOME="${ROGENTOS_MOLECULE_HOME:-/sabayon}"
export ROGENTOS_MOLECULE_HOME

remaster_type="${1}"
isolinux_source="/sabayon/remaster/minimal_isolinux.cfg"
isolinux_destination="${CDROOT_DIR}/isolinux/txt.cfg"
syslinux_source="/sabayon/remaster/minimal_isolinux.cfg"
syslinux_destination="${CDROOT_DIR}/syslinux/txt.cfg"

cp -R /sabayon/boot/core/syslinux/ "${CDROOT_DIR}/"

rm "${CDROOT_DIR}/autorun.inf"
rm "${CDROOT_DIR}/sabayon.ico"
rm "${CDROOT_DIR}/sabayon.bat"
echo "Moving the right files where they rightfully belong"
cp /sabayon/boot/core/autorun.inf "${CDROOT_DIR}/"
cp /sabayon/boot/core/rogentos.ico "${CDROOT_DIR}/"
cp /sabayon/boot/core/rogentos.bat "${CDROOT_DIR}/"
echo "Copying them into the ISO image"

if [ -d "/home/rogentosuser/.gvfs" ]; then
	echo "...all is doomed"
	umount /home/rogentosuser/.gvfs
	rm -r /home/rogentosuser/.gvfs
fi

echo "If we copied correctly, then do what we must"
boot_kernel=$(find "${CHROOT_DIR}/boot" -name "kernel-*" | sort | head -n 1)
boot_ramfs=$(find "${CHROOT_DIR}/boot" -name "initramfs-*" | sort | head -n 1)
cp "${boot_kernel}" "${CDROOT_DIR}/boot/rogentos" || exit 1
cp "${boot_ramfs}" "${CDROOT_DIR}/boot/rogentos.igz" || exit 1

mv "${CHROOT_DIR}/boot/sabayon.igz" "${CHROOT_DIR}/boot/rogentos.igz"
mv "${CHROOT_DIR}/boot/sabayon" "${CHROOT_DIR}/boot/rogentos"

if [ "${remaster_type}" = "KDE" ] || [ "${remaster_type}" = "GNOME" ]; then
	isolinux_source="/sabayon/remaster/standard_isolinux.cfg"
elif [ "${remaster_type}" = "HardenedServer" ]; then
        echo "HardenedServer trigger, copying server kernel over"
        boot_kernel=$(find "${CHROOT_DIR}/boot" -name "kernel-*" | sort | head -n 1)
        boot_ramfs=$(find "${CHROOT_DIR}/boot" -name "initramfs-*" | sort | head -n 1)
        cp "${boot_kernel}" "${CDROOT_DIR}/boot/sabayon" || exit 1
        cp "${boot_ramfs}" "${CDROOT_DIR}/boot/sabayon.igz" || exit 1
        isolinux_source="${ROGENTOS_MOLECULE_HOME}/remaster/hardenedserver_isolinux.cfg"
elif [ "${remaster_type}" = "Legacy" ]; then
	echo "Legacy, trigger, copying server kernel over"
        boot_kernel=$(find "${CHROOT_DIR}/boot" -name "kernel-*" | sort | head -n 1)
        boot_ramfs=$(find "${CHROOT_DIR}/boot" -name "initramfs-*" | sort | head -n 1)
        cp "${boot_kernel}" "${CDROOT_DIR}/boot/rogentos" || exit 1
        cp "${boot_ramfs}" "${CDROOT_DIR}/boot/rogentos.igz" || exit 1
        isolinux_source="${ROGENTOS_MOLECULE_HOME}/remaster/legacy_standard_isolinux.cfg"
fi

cp "${isolinux_source}" "${isolinux_destination}" || exit 1

ver=${RELEASE_VERSION}
[[ -z "${ver}" ]] && ver=${CUR_DATE}
[[ -z "${ver}" ]] && ver="6"

sed -i "s/__VERSION__/${ver}/g" "${isolinux_destination}"
sed -i "s/__FLAVOUR__/${remaster_type}/g" "${isolinux_destination}"
sed -i "s/__VERSION__/${ver}/g" "${syslinux_destination}"
sed -i "s/__FLAVOUR__/${remaster_type}/g" "${syslinux_destination}"


kms_string=""
# should KMS be enabled?
if [ -f "${CHROOT_DIR}/.enable_kms" ]; then
	rm "${CHROOT_DIR}/.enable_kms"
	kms_string="radeon.modeset=1"
else
	# enable vesafb-tng then
	kms_string="video=vesafb:ywrap,mtrr:3"
fi
sed -i "s/__KMS__/${kms_string}/g" "${isolinux_destination}"
sed -i "s/__KMS__/${kms_string}/g" "${syslinux_destination}"

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
	cp "${isolinux_img}" "${CDROOT_DIR}/isolinux/" || exit 1
	cp "${syslinux_img}" "${CDROOT_DIR}/syslinux/" || exit 1
fi

rm "${CDROOT_DIR}"/sabayon
rm "${CDROOT_DIR}"/sabayon.igz
rm "${CDROOT_DIR}"/boot/sabayon 
rm "${CDROOT_DIR}"/boot/sabayon.igz

# Generate livecd.squashfs.md5
"${ROGENTOS_MOLECULE_HOME}"/scripts/pre_iso_script_livecd_hash.sh
