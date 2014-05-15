#!/bin/bash

SCRIPTNAME=$(basename "$0")
SCRIPTPATH=$(dirname "$0")
DESTPATH=${SCRIPTPATH}/..

ALLSOURCES="\
	netpoldo-deb8-64 netpoldo-deb8-32 \
	netpoldo-deb7-64 netpoldo-deb7-32 \
	netpoldo-deb6-64 netpoldo-deb6-32 \
	netpoldo-1204-64 netpoldo-1204-32 \
	netpoldo-1004-64 netpoldo-1004-32 \
"

REQUIRED="\
	uic \
"

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

function netpoldo_create {
	test_sources "$@"
	for npdir in ${SOURCES}; do
		uic create -v ${SCRIPTPATH}/${npdir}
	done
}

function netpoldo_build {
	test_sources "$@"
	for npdir in ${SOURCES}; do
		uic build -v ${SCRIPTPATH}/${npdir}
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
		echo "would process: ${npdir}"
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
clean)
	netpoldo_clean "$@"
	;;
create)
	netpoldo_create "$@"
	;;
build)
	netpoldo_build "$@"
	;;
pack)
	netpoldo_pack "$@"
	;;
fake)
	netpoldo_fake "$@"
	;;
all)
	netpoldo_clean "$@"
	netpoldo_create "$@"
	netpoldo_build "$@"
	netpoldo_pack "$@"
	;;
*)
	echo "Usage: make.sh {clean|create|build|pack|fake|all}"
        exit 1
        ;;
esac

exit 0
