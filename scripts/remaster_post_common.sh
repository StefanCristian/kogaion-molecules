# switch to kogaion-weekly repository if the ISO is not a DAILY one
# BUILDING_DAILY is set in scripts/daily_iso_build.sh
if [ -z "${BUILDING_DAILY}" ]; then
	# only the first occurence
	repo_conf="${CHROOT_DIR}/etc/entropy/repositories.conf"
	#sed -i "/^officialrepositoryid/ s/kogaionlinux.ro/kogaion-weekly/" "${repo_conf}" || exit 1
	#sed -i "/^official-repository-id/ s/kogaionlinux.ro/kogaion-weekly/" "${repo_conf}" || exit 1
	#sed -i "/^repository =/ s/kogaionlinux.ro/kogaion-weekly/" "${repo_conf}" || exit 1

	sed -i "/^officialrepositoryid/ s/kogaion-weekly/kogaionlinux.ro/" "${repo_conf}" || exit 1
	sed -i "/^official-repository-id/ s/kogaion-weekly/kogaionlinux.ro/" "${repo_conf}" || exit 1
	sed -i "/^repository =/ s/kogaion-weekly/kogaionlinux.ro/" "${repo_conf}" || exit 1

	# new style repository config files (inside
	# repositories.conf.d/ directory)
	repo_conf_d="${CHROOT_DIR}/etc/entropy/repositories.conf.d"
	src_conf="${repo_conf_d}/entropy_kogaion-weekly"
	dst_conf="${repo_conf_d}/entropy_kogaionlinux.ro"
	if [ -f "${src_conf}" ]; then
		mv "${src_conf}" "${dst_conf}" || exit 1
		#sed -i "/^\[kogaionlinux.ro\]$/ s/kogaionlinux.ro/kogaion-weekly/" \
		sed -i "/^\[kogaion-weekly\]$/ s/kogaion-weekly/kogaionlinux.org/" \
			"${dst_conf}" || exit 1
	fi
	# so we will defend our users from kogaion testing repos, starting today
	rm "${repo_conf_d}"/entropy_kogaion-test
	cd "${repo_conf_d}"
fi

# remove entropy hwash
rm -f "${CHROOT_DIR}"/etc/entropy/.hw.hash
# remove entropy pid file
rm -f "${CHROOT_DIR}"/var/run/entropy/entropy.lock

# do not exit!! this file is sourced!

# remove entropy hwash
rm -f "${CHROOT_DIR}"/etc/entropy/.hw.hash
# remove entropy pid file
rm -f "${CHROOT_DIR}"/var/run/entropy/entropy.lock

# remove /run/* and /var/lock/*
# systemd mounts them using tmpfs
rm -rf "${CHROOT_DIR}"/run/*
rm -rf "${CHROOT_DIR}"/var/lock/*
