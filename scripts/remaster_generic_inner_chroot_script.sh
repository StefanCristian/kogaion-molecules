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
equo mask sabayon-version openrc@sabayonlinux.org openrc@sabayon-limbo openrc@sabayon-weekly
equo mask grub@sabayonlinux.org grub@sabayon-weekly grub@sabayon-limbo
equo mask oxygen-icons@sabayon-weekly oxygen-icons@sabayonlinux.org oxygen-icons@sabayon-limbo
equo mask gnome-colors-common@sabayon-weekly gnome-colors-common@sabayonlinux.org gnome-colors-common@sabayon-limbo
equo mask tango-icon-theme@sabayon-weekly tango-icon-theme@sabayonlinux.org tango-icon-theme@sabayon-limbo
equo mask elementary-icon-theme@sabayon-weekly elementary-icon-theme@sabayonlinux.org elementary-icon-theme@sabayon-limbo
equo mask lxdm@sabayon-weekly lxdm@sabayonlinux.org lxdm@sabayon-limbo
equo mask anaconda@sabayon-weekly anaconda@sabayonlinux.org anaconda@sabayon-limbo
equo mask anaconda-runtime@sabayon-weekly anaconda-runtime@sabayonlinux.org anaconda-runtime@sabayon-limbo

echo ">=sys-apps/openrc-0.10.5@sabayon-limbo" >> /etc/entropy/packages/package.mask
echo ">=sys-apps/openrc-0.10.5@sabayonlinux.org" >> /etc/entropy/packages/package.mask
echo ">=sys-apps/openrc-0.10.5@sabayon-weekly" >> /etc/entropy/packages/package.mask

echo ">=sys-boot/grub-2.00@sabayon-limbo" >> /etc/entropy/packages/package.mask
echo ">=sys-boot/grub-2.00@sabayonlinux.rg" >> /etc/entropy/packages/package.mask
echo ">=sys-boot/grub-2.00@sabayon-weekly" >> /etc/entropy/packages/package.mask

echo ">=kde-base/oxygen-icons-4.9.2@sabayon-weekly" >> /etc/entropy/packages/package.mask
echo ">=kde-base/oxygen-icons-4.9.2@sabayonlinux.org" >> /etc/entropy/packages/package.mask
echo ">=kde-base/oxygen-icons-4.9.2@sabayon-limbo" >> /etc/entropy/packages/package.mask

echo ">=x11-themes/gnome-colors-common-5.5.1-r12@sabayon-weekly" >> /etc/entropy/packages/package.mask
echo ">=x11-themes/gnome-colors-common-5.5.1-r12@sabayonlinux.org" >> /etc/entropy/packages/package.mask
echo ">=x11-themes/gnome-colors-common-5.5.1-r12@sabayon-limbo" >> /etc/entropy/packages/package.mask

echo ">=x11-themes/tango-icon-theme-0.8.90@sabayon-weekly" >> /etc/entropy/packages/package.mask
echo ">=x11-themes/tango-icon-theme-0.8.90@sabayonlinux.org" >> /etc/entropy/packages/package.mask
echo ">=x11-themes/tango-icon-theme-0.8.90@sabayon-limbo" >> /etc/entropy/packages/package.mask

echo ">=x11-themes/elementary-icon-theme-2.7.1-r1@sabayon-weekly" >> /etc/entropy/packages/package.mask
echo ">=x11-themes/elementary-icon-theme-2.7.1-r1@sabayonlinux.org" >> /etc/entropy/packages/package.mask
echo ">=x11-themes/elementary-icon-theme-2.7.1-r1@sabayon-limbo" >> /etc/entropy/packages/package.mask

echo ">=lxde-base/lxdm-0.4.1-r5@sabayon-weekly" >> /etc/entropy/packages/package.mask
echo ">=lxde-base/lxdm-0.4.1-r5@sabayonlinux.org" >> /etc/entropy/packages/package.mask
echo ">=lxde-base/lxdm-0.4.1-r5@sabayon-limbo" >> /etc/entropy/packages/package.mask

echo ">=app-admin/anaconda-0.9.9.95@sabayon-weekly" >> /etc/entropy/packages/package.mask
echo ">=app-admin/anaconda-0.9.9.95@sabayonlinux.org" >> /etc/entropy/packages/package.mask
echo ">=app-admin/anaconda-0.9.9.95@sabayon-limbo" >> /etc/entropy/packages/package.mask

echo ">=app-misc/anaconda-runtime-1.1-r1@sabayon-weekly" >> /etc/entropy/packages/package.mask
echo ">=app-misc/anaconda-runtime-1.1-r1@sabayonlinux.org" >> /etc/entropy/packages/package.mask
echo ">=app-misc/anaconda-runtime-1.1-r1@sabayon-limbo" >> /etc/entropy/packages/package.mask
