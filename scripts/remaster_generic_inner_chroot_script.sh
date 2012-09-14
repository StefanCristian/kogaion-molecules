#!/bin/sh

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
equo update
if [ "${?}" != "0" ]; then
        sleep 1200 || exit 1
        equo update || exit 1
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
