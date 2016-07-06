#!/bin/bash

__build=`clang -v 2>&1 | grep -E '^Target:' | awk '{print $2}'`

exec "${PWD}/configure"												\
	--prefix="$1"													\
	--build="${__build}" --host="${__build}" --target="${__build}"	\
	--enable-objc-nonfragile-abi									\
	--enable-native-objc-exceptions									\
	--disable-debug-by-default										\
	--with-layout=fhs

#	--enable-objc-arc												\


