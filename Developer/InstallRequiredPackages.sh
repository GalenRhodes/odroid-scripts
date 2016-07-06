#!/bin/bash

for _f in ../Linux-generic/bash.d/bash[0-9][0-9]*.sh; do
	if [ ! -d "${_f}" ]; then
		source "${_f}"
	fi
done

_sname=`readlink -f "$0"`
__sdir=`dirname "${_sname}"`
__list=`cat "${__sdir}/install_list.txt"`

if [ "$1" = "4" -o "$1" = "8" ]; then
	__wordsize="$1"
	shift
else
	__texe=`mktemp`
	/usr/bin/cc "${__sdir}/wordsizetest.c" -o "${__texe}"
	__wordsize=`"${__texe}"`
	rm "${__texe}"
fi

__bitcount=$((${__wordsize} * 8))
whiptail --title "CPU Word Size" --msgbox "It appears you are running a ${__bitcount}-bit CPU." 0 40
__ignr=`cat "${__sdir}/install_ignore_list_aarch${__bitcount}.txt"`

function isNotInList() {
	local _a="$1"
	local _b=""

	shift
	for _b in "$@"; do
		if [ "${_a}" = "${_b}" ]; then
			return 1
		fi
	done

	return 0
}

__cmd=""

for _f in ${__list}; do
	if isNotInList "${_f}" ${__ignr}; then
		__cmd="${__cmd} \"${_f}\""
	fi
done

__msg="Are you sure you want to continue installing the following software packages?\n\n${__cmd}"
__ttl="Confirm Installing Required Software Packages"

if (whiptail --title "${__ttl}" --yesno "${__msg}" 0 78) then
	zecho "Installing" "Required software packages..."	
	eval "sudo apt-get -y update" || zfail $? "Updating software package lists from repositories!"
	eval "sudo apt-get -y install ${__cmd}" || zfail $? "Installing software packages!"
else
	zecho "Installation" "Aborted!"
fi

exit $?
