#!/bin/bash

# Path to molecules.git dir
KOGAION_MOLECULE_HOME="${KOGAION_MOLECULE_HOME:-/kogaion}"
export KOGAION_MOLECULE_HOME

# setup default language, cron might not do that
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"

VALID_ACTIONS=(
	"daily"
	"weekly"
	"monthly"
	"dailybase"
	"release"
)

ACTION="${1}"
ACTION_VALID=
for act in "${VALID_ACTIONS[@]}"; do
	if [ "${act}" = "${ACTION}" ]; then
		ACTION_VALID=1
		break
	fi
done
if [ -z "${ACTION_VALID}" ]; then
	echo "invalid action: ${ACTION}" >&2
	exit 1
fi
shift

for arg in "$@"; do
	[[ "${arg}" = "--push" ]] && DO_PUSH="1"
	[[ "${arg}" = "--stdout" ]] && DO_STDOUT="1"
	[[ "${arg}" = "--sleepnight" ]] && DO_SLEEPNIGHT="1"
	[[ "${arg}" = "--pushonly" ]] && DO_PUSHONLY="1"
	[[ "${arg}" = "--torrents" ]] && MAKE_TORRENTS="1"
done

# Initialize script variables
ARM_SOURCE_SPECS=()
ARM_SOURCE_SPECS_IMG=()
SOURCE_SPECS=()
SOURCE_SPECS_ISO=()
REMASTER_SPECS=()
REMASTER_SPECS_ISO=()
REMASTER_TAR_SPECS=()
REMASTER_TAR_SPECS_TAR=()

# Default Kogaion release version to current date
# composed by YYYYMMDD. This is overridden by the
# monthly if branch below.
if [ -z "${KOGAION_RELEASE}" ]; then  # make possible to override it
	if [ "${ACTION}" = "release" ]; then
		echo "Missing KOGAION_RELEASE env var" >&2
		exit 1
	fi
	KOGAION_RELEASE=$(date -u +%Y%m%d)
fi
# ISO TAG is instead used as part of the images push
# to our mirror. It is always "DAILY" but it gets a special
# meaning for monthly releases.
ISO_TAG="DAILY"
OLD_ISO_TAG=""  # used to remove OLD ISO images the local dir
DISTRO_NAME="Kogaion_Linux"
ISO_DIR="daily"
CHANGELOG_DATES=""
CHANGELOG_DIR="${KOGAION_MOLECULE_HOME}/${ACTION}-git-logs"

if [ "${ACTION}" = "weekly" ] || [ "${ACTION}" = "daily" ]; then
	export BUILDING_DAILY=1

	# Daily molecules
	SOURCE_SPECS+=(
		"kogaion-x86-spinbase.spec"
		"kogaion-amd64-spinbase.spec"
	)
	SOURCE_SPECS_ISO+=(
		"${DISTRO_NAME}_${ISO_TAG}_x86_SpinBase.iso"
		"${DISTRO_NAME}_${ISO_TAG}_amd64_SpinBase.iso"
	)
	REMASTER_SPECS+=(
		"kogaion-amd64-gnome.spec"
		"kogaion-x86-gnome.spec"
		"kogaion-amd64-kde.spec"
		"kogaion-x86-kde.spec"
		"kogaion-amd64-mate.spec"
		"kogaion-x86-mate.spec"
		"kogaion-amd64-xfce.spec"
		"kogaion-x86-xfce.spec"
		"kogaion-amd64-e17.spec"
		"kogaion-x86-e17.spec"
		"kogaion-amd64-minimal.spec"
		"kogaion-x86-minimal.spec"
	)
	REMASTER_SPECS_ISO+=(
		"${DISTRO_NAME}_${ISO_TAG}_amd64_GNOME.iso"
		"${DISTRO_NAME}_${ISO_TAG}_x86_GNOME.iso"
		"${DISTRO_NAME}_${ISO_TAG}_amd64_KDE.iso"
		"${DISTRO_NAME}_${ISO_TAG}_x86_KDE.iso"
		"${DISTRO_NAME}_${ISO_TAG}_amd64_MATE.iso"
		"${DISTRO_NAME}_${ISO_TAG}_x86_MATE.iso"
		"${DISTRO_NAME}_${ISO_TAG}_amd64_Xfce.iso"
		"${DISTRO_NAME}_${ISO_TAG}_x86_Xfce.iso"
		"${DISTRO_NAME}_${ISO_TAG}_amd64_E17.iso"
		"${DISTRO_NAME}_${ISO_TAG}_x86_E17.iso"
		"${DISTRO_NAME}_${ISO_TAG}_amd64_Minimal.iso"
		"${DISTRO_NAME}_${ISO_TAG}_x86_Minimal.iso"
	)

	# Weekly molecules
	if [ "${ACTION}" = "weekly" ]; then
		#ARM_SOURCE_SPECS+=(
		#	"kogaion-arm-beaglebone-base-2G.spec"
		#	"kogaion-arm-beaglebone-base-4G.spec"
		#	"kogaion-arm-beagleboard-xm-4G.spec"
		#	"kogaion-arm-beagleboard-xm-8G.spec"
		#	"kogaion-arm-pandaboard-4G.spec"
		#	"kogaion-arm-pandaboard-8G.spec"
		#	"kogaion-arm-efikamx-base-4G.spec"
		#)
		#ARM_SOURCE_SPECS_IMG+=(
		#	"${DISTRO_NAME}_${ISO_TAG}_armv7a_BeagleBone_Base_2GB.img"
		#	"${DISTRO_NAME}_${ISO_TAG}_armv7a_BeagleBone_Base_4GB.img"
		#	"${DISTRO_NAME}_${ISO_TAG}_armv7a_BeagleBoard_xM_4GB.img"
		#	"${DISTRO_NAME}_${ISO_TAG}_armv7a_BeagleBoard_xM_8GB.img"
		#	"${DISTRO_NAME}_${ISO_TAG}_armv7a_PandaBoard_4GB.img"
		#	"${DISTRO_NAME}_${ISO_TAG}_armv7a_PandaBoard_8GB.img"
		#	"${DISTRO_NAME}_${ISO_TAG}_armv7a_EfikaMX_Base_4GB.img"
		#)
		REMASTER_SPECS+=(
			"kogaion-amd64-xfceforensic.spec"
			"kogaion-x86-xfceforensic.spec"
		)
		REMASTER_SPECS_ISO+=(
			"${DISTRO_NAME}_${ISO_TAG}_amd64_ForensicsXfce.iso"
			"${DISTRO_NAME}_${ISO_TAG}_x86_ForensicsXfce.iso"
		)
		REMASTER_TAR_SPECS+=(
			"kogaion-x86-spinbase-openvz-template.spec"
			"kogaion-amd64-spinbase-openvz-template.spec"
			"kogaion-x86-spinbase-amazon-ebs-image.spec"
			"kogaion-amd64-spinbase-amazon-ebs-image.spec"
		)
		REMASTER_TAR_SPECS_TAR+=(
			"${DISTRO_NAME}_${ISO_TAG}_x86_SpinBase_openvz.tar.gz"
			"${DISTRO_NAME}_${ISO_TAG}_amd64_SpinBase_openvz.tar.gz"
			"${DISTRO_NAME}_${ISO_TAG}_x86_SpinBase_Amazon_EBS_ext4_filesystem_image.tar.gz"
			"${DISTRO_NAME}_${ISO_TAG}_amd64_SpinBase_Amazon_EBS_ext4_filesystem_image.tar.gz"
		)
	fi
elif [ "${ACTION}" = "dailybase" ]; then
	export BUILDING_DAILY=1

	SOURCE_SPECS+=(
		"kogaion-x86-spinbase.spec"
		"kogaion-amd64-spinbase.spec"
	)
	SOURCE_SPECS_ISO+=(
		"${DISTRO_NAME}_${ISO_TAG}_x86_SpinBase.iso"
		"${DISTRO_NAME}_${ISO_TAG}_amd64_SpinBase.iso"
	)
elif [ "${ACTION}" = "monthly" ] || [ "${ACTION}" = "release" ]; then
	if [ "${ACTION}" = "monthly" ]; then
		KOGAION_RELEASE=$(date -u +%g.%m)
	fi
	if [ -z "${KOGAION_RELEASE}" ]; then  # release action must set this
		echo "Cannot set KOGAION_RELEASE, wtf?" >&2
		exit 1
	fi
	# Rewrite ISO_TAG to KOGAION_RELEASE
	ISO_TAG="${KOGAION_RELEASE}"
	if [ "${ACTION}" = "monthly" ]; then
		OLD_ISO_TAG=$(date -u --date="last month" +%g.%m)
		if [ -z "${OLD_ISO_TAG}" ]; then
			echo "Cannot set OLD_ISO_TAG, wtf?" >&2
			exit 1
		fi
	fi
	ISO_DIR="monthly"
	_previous_month=$(date -d "- 1 month" "+%Y-%m-%d")
	_current_month=$(date +%Y-%m-%d)
	CHANGELOG_DATES="${_previous_month} ${_current_month}"
	mkdir -p "${CHANGELOG_DIR}" || exit 1

	SOURCE_SPECS+=(
		"kogaion-x86-spinbase.spec"
		"kogaion-amd64-spinbase.spec"
	)
	SOURCE_SPECS_ISO+=(
		"${DISTRO_NAME}_${ISO_TAG}_x86_SpinBase.iso"
		"${DISTRO_NAME}_${ISO_TAG}_amd64_SpinBase.iso"
	)
	REMASTER_SPECS+=(
		"kogaion-amd64-gnome.spec"
		"kogaion-x86-gnome.spec"
		"kogaion-amd64-kde.spec"
		"kogaion-x86-kde.spec"
		"kogaion-amd64-mate.spec"
		"kogaion-x86-mate.spec"
		"kogaion-amd64-xfce.spec"
		"kogaion-x86-xfce.spec"
		"kogaion-amd64-minimal.spec"
		"kogaion-x86-minimal.spec"
	)
	REMASTER_SPECS_ISO+=(
		"${DISTRO_NAME}_${ISO_TAG}_amd64_GNOME.iso"
		"${DISTRO_NAME}_${ISO_TAG}_x86_GNOME.iso"
		"${DISTRO_NAME}_${ISO_TAG}_amd64_KDE.iso"
		"${DISTRO_NAME}_${ISO_TAG}_x86_KDE.iso"
		"${DISTRO_NAME}_${ISO_TAG}_amd64_MATE.iso"
		"${DISTRO_NAME}_${ISO_TAG}_x86_MATE.iso"
		"${DISTRO_NAME}_${ISO_TAG}_amd64_Xfce.iso"
		"${DISTRO_NAME}_${ISO_TAG}_x86_Xfce.iso"
		"${DISTRO_NAME}_${ISO_TAG}_amd64_Minimal.iso"
		"${DISTRO_NAME}_${ISO_TAG}_x86_Minimal.iso"
	)
fi

DAILY_TMPDIR=

# molecules are referencing ISO_TAG in their source_iso parameter
export ISO_TAG

export ETP_NONINTERACTIVE=1

LOG_FILE="/var/log/molecule/autobuild-${KOGAION_RELEASE}-${$}.log"
# to make ISO remaster spec files working (pre_iso_script) and
# make molecules grab a proper release version
export KOGAION_RELEASE

echo "DO_PUSH=${DO_PUSH}"
echo "DO_PUSHONLY=${DO_PUSHONLY}"
echo "DO_SLEEPNIGHT=${DO_SLEEPNIGHT}"
echo "LOG_FILE=${LOG_FILE}"

sleepnight() {
	if [ "${DO_SLEEPNIGHT}" = "1" ]; then
		target_h=22 # 22pm
		current_h=$(date +%H)
		current_h=${current_h/0} # remove leading 0
		delta_h=$(( target_h - current_h ))
		if [ ${current_h} -ge 0 ] && [ ${current_h} -le 6 ]; then
			# If it's past midnight and no later than 7am
			# just push
			echo "Just pusing out now"
		elif [ ${delta_h} -gt 0 ]; then
			delta_s=$(( delta_h * 3600 ))
			echo "Sleeping for ${delta_h} hours..."
			sleep ${delta_s} || exit 1
		elif [ ${delta_h} -lt 0 ]; then
			# between 22 and 24, run!
			echo "I'm after 22pm, running"
		else
			echo "No need to sleep"
		fi
	fi
}

# Create log dir if it does not exist
mkdir -p /var/log/molecule || exit 1

cleanup_on_exit() {
	if [ -n "${DAILY_TMPDIR}" ] && [ -d "${DAILY_TMPDIR}" ]; then
		rm -rf "${DAILY_TMPDIR}"
		# don't care about races
		DAILY_TMPDIR=""
	fi
}
trap "cleanup_on_exit" EXIT INT TERM

safe_run() {
	local done=0
	local count="${1}"
	shift

	for ((i=0; i < ${count}; i++)); do
		"${@}" && {
			done=1;
			break;
		}
		sleep 10 || return 1
	done
	if [ "${done}" = "0" ]; then
		return 1
	fi
	return 0
}

move_to_mirrors() {
	local do_push="${KOGAION_MOLECULE_HOME}"/DO_PUSH
	local server="entropy@pkg.rogentos.ro"
	local ssh_dir="/kogaion/rsync"
	local ssh_path="${server}:${ssh_dir}"

	if [ -n "${DO_PUSH}" ] || [ -f "${do_push}" ]; then

		sleepnight
		rm -f "${do_push}"

		safe_run 5 rsync -av --partial --bwlimit=2048 \
			"${KOGAION_MOLECULE_HOME}"/iso_rsync/*"${ISO_TAG}"* \
			"${ssh_path}/rsync.rogentos.ro/iso/${ISO_DIR}" \
			|| return 1

		if [ -n "${CHANGELOG_DATES}" ]; then
			safe_run 5 rsync -av --partial \
			"${CHANGELOG_DIR}"/ \
			"${ssh_path}/rsync.rogentos.ro/iso/${ISO_DIR}/ChangeLogs/"
		fi

		safe_run 5 rsync -av --partial \
			"${KOGAION_MOLECULE_HOME}"/scripts/gen_html \
			"${ssh_path}"/iso_html_generator \
			|| return 1

		safe_run 5 ssh "${server}" \
			"${ssh_dir}"/iso_html_generator/gen_html/gen.sh \
			|| return 1
	fi
	return 0
}

build_kogaion() {
	DAILY_TMPDIR=$(mktemp -d --suffix=.iso_build.sh --tmpdir=/tmp)
	[[ -z "${DAILY_TMPDIR}" ]] && return 1
	DAILY_TMPDIR_REMASTER="${DAILY_TMPDIR}/remaster"
	mkdir "${DAILY_TMPDIR_REMASTER}" || return 1

	local scripts_dir="${KOGAION_MOLECULE_HOME}/scripts"
	local inner_chroot="${scripts_dir}/inner_source_chroot_update.sh"

	local source_specs=()
	for i in ${!SOURCE_SPECS[@]}; do
		src="${KOGAION_MOLECULE_HOME}/molecules/${SOURCE_SPECS[i]}"
		dst="${DAILY_TMPDIR}/${SOURCE_SPECS[i]}"
		cp "${src}" "${dst}" -p || return 1
		echo >> "${dst}"
		echo "inner_source_chroot_script: ${inner_chroot}" >> "${dst}"

		# tweak iso image name
		sed -i "s/destination_iso_image_name:.*/destination_iso_image_name: ${SOURCE_SPECS_ISO[i]}/" \
			"${dst}" || return 1

		echo -n "${dst}: iso: ${SOURCE_SPECS_ISO[i]} "
		echo "release: ${KOGAION_RELEASE}"
		source_specs+=( "${dst}" )
	done

	local arm_source_specs=()
	for i in ${!ARM_SOURCE_SPECS[@]}; do
		src="${KOGAION_MOLECULE_HOME}/molecules/${ARM_SOURCE_SPECS[i]}"
		dst="${DAILY_TMPDIR}/${ARM_SOURCE_SPECS[i]}"
		cp "${src}" "${dst}" -p || return 1
		echo >> "${dst}"
		echo "inner_source_chroot_script: ${inner_chroot}" >> "${dst}"

		# tweak iso image name
		sed -i "s/image_name:.*/image_name: ${ARM_SOURCE_SPECS_IMG[i]}/" \
			"${dst}" || return 1

		echo -n "${dst}: image: ${ARM_SOURCE_SPECS_IMG[i]} "
		echo "release: ${KOGAION_RELEASE}"
		arm_source_specs+=( "${dst}" )
	done

	local remaster_specs=()
	for i in ${!REMASTER_SPECS[@]}; do
		src="${KOGAION_MOLECULE_HOME}/molecules/${REMASTER_SPECS[i]}"
		dst="${DAILY_TMPDIR_REMASTER}/${REMASTER_SPECS[i]}"
		cp "${src}" "${dst}" -p || return 1

		# tweak iso image name
		sed -i "s/destination_iso_image_name:.*/destination_iso_image_name: ${REMASTER_SPECS_ISO[i]}/" \
			"${dst}" || return 1

		echo -n "${dst}: iso: ${REMASTER_SPECS_ISO[i]} "
		echo "release: ${KOGAION_RELEASE}"
		remaster_specs+=( "${dst}" )
	done

	for i in ${!REMASTER_TAR_SPECS[@]}; do
		src="${KOGAION_MOLECULE_HOME}/molecules/${REMASTER_TAR_SPECS[i]}"
		dst="${DAILY_TMPDIR_REMASTER}/${REMASTER_TAR_SPECS[i]}"
		cp "${src}" "${dst}" -p || return 1

		# tweak tar name
		sed -i "s/tar_name:.*/tar_name: ${REMASTER_TAR_SPECS_TAR[i]}/" "${dst}" || return 1

		echo -n "${dst}: tar: ${REMASTER_TAR_SPECS_TAR[i]} "
		echo "release: ${KOGAION_RELEASE}"
		remaster_specs+=( "${dst}" )
	done

	local done_images=0
	local done_something=0

	if [ ${#arm_source_specs[@]} != 0 ]; then
		molecule --nocolor "${arm_source_specs[@]}" || return 1
		done_something=1
		done_images=1
	fi
	if [ ${#source_specs[@]} != 0 ]; then
		molecule --nocolor "${source_specs[@]}" || return 1
		done_something=1
	fi
	if [ ${#remaster_specs[@]} != 0 ]; then
		molecule --nocolor "${remaster_specs[@]}" || return 1
		done_something=1
	fi

	# package phases keep loading dbus, let's kill pids back
	ps ax | grep -- "/usr/bin/dbus-daemon --fork .* --session" | awk '{ print $1 }' | xargs kill 2> /dev/null

	if [ "${done_something}" = "1" ]; then
		if [ "${done_images}" = "1" ]; then
			cp -p "${KOGAION_MOLECULE_HOME}"/images/*"${ISO_TAG}"* \
				"${KOGAION_MOLECULE_HOME}"/iso_rsync/ \
				|| return 1
		fi
		cp -p "${KOGAION_MOLECULE_HOME}"/iso/*"${ISO_TAG}"* \
			"${KOGAION_MOLECULE_HOME}"/iso_rsync/ || return 1
		date > "${KOGAION_MOLECULE_HOME}"/iso_rsync/RELEASE_DATE_"${ISO_TAG}"
		if [ -n "${MAKE_TORRENTS}" ]; then
			"${KOGAION_MOLECULE_HOME}"/scripts/make_torrents.sh \
			|| return 1
		fi

		# remove old ISO images?
		if [ -n "${OLD_ISO_TAG}" ]; then
			echo "Removing old ISO images tagged ${OLD_ISO_TAG} -- won't remove remote images"
			rm -rf "${KOGAION_MOLECULE_HOME}"/{images,iso,iso_rsync}/"${DISTRO_NAME}"*"${OLD_ISO_TAG}"*
		fi

	fi

	if [ -n "${CHANGELOG_DATES}" ]; then
		"${KOGAION_MOLECULE_HOME}"/scripts/make_git_logs.sh \
			"${CHANGELOG_DIR}" ${CHANGELOG_DATES}
	fi

	return 0
}

mail_failure() {
	local out=${1}
	local log_file=${2}
	local log_cont=

	# get the last 64 lines of the file
	if [ -f "${log_file}" ]; then
		log_cont=$(tail -n 64 "${log_file}" 2> /dev/null)
	fi

	echo "Hello there,
iso_build.sh execution failed (miserably) with exit status: ${out}.
Log file is at: ${log_file}

Last log lines:
[... snip ...]
${log_cont}
[... snip ...]

Thanks,
Sun" | /bin/mail -s "ISO build script failure" root
}

out="0"
if [ -n "${DO_STDOUT}" ]; then
	[[ -n "${DO_PUSHONLY}" ]] || build_kogaion
	out=${?}
	if [ "${out}" = "0" ]; then
		move_to_mirrors
		out=${?}
	fi
else
	log_file="/var/log/molecule/autobuild-${KOGAION_RELEASE}-${$}.log"
	[[ -n "${DO_PUSHONLY}" ]] || build_kogaion &> "${log_file}"
	out=${?}
	if [ "${out}" = "0" ]; then
		move_to_mirrors &>> "${log_file}"
		out=${?}
	fi
	if [ "${out}" != "0" ]; then
		# mail root
		mail_failure "${out}" "${log_file}"
	fi
fi
echo "EXIT_STATUS: ${out}"

exit ${out}
