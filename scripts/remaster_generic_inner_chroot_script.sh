#!/bin/sh

/usr/sbin/env-update
. /etc/profile

# make sure there is no stale pid file around that prevents entropy from running
rm -f /run/entropy/entropy.lock

# disable all mirrors but GARR
#for repo_conf in /etc/entropy/repositories.conf.d/entropy_*; do
	# skip .example files
	#if [[ "${repo_conf}" =~ .*\.example$ ]]; then
		#echo "skipping ${repo_conf}"
		#continue
	#fi
	#sed -n -e "/^pkg = .*pkg.rogentos.ro/p" -e "/^repo = .*pkg.rogentos.ro/p" \
		#-e "/garr.it/p" -e "/^\[.*\]$/p" -i "${repo_conf}"

	# replace pkg.rogentos.ro with pkg.repo.rogentos.ro to improve
	# build server locality
	#sed -i "s;http://pkg.rogentos.ro;http://pkg.repo.rogentos.ro;g" "${repo_conf}"
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
if [ -f "/etc/entropy/repositories.conf.d/entropy_kogaionlinux.example" ]; then
        mv "${EREPO}/entropy_kogaionlinux.example" "${EREPO}/entropy_kogaionlinux"
fi

if [ -f "${EREPO}/entropy_kogaion-weekly" ]; then
        mv "${EREPO}/entropy_kogaion-weekly" "${EREPO}/entropy_kogaion-weekly.example"
fi

cd "$EREPO"
equo repo mirrorsort kogaionlinux
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
