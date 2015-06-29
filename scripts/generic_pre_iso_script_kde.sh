#!/bin/bash

/usr/sbin/env-update && source /etc/profile

KOGAION_MOLECULE_HOME="${KOGAION_MOLECULE_HOME:-/kogaion}"
export KOGAION_MOLECULE_HOME

remaster_type="${1}"
isolinux_source="/kogaion/remaster/minimal_isolinux.cfg"
isolinux_destination="${CDROOT_DIR}/isolinux/txt.cfg"

rm "${CDROOT_DIR}/autorun.inf"
rm "${CDROOT_DIR}/kogaion.ico"
rm "${CDROOT_DIR}/kogaion.bat"
echo "Moving the right files where they rightfully belong"
cp /kogaion/boot/core/autorun.inf "${CDROOT_DIR}/" 
cp /kogaion/boot/core/kogaion.ico "${CDROOT_DIR}/"               
cp /kogaion/boot/core/kogaion.bat "${CDROOT_DIR}/"

echo "Creating folder syslinux and copying everything that's in isolinux to it"
if [ -f "${CDROOT_DIR}/syslinux/isolinux.cfg" ]; then
        mv "${CDROOT_DIR}/syslinux/isolinux.cfg" "${CDROOT_DIR}/syslinux/syslinux.cfg"
        sed -i 's/cdroot cdroot_type=udf/cdroot/g' "${CDROOT_DIR}/syslinux/txt.cfg"
fi
echo "If we copied correctly, then do what we must"

if [ "${remaster_type}" = "KDE" ] || [ "${remaster_type}" = "GNOME" ]; then
	isolinux_source="/kogaion/remaster/standard_isolinux.cfg"
elif [ "${remaster_type}" = "ServerBase" ]; then
	echo "ServerBase trigger, copying server kernel over"
	boot_kernel=$(find "${CHROOT_DIR}/boot" -name "kernel-*" | sort | head -n 1)
	boot_ramfs=$(find "${CHROOT_DIR}/boot" -name "initramfs-*" | sort | head -n 1)
	cp "${boot_kernel}" "${CDROOT_DIR}/boot/kogaion" || exit 1
	cp "${boot_ramfs}" "${CDROOT_DIR}/boot/kogaion.igz" || exit 1
	isolinux_source="/kogaion/remaster/serverbase_isolinux.cfg"
fi
cp "${isolinux_source}" "${isolinux_destination}" || exit 1

ver=${RELEASE_VERSION}
[[ -z "${ver}" ]] && ver=${CUR_DATE}
[[ -z "${ver}" ]] && ver="6"

sed -i "s/__VERSION__/${ver}/g" "${isolinux_destination}"
sed -i "s/__FLAVOUR__/${remaster_type}/g" "${isolinux_destination}"

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

kogaion_pkgs_file="${CHROOT_DIR}/etc/kogaion-pkglist"
if [ -f "${kogaion_pkgs_file}" ]; then
	cp "${kogaion_pkgs_file}" "${CDROOT_DIR}/pkglist"
        if [ -n "${ISO_PATH}" ]; then # molecule 0.9.6 required
                # copy pkglist over to ISO path + pkglist
                cp "${kogaion_pkgs_file}" "${ISO_PATH}".pkglist
        fi
fi

# copy back.jpg to proper location
isolinux_img="/kogaion/boot/core/isolinux/back.jpg"
if [ -f "${isolinux_img}" ]; then
	cp "${isolinux_img}" "${CDROOT_DIR}/isolinux/" || exit 1
fi

# Generate livecd.squashfs.md5
"${KOGAION_MOLECULE_HOME}"/scripts/pre_iso_script_livecd_hash.sh
