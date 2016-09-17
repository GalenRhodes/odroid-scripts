#!/bin/bash

if [ "$1" = "-f" ]; then
	rsync -avz "grhodes@homer:Projects/odroid-scripts/Developer/download-clang-src.sh" "${HOME}/Projects/"
	exit 0
fi

echo "Downloading clang/llvm source code..."

svn co http://llvm.org/svn/llvm-project/llvm/branches/release_39              llvm
svn co http://llvm.org/svn/llvm-project/cfe/branches/release_39               llvm/tools/clang
svn co http://llvm.org/svn/llvm-project/compiler-rt/branches/release_39       llvm/projects/compiler-rt
svn co http://llvm.org/svn/llvm-project/clang-tools-extra/branches/release_39 llvm/tools/clang/tools/extra/clang-tools-extra

svn upgrade llvm
svn upgrade llvm/tools/clang
svn upgrade llvm/tools/clang/tools/extra/clang-tools-extra
svn upgrade llvm/projects/compiler-rt

exit "$?"
