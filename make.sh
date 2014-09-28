#!/bin/bash

SCRIPTNAME=$(basename "$0")
SCRIPTPATH=$(dirname "$0")
DESTPATH=${SCRIPTPATH}/..

ALLSOURCES="\
	netpoldo-deb8 \
	netpoldo-deb7 \
	netpoldo-deb6 \
	netpoldo-1404 \
	netpoldo-1204 \
	netpoldo-1004 \
"

REQUIRED="\
	uic \
"

ARCHS="32 64"

function test_source_dir {
	if [ ! -d "$1" ]; then
		echo "ERROR: Source path '$1' does not exist. Aborting..." >&2
		exit 5
	fi
}

function test_sources {
	[ $# -eq 0 ] && SOURCES=${ALLSOURCES}
	while [ $# -gt 0 ]; do
		SELMASK="${1:-*}"
		for SRCDIR in ${ALLSOURCES}; do
			case "${SRCDIR}" in
			(${SELMASK})
				test_source_dir "${SCRIPTPATH}/${SRCDIR}"
				SOURCES="${SOURCES} ${SRCDIR}"
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


function netpoldo_clean {
	test_sources "$@"
	for npdir in ${SOURCES}; do
		uic clean -v ${SCRIPTPATH}/${npdir}
		rm -f ${SCRIPTPATH}/${npdir}/uictpl.md5 ${SCRIPTPATH}/${npdir}_*.md5 ${SCRIPTPATH}/${npdir}_*.tar.bz2
	done
}

function netpoldo_make {
	test_sources "$@"
	for npdir in ${SOURCES}; do
		for arch in ${ARCHS}; do
			rm -rf ${SCRIPTPATH}/${npdir}/chroot
			uic create --variant ${arch} -v ${SCRIPTPATH}/${npdir}
			uic build -v ${SCRIPTPATH}/${npdir}
		done
	done
}

function netpoldo_pack {
	test_sources "$@"
	for npdir in ${SOURCES}; do
		uic pack -v -o ${SCRIPTPATH} ${SCRIPTPATH}/${npdir}
	done
}

function netpoldo_fake {
	test_sources "$@"
	for npdir in ${SOURCES}; do
		for arch in ${ARCHS}; do
			echo "would process: ${npdir} --variant ${arch}"
		done
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
ACTION="${1}"
shift
# eat optional architecture parameter
case "${1}" in
32|64)	ARCHS="${1}"
	shift
	;;
*)	ARCHS="32 64"
	;;
esac

case "${ACTION}" in
clean)
	netpoldo_clean "$@"
	;;
make)
	netpoldo_make "$@"
	;;
pack)
	netpoldo_pack "$@"
	;;
fake)
	netpoldo_fake "$@"
	;;
all)
	netpoldo_clean "$@"
	netpoldo_make "$@"
	netpoldo_pack "$@"
	;;
*)
	echo "Usage: make.sh {clean|make|pack|fake|all}"
        exit 1
        ;;
esac

exit 0
