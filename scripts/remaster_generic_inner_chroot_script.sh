#!/bin/sh

/usr/sbin/env-update
. /etc/profile


# make sure there is no stale pid file around that prevents entropy from running
rm -f /var/run/entropy/entropy.lock

LOC=$(pwd)
EREPO=/etc/entropy/repositories.conf.d
cd "$EREPO"
wget http://pkg.rogentos.ro/~rogentos/distro/entropy_rogentoslinux
equo repo mirrorsort rogentoslinux
equo repo mirrorsort sabayonlinux.org
if [ -f "/etc/entropy/repositories.conf.d/entropy_sabayonlinux.org.example" ]; then
	mv "${EREPO}/entropy_sabayonlinux.org.example" "${EREPO}/entropy_sabayonlinux.org"
fi
if [ -f "${EREPO}/entropy_sabayon-weekly" ]; then
	mv "${EREPO}/entropy_sabayon-weekly" "${EREPO}/entropy_sabayon-weekly.example"
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
equo remove sabayon-artwork-grub sabayon-artwork-core sabayon-artwork-isolinux sabayon-version sabayon-skel sabayonlive-tools grub --nodeps
emerge -C sabayon-version
equo mask sabayon-version 

for PKG in openrc grub gnome-colors-common lxdm anaconda anaconda-runtime; do
equo mask $PKG@sabayonlinux.org
equo mask $PKG@sabayon-limbo
equo mask $PKG@sabayon-weekly
done

echo ">=sys-apps/openrc-0.9@sabayon-limbo
>=sys-apps/openrc-0.9@sabayonlinux.org
>=sys-apps/openrc-0.9@sabayon-weekly

>=app-misc/sabayonlive-tools-2.3@sabayon-limbo
>=app-misc/sabayonlive-tools-2.3@sabayonlinux.org
>=app-misc/sabayonlive-tools-2.3@sabayon-weekly

>=app-misc/sabayon-skel-9@sabayon-limbo
>=app-misc/sabayon-skel-9@sabayonlinux.org
>=app-misc/sabayon-skel-9@sabayon-weekly

>=sys-boot/grub-2.00@sabayon-limbo
>=sys-boot/grub-2.00@sabayonlinux.rg
>=sys-boot/grub-2.00@sabayon-weekly

>=kde-base/oxygen-icons-4.9.2@sabayon-weekly
>=kde-base/oxygen-icons-4.9.2@sabayonlinux.org
>=kde-base/oxygen-icons-4.9.2@sabayon-limbo

>=x11-themes/gnome-colors-common-5.5.1@sabayon-weekly
>=x11-themes/gnome-colors-common-5.5.1@sabayonlinux.org
>=x11-themes/gnome-colors-common-5.5.1@sabayon-limbo

>=x11-themes/tango-icon-theme-0.8.90@sabayon-weekly
>=x11-themes/tango-icon-theme-0.8.90@sabayonlinux.org
>=x11-themes/tango-icon-theme-0.8.90@sabayon-limbo

>=x11-themes/elementary-icon-theme-2.7.1@sabayon-weekly
>=x11-themes/elementary-icon-theme-2.7.1@sabayonlinux.org
>=x11-themes/elementary-icon-theme-2.7.1@sabayon-limbo

>=lxde-base/lxdm-0.4.1-r5@sabayon-weekly
>=lxde-base/lxdm-0.4.1-r5@sabayonlinux.org
>=lxde-base/lxdm-0.4.1-r5@sabayon-limbo

>=sys-apps/gpu-detector-1@sabayon-weekly
>=sys-apps/gpu-detector-1@sabayonlinux.org
>=sys-apps/gpu-detector-1@sabayon-limbo

>=app-admin/anaconda-0.1@sabayon-weekly
>=app-admin/anaconda-0.1@sabayonlinux.org
>=app-admin/anaconda-0.1@sabayon-limbo

>=app-misc/anaconda-runtime-1.1-r1@sabayon-weekly
>=app-misc/anaconda-runtime-1.1-r1@sabayonlinux.org
>=app-misc/anaconda-runtime-1.1-r1@sabayon-limbo" >> /etc/entropy/packages/package.mask
