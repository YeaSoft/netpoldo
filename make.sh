#!/bin/bash

ALLSOURCES="\
	netpoldo-deb8-64 netpoldo-deb8-32 \
	netpoldo-deb7-64 netpoldo-deb7-32 \
	netpoldo-deb6-64 netpoldo-deb6-32 \
	netpoldo-1204-64 netpoldo-1204-32 \
	netpoldo-1004-64 netpoldo-1004-32 \
"

SCRIPTNAME=$(basename "$0")
SCRIPTPATH=$(dirname "$0")
DESTPATH=${SCRIPTPATH}/..

function test_source_dir {
	if [ ! -d "$1" ]; then
		echo "ERROR: Source path '$1' does not exist. Aborting..." >&2
		exit 5
	fi
}

function test_sources {
	while [ $# -gt 0 ]; do
		SELMASK="${1:-*}"
		for SRCDIR in ${ALLSOURCES}; do
			case "${SRCDIR}" in
			(clean|create|build|pack|all)
				;;
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


function test_netpoldo {
	for npdir in ${SOURCES}; do
		for npext in vmlinuz initrd initrdi initrdn squashfs; do
			if [ ! -e "${npdir}/output/netpoldo.${npext}" ]; then
				echo "ERROR: Some of the needed artefacts are missing." >&2
				exit 2
			fi
		done
	done
}

function netpoldo_clean {
	test_sources "$@"
	for npdir in ${SOURCES}; do
		uic clean -v ${SCRIPTPATH}/${npdir}
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
		uic pack -v -o ${SCRIPTPATH}/.. ${SCRIPTPATH}/${npdir}
	done
}


if ! which syslinux > /dev/null; then
	echo "ERROR: syslinux not installed" >&2
	exit 1
fi

case "$1" in
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
all)
	netpoldo_clean "$@"
	netpoldo_create "$@"
	netpoldo_build "$@"
	netpoldo_pack "$@"
	;;
*)
	echo "Usage: make.sh {clean|create|build|pack|all}"
        exit 1
        ;;
esac

exit 0
