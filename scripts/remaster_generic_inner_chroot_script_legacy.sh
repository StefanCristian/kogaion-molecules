#!/bin/sh

/usr/sbin/env-update
. /etc/profile


# make sure there is no stale pid file around that prevents entropy from running
rm -f /run/entropy/entropy.lock

LOC=$(pwd)
EREPO=/etc/entropy/repositories.conf.d
cd "$EREPO"
wget http://pkg.kogaion.ro/~kogaion/distro/entropy_kogaionlinux
wget http://pkg.kogaion.ro/~kogaion/distro/entropy_kogaion-legacy
equo repo mirrorsort kogaionlinux
equo repo mirrorsort kogaionlinux
if [ -f "/etc/entropy/repositories.conf.d/entropy_kogaionlinux.example" ]; then
	mv "${EREPO}/entropy_kogaionlinux.example" "${EREPO}/entropy_kogaionlinux"
fi
if [ -f "${EREPO}/entropy_kogaion-weekly" ]; then
	mv "${EREPO}/entropy_kogaion-weekly" "${EREPO}/entropy_kogaion-weekly.example"
fi
cd $LOC

export FORCE_EAPI=2

updated=0
for ((i=0; i < 6; i++)); do
		equo update && {
				updated=1;
				break;
		}
		sleep 1200 || exit 1
done

if [ "${updated}" = "0" ]; then
		exit 1
fi

# disable all mirrors but GARR
for repo_conf in /etc/entropy/repositories.conf /etc/entropy/repositories.conf.d/entropy_sab*; do
	# skip .example files
	if [[ "${repo_conf}" =~ .*\.example$ ]]; then
		echo "skipping ${repo_conf}"
		continue
	fi
	sed -n -e "/pkg.sabayon.org/p" -e "/garr.it/p" -e "/^branch/p" \
		-e "/^product/p" -e "/^official-repository-id/p" -e "/^differential-update/p" \
		-i "${repo_conf}"
done

equo mask sabayon-skel sabayon-version sabayon-artwork-grub
equo remove sabayon-artwork-grub sabayon-artwork-core sabayon-artwork-isolinux sabayon-version sabayon-skel kogaion-live grub --nodeps
emerge -C sabayon-version
equo mask sabayon-version openrc@sabayonlinux.ro openrc@sabayon-limbo openrc@kogaion-weekly
equo mask grub@kogaion-weekly grub@sabayonlinux.ro grub@sabayon-limbo

echo ">=sys-apps/openrc-0.9@sabayon-limbo
>=sys-apps/openrc-0.9@sabayonlinux.ro
>=sys-apps/openrc-0.9@kogaion-weekly

>=sys-boot/grub-2.00@sabayon-limbo
>=sys-boot/grub-2.00@sabayonlinux.rg
>=sys-boot/grub-2.00@kogaion-weekly

>=app-misc/kogaion-version-1@sabayonlinux.ro
>=app-misc/kogaion-version-1@kogaion-weekly
>=app-misc/kogaion-version-1@sabayon-limbo

>=app-misc/kogaion-skel-1@sabayonlinux.ro
>=app-misc/kogaion-skel-1@kogaion-weekly
>=app-misc/kogaion-skel-1@sabayon-limbo

>=app-misc/kogaion-live-1@sabayonlinux.ro
>=app-misc/kogaion-live-1@kogaion-weekly
>=app-misc/kogaion-live-1@sabayon-limbo

>=x11-themes/kogaion-artwork-core-1@sabayonlinux.ro
>=x11-themes/kogaion-artwork-core-1@kogaion-weekly
>=x11-themes/kogaion-artwork-core-1@sabayon-limbo

>=x11-themes/kogaion-artwork-lxde-1@sabayonlinux.ro
>=x11-themes/kogaion-artwork-lxde-1@kogaion-weekly
>=x11-themes/kogaion-artwork-lxde-1@sabayon-limbo

>=x11-themes/kogaion-artwork-kde-1@sabayonlinux.ro
>=x11-themes/kogaion-artwork-kde-1@kogaion-weekly
>=x11-themes/kogaion-artwork-kde-1@sabayon-limbo

>=x11-themes/kogaion-artwork-isolinux-1@sabayonlinux.ro
>=x11-themes/kogaion-artwork-isolinux-1@kogaion-weekly
>=x11-themes/kogaion-artwork-isolinux-1@sabayon-limbo

>=x11-themes/kogaion-artwork-grub-1@sabayonlinux.ro
>=x11-themes/kogaion-artwork-grub-1@kogaion-weekly
>=x11-themes/kogaion-artwork-grub-1@sabayon-limbo

>=x11-themes/kogaion-artwork-gnome-1@sabayonlinux.ro
>=x11-themes/kogaion-artwork-gnome-1@kogaion-weekly
>=x11-themes/kogaion-artwork-gnome-1@sabayon-limbo

>=x11-themes/kogaion-artwork-extra-1@sabayonlinux.ro
>=x11-themes/kogaion-artwork-extra-1@kogaion-weekly
>=x11-themes/kogaion-artwork-extra-1@sabayon-limbo

>=kde-base/oxygen-icons-4.9.0@kogaion-weekly
>=kde-base/oxygen-icons-4.9.1@sabayonlinux.ro
>=kde-base/oxygen-icons-4.9.2@sabayon-limbo

>=x11-themes/gnome-colors-common-5.5.1@kogaion-weekly
>=x11-themes/gnome-colors-common-5.5.1@sabayonlinux.ro
>=x11-themes/gnome-colors-common-5.5.1@sabayon-limbo

>=x11-themes/tango-icon-theme-0.8.90@kogaion-weekly
>=x11-themes/tango-icon-theme-0.8.90@sabayonlinux.ro
>=x11-themes/tango-icon-theme-0.8.90@sabayon-limbo

>=x11-themes/elementary-icon-theme-2.7.1@kogaion-weekly
>=x11-themes/elementary-icon-theme-2.7.1@sabayonlinux.ro
>=x11-themes/elementary-icon-theme-2.7.1@sabayon-limbo

>=sys-apps/gpu-detector-1@kogaion-weekly
>=sys-apps/gpu-detector-1@sabayonlinux.ro
>=sys-apps/gpu-detector-1@sabayon-limbo

>=lxde-base/lxdm-0.4.1-r5@kogaion-weekly
>=lxde-base/lxdm-0.4.1-r5@sabayonlinux.ro
>=lxde-base/lxdm-0.4.1-r5@sabayon-limbo

>=x11-base/xorg-server-1.11@kogaion-weekly
>=x11-base/xorg-server-1.11@sabayonlinux.ro
>=x11-base/xorg-server-1.11@sabayon-limbo

>=app-admin/anaconda-0.1@kogaion-weekly
>=app-admin/anaconda-0.1@sabayonlinux.ro
>=app-admin/anaconda-0.1@sabayon-limbo

>=app-misc/anaconda-runtime-1.1-r1@kogaion-weekly
>=app-misc/anaconda-runtime-1.1-r1@sabayonlinux.ro
>=app-misc/anaconda-runtime-1.1-r1@sabayon-limbo" >> /etc/entropy/packages/package.mask

