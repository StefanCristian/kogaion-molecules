#!/bin/bash

REMASTER_SPECS+=(
		"kogaion-amd64-xfce.spec"
		)

REMASTER_SPECS_ISO+=(
		"Kogaion_amd64_1~5_xfce.iso"
		)


# Path to molecules.git dir
ROGENTOS_MOLECULE_HOME="${ROGENTOS_MOLECULE_HOME:-/sabayon}"

export ROGENTOS_MOLECULE_HOME

CUR_DATE=$(date -u +%Y%m%d%H%M)

#molecule $ROGENTOS_MOLECULE_HOME/kogaion-amd64-xfce.spec

	for i in ${!REMASTER_SPECS[@]}
		do
			REMASTER_SPECS_ISO_BUILD_DATE=`basename -s .iso ${REMASTER_SPECS_ISO[i]}`'_'$CUR_DATE'.iso'
			echo $REMASTER_SPECS_ISO_BUILD_DATE
			dst="${ROGENTOS_MOLECULE_HOME}/molecules/${REMASTER_SPECS[i]}"
			# tweak iso image name
			sed -i "s/^#.*destination_iso_image_name/destination_iso_image_name:/" "${dst}" || return 1
			sed -i "s/destination_iso_image_name.*/destination_iso_image_name: ${REMASTER_SPECS_ISO_BUILD_DATE}/" "${dst}" || return 1
			# tweak release version
			sed -i "s/release_version.*/release_version: ${CUR_DATE}/" "${dst}" || return 1
			echo "${dst}: iso: ${REMASTER_SPECS_ISO_BUILD_DATE} date: ${CUR_DATE}"
			remaster_specs+="${dst} "
		done

	if [ -n "${remaster_specs}" ]; then
			molecule --nocolor ${remaster_specs} || return 1
			done_something=1
		fi

