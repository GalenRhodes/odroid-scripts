#!/bin/bash

if [ "$1" = "-f" ]; then
	rsync -avz "grhodes@homer:Projects/odroid-scripts/Developer/removegnustep.sh" "${HOME}/Projects/"
	exit "$?"
fi

rm -f "${HOME}/.bash.d/"bash*gnustep.sh

sudo dpkg -r libdispatch
sudo dpkg -r libobjc2

sudo rm -fr "${HOME}/Projects/core/" "${HOME}/Projects/GNUstep/" "${HOME}/Projects/"libdispatch* "${HOME}/Projects/"libobjc2* \
	${HOME}/Projects/*.cmake.txt \
	${HOME}/Projects/GNUstep-source*.tar.xz \
	/usr/local/lib/libNiagraFalls* \
	/usr/local/include/NiagraFalls \
	/etc/GNUstep \
	/usr/share/GNUstep \
	/usr/include/Cocoa \
	/usr/include/Foundation \
	/usr/include/AppKit \
	/usr/include/GNUstepBase \
	/usr/include/GNUstepGUI \
	/usr/include/gnustep \
	/usr/bin/autogsdoc \
	/usr/bin/cvtenc \
	/usr/bin/debugapp \
	/usr/bin/defaults \
	/usr/bin/gclose \
	/usr/bin/gcloseall \
	/usr/bin/gdnc \
	/usr/bin/gdomap \
	/usr/bin/gnustep-config \
	/usr/bin/gnustep-tests \
	/usr/bin/gopen \
	/usr/bin/gpbs \
	/usr/bin/gspath \
	/usr/bin/HTMLLinker \
	/usr/bin/make_services \
	/usr/bin/make_strings \
	/usr/bin/openapp \
	/usr/bin/opentool \
	/usr/bin/pl \
	/usr/bin/pl2link \
	/usr/bin/pldes \
	/usr/bin/plget \
	/usr/bin/plmerge \
	/usr/bin/plparse \
	/usr/bin/plser \
	/usr/bin/set_show_service \
	/usr/bin/sfparse \
	/usr/bin/xmlparse \
	/usr/lib/GNUstep \
	/usr/lib/libgnustep-* \
	/usr/share/man/man1/autogsdoc.1.gz \
	/usr/share/man/man1/cvtenc.1.gz \
	/usr/share/man/man1/debugapp.1.gz \
	/usr/share/man/man1/defaults.1.gz \
	/usr/share/man/man1/gdnc.1.gz \
	/usr/share/man/man1/gnustep-config.1.gz \
	/usr/share/man/man1/gnustep-tests.1.gz \
	/usr/share/man/man1/gpbs.1.gz \
	/usr/share/man/man1/gspath.1.gz \
	/usr/share/man/man1/HTMLLinker.1.gz \
	/usr/share/man/man1/make_strings.1.gz \
	/usr/share/man/man1/openapp.1.gz \
	/usr/share/man/man1/opentool.1.gz \
	/usr/share/man/man1/pldes.1.gz \
	/usr/share/man/man1/sfparse.1.gz \
	/usr/share/man/man1/xmlparse.1.gz \
	/usr/share/man/man7/GNUstep.7.gz \
	/usr/share/man/man7/library-combo.7.gz \
	/usr/share/man/man8/gdomap.8.gz

exit 0
