#!/bin/bash

case "$0" in
/*)  SCRIPTFULL="$0";;
./*) SCRIPTFULL="${PWD}/${0#./}";;
*)   SCRIPTFULL="${PWD}/${0}";;
esac

SCRIPTNAME=$(basename "${SCRIPTFULL}")
SCRIPTPATH=$(dirname "${SCRIPTFULL}")

ISOAREA="${SCRIPTPATH}/isotemp"
BOOTAREA="${SCRIPTPATH}/boottemp"
BUILDPATH="${SCRIPTPATH}/build"

ALLSOURCES="\
	netpoldo-deb8 \
	netpoldo-deb7 \
	netpoldo-deb6 \
	netpoldo-1204 \
	netpoldo-1004 \
"

REQUIRED="\
	uic \
	tar \
	gzip \
	syslinux \
	extlinux \
"

function test_source_areas {
	for FLAV in 32 64; do
		npdir="${SCRIPTPATH}/$1-${FLAV}"
		if [ ! -d "${npdir}" ]; then
			echo "ERROR: Source path '${npdir}' does not exist. Aborting..." >&2
			exit 2
		fi
		if [ ! -f "${npdir}/uictpl.conf" ]; then
			echo "ERROR: The uic configuration file is missing from $1-${FLAV}." >&2
			exit 2
		fi
		for npext in vmlinuz initrd initrdi initrdn squashfs; do
			if [ ! -f "${npdir}/output/netpoldo.${npext}" ]; then
				echo "ERROR: Some of the needed artefacts are missing from $1-${FLAV}." >&2
				exit 2
			fi
		done
	done
}

function test_sources {
	[ $# -eq 0 ] && SOURCES=${ALLSOURCES}
	while [ $# -gt 0 ]; do
		SELMASK="${1:-*}"
		for SRCSTUB in ${ALLSOURCES}; do
			case "${SRCSTUB}" in
			(${SELMASK})
				test_source_areas "${SRCSTUB}"
				SOURCES="${SOURCES} ${SRCSTUB}"
				;;
			esac
		done
		shift
	done
	if [ -z "${SOURCES}" ]; then
		echo "ERROR: No valid target specified" >&2
		echo "Valid targets: ${ALLSOURCES}" >&2
		exit 2
	fi
}

function make_delivery_area {
	TARGET="${BOOTAREA}/${1}"
	echo "Creating delivery area ${TARGET}"

	rm -rf ${TARGET}
	mkdir -p ${TARGET}/i386/pxelinux.cfg
	mkdir -p ${TARGET}/amd64/pxelinux.cfg

	echo "DEFAULT netpoldo.vmlinuz initrd=netpoldo.initrdi keyboard=us password=password" > ${TARGET}/i386/pxelinux.cfg/default
	echo "DEFAULT netpoldo.vmlinuz initrd=netpoldo.initrdi keyboard=us password=password" > ${TARGET}/amd64/pxelinux.cfg/default
	cp -a /usr/lib/syslinux/pxelinux.0		${TARGET}/i386
	cp -a /usr/lib/syslinux/pxelinux.0		${TARGET}/amd64
	cp -a ${SCRIPTPATH}/${1}-32/output/*		${TARGET}/i386
	cp -a ${SCRIPTPATH}/${1}-64/output/*		${TARGET}/amd64
	cp -a ${SCRIPTPATH}/*.md			${TARGET}
}

function kill_delivery_area {
	TARGET="${BOOTAREA}/${1}"
	echo "Cleaning up delivery area ${TARGET}"
	rm -rf "${BOOTAREA}"
}

function uic_require {
	# do nothing
	return 0
}

function uic_load {
	. ${1}
	case "${UIC_RELEASE}" in
	(squeeze|wheezy|jessie|sid)
		DISTRO="debian"
		CISTRO="Debian"
		;;
	(*)
		DISTRO="ubuntu"
		CISTRO="Ubuntu"
		;;
	esac
}

function create_archives {
	echo "Creating archives from ${BOOTAREA}"
	for BITS in 32 64; do
		npdir="${SCRIPTPATH}/${1}-${BITS}"
		uic_load "${npdir}/uictpl.conf"
		TARFILE="${SCRIPTPATH}/netpoldo-${DISTRO}-${UIC_SRCVERSION}-${UIC_ARCH}.tar.gz"
		REFFILE="${SCRIPTPATH}/${1}-${BITS}/output/netpoldo.squashfs"
		tar -cvzf ${TARFILE} -C ${BOOTAREA} ${1}/${UIC_ARCH} ${1}/README.md ${1}/RELNOTES.md
		touch --reference ${REFFILE} ${TARFILE}
	done
}

function create_iso {
	uic_load "${SCRIPTPATH}/${1}-64/uictpl.conf"
	echo "Creating iso file"

	rm -rf "${ISOAREA}"
	mkdir "${ISOAREA}"
	mkdir "${ISOAREA}/isolinux"
	mkdir "${ISOAREA}/memtest"

	cp /usr/lib/syslinux/isolinux.bin		${ISOAREA}/isolinux
	cp /usr/lib/syslinux/menu.c32			${ISOAREA}/isolinux
	cp ${BUILDPATH}/textmode.conf			${ISOAREA}/isolinux
	cp ${BUILDPATH}/memtest86+-5.01.bin		${ISOAREA}/memtest/memtest.bin
	ln -s ${BOOTAREA}/${1}				${ISOAREA}/netpoldo
	(
	cat <<EOF
DEFAULT			menu.c32
PROMPT			0
TIMEOUT			50
ONTIMEOUT		l0

MENU INCLUDE		textmode.conf
MENU TITLE		YeaSoft's NetPoldo ${CISTRO} Rescue System ${UIC_SRCVERSION}
MENU AUTOBOOT		Starting local system in # second{,s}

EOF
	) > ${ISOAREA}/isolinux/isolinux.cfg

	sed -e "s/${1}/netpoldo/g" < ${BUILDPATH}/${1}.menu >> ${ISOAREA}/isolinux/isolinux.cfg

	(
	cat <<EOF

MENU SEPARATOR

LABEL memtest
	MENU LABEL      ^Memory Failure Detection (memtest86+)
	TEXT HELP
 * version: 5.01, (C) 2013, Samuel DEMEULEMEESTER
 * http://www.memtest.org
 * Deep Memory Tester
	ENDTEXT
	KERNEL          /memtest/memtest.bin


EOF
	) >> ${ISOAREA}/isolinux/isolinux.cfg


	ISOFILE="${SCRIPTPATH}/netpoldo-${DISTRO}-${UIC_SRCVERSION}.iso"
	REFFILE="${BOOTAREA}/${1}/amd64/netpoldo.squashfs"

	mkisofs -o ${ISOFILE} \
		-V "NetPoldo ${UIC_SRCVERSION}" \
		-b isolinux/isolinux.bin \
		-c isolinux/boot.cat \
		-no-emul-boot \
		-boot-load-size 4 \
		-boot-info-table \
		-f \
		-r -J -max-iso9660-filenames -udf \
		${ISOAREA}


	touch --reference ${REFFILE} ${ISOFILE}
	rm -rf ${ISOAREA}
}



function netpoldo_fake {
	test_sources "$@"
	for npstub in ${SOURCES}; do
		echo "would process: ${npstub}"
	done
}

function netpoldo_tar {
	test_sources "$@"
	for npstub in ${SOURCES}; do
		make_delivery_area "${npstub}"
		create_archives "${npstub}"
		kill_delivery_area "${npstub}"
	done
}

function netpoldo_iso {
	test_sources "$@"
	for npstub in ${SOURCES}; do
		make_delivery_area "${npstub}"
		create_iso "${npstub}"
		kill_delivery_area "${npstub}"
	done
}

function netpoldo_all {
	test_sources "$@"
	for npstub in ${SOURCES}; do
		make_delivery_area "${npstub}"
		create_archives "${npstub}"
		create_iso "${npstub}"
		kill_delivery_area "${npstub}"
	done
}


# check for required tools
for REQTOOL in ${REQUIRED}; do
	if ! which ${REQTOOL} > /dev/null; then
		echo "ERROR: ${REQTOOL} is not installed" >&2
		exit 2
	fi
done

# eat action parameter
ACTION="$1"
shift

case "${ACTION}" in
fake)
	netpoldo_fake "$@"
	;;
tar)
	netpoldo_tar "$@"
	;;
iso)
	netpoldo_iso "$@"
	;;
all)
	netpoldo_all "$@"
	;;
*)
	echo "Usage: wrap.sh {fake|tar|iso|all}"
        exit 1
        ;;
esac

exit 0
