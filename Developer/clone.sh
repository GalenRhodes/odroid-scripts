#!/bin/bash

DOKQUEUE="Y"
PRJDIR="${HOME}/Projects"

if [ "$1" = "-f" ]; then rsync -avz "grhodes@homer:Projects/odroid-scripts/Developer/clone.sh" "${PRJDIR}/"; exit "$?"; fi

CFLAGS_INTEL_X64=""
CFLAGS_INTEL_X32=""
CFLAGS_ARMV8_C2="-march=armv8-a -mtune=cortex-a53 -mcpu=cortex-a53"
CFLAGS_ARMV7_XU4="-march=armv7-a -mtune=cortex-a15 -mcpu=cortex-a15 -mfpu=vfpv4 -mfloat-abi=hard"
CFLAGS_ARMV7_RPI2="-march=armv7-a -mtune=cortex-a7 -mcpu=cortex-a7 -mfpu=vfpv4 -mfloat-abi=hard"

_target=$(clang -v 2>&1 | grep -E '^Target' | awk '{print $2}')
echo "TARGET: ${_target}"

_cbase="-integrated-as -Qunused-arguments ${CFLAGS_ARMV8_C2} -w"
export CFLAGS="${_cbase}"
export CXXFLAGS="${_cbase}"
export LDFLAGS=""
export LD="/usr/bin/ld.gold"
export CC="/usr/bin/clang"
export CXX="/usr/bin/clang++"

gnustephome="core"
# gnustephome="GNUstep"
gnustepsrc="GNUstep-source.tar.xz"

cd "${PRJDIR}" || exit "$?"
sudo rm -fr "${gnustephome}" "${gnustepsrc}" libkqueue* libdispatch* libobjc2* /usr/local/include/NiagraFalls/ /usr/local/lib/libNiagra*
( git clone git://github.com/GalenRhodes/libdispatch.git && git clone https://github.com/gnustep/libobjc2 ) || exit "$?"
if [ "${DOKQUEUE}" = "Y" ]; then
	git clone "https://github.com/GalenRhodes/libkqueue.git" libkqueue || exit "$?"
fi

mkdir -p "${PRJDIR}/${gnustephome}"
git clone https://github.com/gnustep/make "${PRJDIR}/${gnustephome}/make" || exit "$?"
git clone https://github.com/gnustep/base.git "${PRJDIR}/${gnustephome}/base" || exit "$?"
git clone https://github.com/gnustep/gui.git "${PRJDIR}/${gnustephome}/gui" || exit "$?"
git clone https://github.com/gnustep/back.git "${PRJDIR}/${gnustephome}/back" || exit "$?"

cat > common.cmake.txt <<-GREOF
	set(CMAKE_C_FLAGS						"${CFLAGS}"			CACHE STRING	"")
	set(CMAKE_CXX_FLAGS						"${CXXFLAGS}"		CACHE STRING	"")

	set(CMAKE_C_COMPILER					"${CC}"				CACHE FILEPATH	"")
	set(CMAKE_CXX_COMPILER					"${CXX}"			CACHE FILEPATH	"")

	set(CMAKE_BUILD_TYPE					"Release"			CACHE STRING	"")
	set(CMAKE_C_FLAGS_RELEASE				"-Ofast -g0"		CACHE STRING	"")
	set(CMAKE_CXX_FLAGS_RELEASE				"-Ofast -g0"		CACHE STRING	"")
	set(CMAKE_EXE_LINKER_FLAGS				""					CACHE STRING	"")
	set(CMAKE_EXE_LINKER_FLAGS_RELEASE		"-Wl,--strip-all"	CACHE STRING	"")
	set(CMAKE_MODULE_LINKER_FLAGS			""					CACHE STRING	"")
	set(CMAKE_MODULE_LINKER_FLAGS_RELEASE	"-Wl,--strip-all"	CACHE STRING	"")
	set(CMAKE_SHARED_LINKER_FLAGS			""					CACHE STRING	"")
	set(CMAKE_SHARED_LINKER_FLAGS_RELEASE	"-Wl,--strip-all"	CACHE STRING	"")
	set(CMAKE_STATIC_LINKER_FLAGS			""					CACHE STRING	"")
	set(CMAKE_STATIC_LINKER_FLAGS_RELEASE	""					CACHE STRING	"")
	set(CMAKE_INSTALL_PREFIX				"/usr"				CACHE PATH		"")
	set(CMAKE_LINKER						"${LD}"				CACHE FILEPATH	"")
	set(CMAKE_EXPORT_COMPILE_COMMANDS		ON					CACHE BOOL		"")
GREOF

cp common.cmake.txt libobjc2.cmake.txt
cp common.cmake.txt libdispatch.cmake.txt

if [ "${DOKQUEUE}" = "Y" ]; then
	cp common.cmake.txt libkqueue.cmake.txt
	cat >> libkqueue.cmake.txt <<-"GREOF"
		set(STATIC_KQUEUE ON CACHE BOOL "")
	GREOF
fi

cat >> libobjc2.cmake.txt <<-"GREOF"
	set(xx "libc6 (>=2.7), libgcc1 (>=1:4.4.0), libstdc++6 (>=5.2)")
	set(xy "https://github.com/gnustep/libobjc2")

	set(TESTS								OFF					CACHE BOOL		"")
	set(BUILD_STATIC_LIBOBJC				ON					CACHE BOOL		"")
	set(FORCE_LIBOBJCXX						OFF					CACHE BOOL		"")
	set(LIBOBJC_NAME                        "objc2"				CACHE STRING	"")
	set(GNUSTEP_INSTALL_TYPE				"NONE"				CACHE STRING	"")

	set(CPACK_PACKAGE_NAME					"libobjc2"			CACHE STRING	"")
	set(CPACK_PACKAGE_VERSION_MAJOR			"1"					CACHE STRING	"")
	set(CPACK_PACKAGE_VERSION_MINOR			"8"					CACHE STRING	"")
	set(CPACK_PACKAGE_VERSION_PATCH			"0"					CACHE STRING	"")
	set(CPACK_DEBIAN_PACKAGE_HOMEPAGE		"${xy}"				CACHE STRING	"")
	set(CPACK_STRIP_FILES					ON					CACHE BOOL		"Strip libraries when packaging")
	set(CPACK_DEBIAN_PACKAGE_DEPENDS		"${xx}"				CACHE STRING	"")
	set(CPACK_DEBIAN_PACKAGE_VERSION		"1.8.0"				CACHE STRING	"")
GREOF

cat >> libdispatch.cmake.txt <<-"GREOF"
	set(DISPATCH_ENABLE_TEST_SUITE			OFF					CACHE BOOL		"")
	set(DISPATCH_SANITIZE					OFF					CACHE BOOL		"")
	set(CPACK_STRIP_FILES					ON					CACHE BOOL		"Strip libraries when packaging")
GREOF

function BuildCMake() {
	local pdir
	local cfil
	local j="-j${PROCESSORS}"

	while [ $# -ge 2 ]; do
		pdir="$1"
		cfil="$2"
		shift 2

		( sudo ldconfig && cd "${pdir}" && sudo rm -fr build && mkdir build && cd build &&   \
			cmake "-G" "Unix Makefiles" "-C" "${cfil}" "${pdir}" && make "${j}" &&           \
			cpack -G DEB && sudo dpkg -i --force-all *.deb && cp *.deb "${PRJDIR}/" ) || return "$?"
	done

	return 0
}

function BuildGMake() {
	local y;
	local j="-j${PROCESSORS}"
	local d="${PRJDIR}/${gnustephome}"

	for y in $@; do
		( sudo ldconfig && cd "${d}/${y}" && ./configure "--build=${_target}" && make "${j}" && sudo -E make "${j}" install ) || return "$?"
	done

	return 0
}

export CFLAGS="${CFLAGS} -Ofast -g0"
export CXXFLAGS="${CXXFLAGS} -Ofast -g0"
export LDFLAGS="${LDFLAGS} -Wl,--strip-all"

function BuildGNUstepMake() {
	###########################################################################################
	# ./configure "--prefix=/usr/local" "--enable-objc-nonfragile-abi" "--enable-debug-by-default" "--with-layout=fhs" "--with-objc-lib-flag=-lobjc2"
	# ./configure "--prefix=/usr/local" "--enable-objc-nonfragile-abi" "--enable-debug-by-default" "--with-layout=gnustep"
	sudo ldconfig
	cd "$1/make"
	./configure "--build=${_target}" "--prefix=/usr" "--enable-objc-arc" "--enable-objc-nonfragile-abi" "--enable-native-objc-exceptions" \
		"--disable-debug-by-default" "--with-layout=fhs" "--with-objc-lib-flag=-lobjc2" || return "$?"
	( make && sudo -E make install ) || return "$?"
	#
	###########################################################################################
	#
	rm -f "${HOME}/.bash.d/bash04gnustep.sh"
	ln -s "$1" "${HOME}/.bash.d/bash04gnustep.sh"
	#
	###########################################################################################
	return 0
}

gnustep="/usr/share/GNUstep/Makefiles/GNUstep.sh"
BuildGNUstepMake "${PRJDIR}/${gnustephome}" "${gnustep}" || exit "$?"
source "${gnustep}"

if [ "${DOKQUEUE}" = "Y" ]; then BuildCMake "${PRJDIR}/libkqueue" "${PRJDIR}/libkqueue.cmake.txt" || exit "$?"; fi
BuildCMake "${PRJDIR}/libobjc2" "${PRJDIR}/libobjc2.cmake.txt" || exit "$?"
BuildCMake "${PRJDIR}/libdispatch" "${PRJDIR}/libdispatch.cmake.txt" || exit "$?"
export LDFLAGS="${LDFLAGS} -ldispatch"

BuildGNUstepMake "${PRJDIR}/${gnustephome}" "${gnustep}" || exit "$?"
source "${gnustep}"
BuildGMake "base" "gui" "back" || exit "$?"

TPROJ="galen"
UPROJ="${PRJDIR}/${TPROJ}"
rsync -avz "grhodes@homer:Projects/GalenRhodes/${TPROJ}/" "${UPROJ}/" || exit "?"
( sudo ldconfig && cd "${UPROJ}" && ./fetch_and_config.sh -e ) || exit "$?"

exit 0
