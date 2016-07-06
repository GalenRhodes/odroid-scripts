#!/bin/bash

__build=`clang -v 2>&1 | grep -E '^Target:' | awk '{print $2}'`
__pwd="${PWD}"
__gnu=`dirname "${__pwd}"`
__dirs="base gui back"
__bashd="${HOME}/.bash.d"
__prefix1="$1"

if [ -z "${__prefix1}" ]; then __prefix1="/usr"; fi
while [ -z "${__prefix}" ]; do
	__prefix=`whiptail --inputbox "Install Location for GNUstep" 0 40 "${__prefix1}" 3>&1 1>&2 2>&3`
	if [ $? -ne 0 ]; then
		echo "Operation Canceled."
		exit 0
	fi
done

"${__pwd}/configure"												\
	--prefix="${__prefix}"											\
	--build="${__build}" --host="${__build}" --target="${__build}"	\
	--enable-objc-nonfragile-abi									\
	--enable-native-objc-exceptions									\
	--disable-debug-by-default										\
	--with-layout=fhs && make -j$PROCESSORS && sudo -E make -j$PROCESSORS install
#	--enable-objc-arc
__rt="$?"

if [ "${__rt}" -ne 0 ]; then
	exit "${__rt}"
fi

__scr="${__prefix}/share/GNUstep/Makefiles/GNUstep.sh"

source "${__scr}"

if [ -d "${__bashd}" ]; then
	ln -s "${__scr}" "${__bashd}/bash04gnustep.sh"
else
	echo "source \"${__scr}\"" >> "${HOME}/.bashrc"
fi

sudo ldconfig

for __cdir in ${__dirs}; do
	__qdir="${__gnu}/${__cdir}"
	cd "${__qdir}"
	
	"${__qdir}/configure" --build="${__build}" && make -j$PROCESSORS && sudo -E make -j$PROCESSORS install
	__rt="$?"
	
	sudo ldconfig
	
	if [ "${__rt}" -ne 0 ]; then
		exit "${__rt}"
	fi
done

exit 0
