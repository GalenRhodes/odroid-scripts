#!/bin/bash

_sname=`readlink -f "$0"`
__sdir=`dirname "${_sname}"`
__texe=`mktemp`

/usr/bin/cc "${__sdir}/wordsizetest.c" -o "${__texe}"
__wordsize=`"${__texe}"`
rm "${__texe}"
__bitcount=$((${__wordsize} * 8))

"${__sdir}/InstallRequiredPackages.sh" "${__wordsize}" || \
	( __rt="$?"; whiptail --title "ERROR" --msgbox "Installation of required software packages failed." 0 40; exit "${__rt}" )

"${__sdir}/dlpacks${__bitcount}.sh" || \
	( __rt="$?"; whiptail --title "ERROR" --msgbox "Installation of required software packages failed." 0 40; exit "${__rt}" )

#################################################################################	
# We need to reload the environment because our choice of compilers has changed.
#
for _f in ../Linux-generic/bash.d/bash[0-9][0-9]*.sh; do
	if [ ! -d "${_f}" ]; then
		source "${_f}"
	fi
done
#
#################################################################################	

( untarit "${__sdir}/GNUstep-source-39750.tar.xz" && cd "GNUstep/make" && "${__sdir}/gnustep-config.sh" "/usr" ) || \
	( __rt="$?"; whiptail --title "ERROR" --msgbox "Build and installation of GNUstep failed." 0 40; exit "${__rt}" )

if whiptail --yesno "Build and run test cases?" 0 0; then
	cd "${__sdir}/objc2.tests" || \
		( __rt="$?"; whiptail --title "ERROR" --msgbox "Building of GNUstep test cases failed." 0 40; exit "${__rt}" )

	"${__sdir}/objc2.tests/objctest/blocktest"
	"${__sdir}/objc2.tests/objctest/helloGCD"
	"${__sdir}/objc2.tests/objctest/guitest"
	"openapp" "${__sdir}/objc2.tests/objctest/GUITest.app"
fi

exit 0
