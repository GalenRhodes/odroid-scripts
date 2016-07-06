#!/bin/bash
cd objctest
# ======================================================================
# COMPILE USING THE FOLLOWING COMMAND LINES, OR CREATE A MAKEFILE
# ======================================================================

# Using COMMAND LINE

rm -fr blocktest guitest helloGCD *.d obj/ GUI*.app

. "${HOME}/bin/LoadBashScripts.sh"
. "/usr/share/GNUstep/Makefiles/GNUstep.sh"

if [ -z "${CFLAGS}" ]; then
	CFLAGS="-Ofast -g0 -w -integrated-as -Qunused-arguments -Wl,--strip-all"
fi

_cflags="`gnustep-config --objc-flags` `gnustep-config --objc-libs` ${CFLAGS} -fobjc-runtime=gnustep -fblocks -lobjc"
_bflags="-ldispatch -lgnustep-base"
_usearc="-fobjc-arc"

clang ${_cflags} ${_usearc} -o blocktest blocktest.m || exit "$?"
clang ${_cflags} ${_bflags} -o helloGCD Fraction.m helloGCD_objc.m || exit "$?"
clang ${_cflags} ${_usearc} ${_bflags} -lgnustep-gui -o guitest guitest.m || exit "$?"

# Using MAKEFILE

cat > GNUmakefile << "myEOF"
include $(GNUSTEP_MAKEFILES)/common.make

APP_NAME = GUITest
GUITest_OBJC_FILES = guitest.m

include $(GNUSTEP_MAKEFILES)/application.make
myEOF

make
exit "$?"
