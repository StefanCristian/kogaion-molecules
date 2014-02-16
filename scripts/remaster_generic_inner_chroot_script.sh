#!/bin/sh

/usr/sbin/env-update
. /etc/profile

# make sure there is no stale pid file around that prevents entropy from running
rm -f /var/run/entropy/entropy.lock

# disable all mirrors but GARR
#for repo_conf in /etc/entropy/repositories.conf.d/entropy_*; do
	# skip .example files
	#if [[ "${repo_conf}" =~ .*\.example$ ]]; then
		#echo "skipping ${repo_conf}"
		#continue
	#fi
	#sed -n -e "/^pkg = .*pkg.sabayon.org/p" -e "/^repo = .*pkg.sabayon.org/p" \
		#-e "/garr.it/p" -e "/^\[.*\]$/p" -i "${repo_conf}"

	# replace pkg.sabayon.org with pkg.repo.sabayon.org to improve
	# build server locality
	#sed -i "s;http://pkg.sabayon.org;http://pkg.repo.sabayon.org;g" "${repo_conf}"
#done

if [ -f "/etc/entropy/repositories.conf.d/entropy_sabayonlinux.org.example" ]; then
        mv "${EREPO}/entropy_sabayonlinux.org.example" "${EREPO}/entropy_sabayonlinux.org"
fi
	
if [ -f "${EREPO}/entropy_sabayon-weekly" ]; then
	mv "${EREPO}/entropy_sabayon-weekly" "${EREPO}/entropy_sabayon-weekly.example"
fi

export FORCE_EAPI=2

LOC=$(pwd)
EREPO=/etc/entropy/repositories.conf.d
if [ -f "/etc/entropy/repositories.conf.d/entropy_sabayonlinux.org.example" ]; then
        mv "${EREPO}/entropy_sabayonlinux.org.example" "${EREPO}/entropy_sabayonlinux.org"
fi

if [ -f "${EREPO}/entropy_sabayon-weekly" ]; then
        mv "${EREPO}/entropy_sabayon-weekly" "${EREPO}/entropy_sabayon-weekly.example"
fi

cd "$EREPO"
wget http://pkg.rogentos.ro/~rogentos/distro/entropy_rogentoslinux
equo repo mirrorsort rogentoslinux
equo repo mirrorsort sabayonlinux.org
equo update

updated=0
for ((i=0; i < 42; i++)); do
	equo update && {
		updated=1;
		break;
	}
	if [ ${i} -gt 6 ]; then
		sleep 3600 || exit 1
	else
		sleep 1200 || exit 1
	fi
done
if [ "${updated}" = "0" ]; then
	exit 1
fi

eselect kernel list
equo query installed linux-sabayon

#echo Yes | kernel-switcher switch linux-sabayon#$(equo search nvidia-drivers | grep sabayon | awk '{print $3}' | grep "sabayon" | sed 's/0,//g' | tail -1 | head -1) -pv

equo mask sabayon-skel sabayon-version sabayon-artwork-grub sabayon-live
equo remove sabayon-artwork-grub sabayon-artwork-core sabayon-artwork-isolinux sabayon-version sabayon-skel sabayon-live sabayonlive-tools sabayon-live grub sabayon-artwork-gnom --nodeps
#equo remove linux-sabayon:$(eselect kernel list | grep "*" | awk '{print $2}' | cut -d'-' -f2) --nodeps --configfiles
equo remove linux-sabayon --nodeps --configfiles
equo remove --force-system sabayon-version --configfiles
equo mask sabayon-version
equo install rogentos-version --nodeps

for SRV in zfs-kmod sys-kernel/spl nvidia-drivers ati-drivers virtualbox-modules virtualbox-guest-additions vmware-modules broadcom-sta vhba acpi_call bbswitch xf86-video-virtualbox nvidiabl; do
        WW="#"
	CC1="$(equo search nvidia-drivers | grep sabayon | awk '{print $3}' | grep "sabayon" | sed 's/0,//g' | sort -Vr | uniq | tail -n +1 | wc -l)"
	CC="$(equo search nvidia-drivers | grep sabayon | awk '{print $3}' | grep "sabayon" | sed 's/0,//g' | sort -Vr | uniq | tail -n +4 | wc -l)"
	EQ1="$(equo search nvidia-drivers | grep sabayon | awk '{print $3}' | grep "sabayon" | sed 's/0,//g' | sort -Vr | uniq | head -1)"
	EQ2="$(equo search nvidia-drivers | grep sabayon | awk '{print $3}' | grep "sabayon" | sed 's/0,//g' | sort -Vr | uniq | head -2 | tail -1)"
	EQ="equo search nvidia-drivers | grep sabayon | awk '{print $3}' | grep "sabayon" | sed 's/0,//g' | sort -Vr | uniq | tail -n +2"
	for BL in `seq 1 "${CC}"` ; do
	equo mask $SRV"${WW}"$(equo search nvidia-drivers | grep sabayon | awk '{print $3}' | grep "sabayon" | sed 's/0,//g' | sort -Vr | uniq | tail -n +2 | tail -"${BL}" | head -1)
	equo mask $SRV"${WW}"$(equo search nvidia-drivers | grep server | awk '{print $3}' | grep "server" | sed 's/0,//g' | sort -Vr | uniq | tail -"${BL}" | head -1)
	done
	equo mask $SRV"${WW}"${EQ1}
	equo mask $SRV"${WW}"${EQ2}
	equo mask $SRV"${WW}"$(equo search nvidia-drivers | grep sabayon | awk '{print $3}' | grep "sabayon" | sed 's/0,//g' | sort -Vr | uniq | head -2 | tail -1)
	# We may need to debug this
	equo install xf86-video-virtualbox"${WW}"$(equo search ati-drivers | grep sabayon | awk '{print $3}' | grep "sabayon" | sed 's/1,//g' | head -1) -p
done

mkdir -p /etc/entropy/packages/package.mask.d/

REPLACEMENT=">=sys-apps/openrc-0.9@sabayon-limbo
>=sys-apps/openrc-0.9@sabayonlinux.org
>=sys-apps/openrc-0.9@sabayon-weekly

>=app-misc/sabayonlive-tools-2.3@sabayon-limbo
>=app-misc/sabayonlive-tools-2.3@sabayonlinux.org
>=app-misc/sabayonlive-tools-2.3@sabayon-weekly

>=app-misc/sabayon-live-1.3@sabayon-limbo
>=app-misc/sabayon-live-1.3@sabayonlinux.org
>=app-misc/sabayon-live-1.3@sabayon-weekly

>=app-misc/sabayon-skel-1@sabayon-limbo
>=app-misc/sabayon-skel-1@sabayonlinux.org
>=app-misc/sabayon-skel-1@sabayon-weekly

>=sys-boot/grub-1.00@sabayon-limbo
>=sys-boot/grub-1.00@sabayonlinux.rg
>=sys-boot/grub-1.00@sabayon-weekly

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

>=sys-boot/plymouth-1@sabayon-weekly
>=sys-boot/plymouth-1@sabayonlinux.org
>=sys-boot/plymouth-1@sabayon-limbo

>=x11-themes/sabayon-artwork-core-1@sabayon-weekly
>=x11-themes/sabayon-artwork-core-1@sabayonlinux.org
>=x11-themes/sabayon-artwork-core-1@sabayon-limbo

>=x11-themes/sabayon-artwork-extra-1@sabayon-weekly
>=x11-themes/sabayon-artwork-extra-1@sabayonlinux.org
>=x11-themes/sabayon-artwork-extra-1@sabayon-limbo

>=x11-themes/sabayon-artwork-gnome-1@sabayon-weekly
>=x11-themes/sabayon-artwork-gnome-1@sabayonlinux.org
>=x11-themes/sabayon-artwork-gnome-1@sabayon-limbo

>=x11-themes/sabayon-artwork-grub-1@sabayon-weekly
>=x11-themes/sabayon-artwork-grub-1@sabayonlinux.org
>=x11-themes/sabayon-artwork-grub-1@sabayon-limbo

>=x11-themes/sabayon-artwork-isolinux-1@sabayon-weekly
>=x11-themes/sabayon-artwork-isolinux-1@sabayonlinux.org
>=x11-themes/sabayon-artwork-isolinux-1@sabayon-limbo

>=x11-themes/sabayon-artwork-kde-1@sabayon-weekly
>=x11-themes/sabayon-artwork-kde-1@sabayonlinux.org
>=x11-themes/sabayon-artwork-kde-1@sabayon-limbo

>=x11-themes/sabayon-artwork-loo-1@sabayon-weekly
>=x11-themes/sabayon-artwork-loo-1@sabayonlinux.org
>=x11-themes/sabayon-artwork-loo-1@sabayon-limbo

>=x11-themes/sabayon-artwork-lxde-1@sabayon-weekly
>=x11-themes/sabayon-artwork-lxde-1@sabayonlinux.org
>=x11-themes/sabayon-artwork-lxde-1@sabayon-limbo

>=app-misc/anaconda-runtime-1.1-r1@sabayon-weekly
>=app-misc/anaconda-runtime-1.1-r1@sabayonlinux.org
>=app-misc/anaconda-runtime-1.1-r1@sabayon-limbo"

echo $REPLACEMENT >> /etc/entropy/packages/package.mask
echo $REPLACEMENT >> /etc/entropy/packages/package.mask.d/package.mask
