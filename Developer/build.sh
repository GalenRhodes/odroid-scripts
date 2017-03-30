#!/bin/bash

git clone "https://github.com/nickhutchinson/libdispatch.git" "${HOME}/Projects/libdispatch"
git clone "https://github.com/gnustep/libobjc2.git"           "${HOME}/Projects/libobjc2"
git clone "https://github.com/gnustep/make"                   "${HOME}/Projects/core/make"
git clone "https://github.com/gnustep/base.git"               "${HOME}/Projects/core/base"
git clone "https://github.com/gnustep/gui.git"                "${HOME}/Projects/core/gui"
git clone "https://github.com/gnustep/back.git"               "${HOME}/Projects/core/back"

nano +670,1 "${HOME}/Projects/core/make/common.make"

_CC=/usr/bin/clang
_CXX=/usr/bin/clang++

#############################################################################################
# Build libobjc2
#
cd "${HOME}/Projects/libobjc2"
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release "-DCMAKE_C_COMPILER=${_CC}" "-DCMAKE_CXX_COMPILER=${_CXX}" .. || exit "$?"
make -j4 || exit "$?"
sudo -E make install || exit "$?"

#############################################################################################
# Build make the first time....
cd "${HOME}/Projects/core/make"
export CC="${_CC}"
export CXX="${_CXX}"
./configure --enable-objc-nonfragile-abi
make -j4
sudo -E make install

#############################################################################################
# Build libdispatch
#
cd "${HOME}/Projects/libdispatch"
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release "-DCMAKE_C_COMPILER=${_CC}" "-DCMAKE_CXX_COMPILER=${_CXX}" .. || exit "$?"
make -j4 || exit "$?"
sudo -E make install || exit "$?"
sudo ldconfig

#############################################################################################
# Build make the second time....
#
cd "${HOME}/Projects/core/make"
export CC="${_CC}"
export CXX="${_CXX}"
./configure --enable-debug-by-default --enable-objc-nonfragile-abi --with-layout=gnustep --enable-install-ld-so-conf || exit "$?"
make -j4 || exit "$?"
sudo -E make install || exit "$?"
ln -s "/usr/GNUstep/System/Library/Makefiles/GNUstep.sh" "${HOME}/.bash.d/base04gnustep.sh"
. "/usr/GNUstep/System/Library/Makefiles/GNUstep.sh"

#############################################################################################
# Build Foundation...
#
cd ../base
export CC="${_CC}"
export CXX="${_CXX}"
./configure --disable-mixedabi || exit "$?"
make -j4 || exit "$?"
sudo -E make install || exit "$?"

#############################################################################################
# Build AppKit...
#
cd ../gui
export CC="${_CC}"
export CXX="${_CXX}"
./configure || exit "$?"
make -j4 || exit "$?"
sudo -E make install || exit "$?"

#############################################################################################
# Build AppKit Backend...
#
cd ../back
export CC="${_CC}"
export CXX="${_CXX}"
./configure || exit "$?"
make -j4 || exit "$?"
sudo -E make install || exit "$?"

#############################################################################################
# Build Test...
#
cd "${HOME}/Projects/test"
"${_CC}" `gnustep-config --objc-flags` -fobjc-arc -fobjc-nonfragile-abi -fblocks -lobjc \
	-ldispatch -lgnustep-base -lgnustep-gui `gnustep-config --objc-libs` test.m -o test || exit "$?"

#############################################################################################
# Run the test...
./test

exit 0
