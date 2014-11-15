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

if [ -f "/etc/entropy/repositories.conf.d/entropy_kogaionlinux.example" ]; then
        mv "${EREPO}/entropy_kogaionlinux.example" "${EREPO}/entropy_kogaionlinux"
fi
	
if [ -f "${EREPO}/entropy_kogaion-stable" ]; then
	mv "${EREPO}/entropy_kogaion-stable" "${EREPO}/entropy_kogaion-stable.example"
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

mkdir -p /etc/entropy/packages/package.mask.d/
