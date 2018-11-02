#!/bin/bash

if [ "$1" = "-f" ]; then
	rsync -avz "grhodes@homer:Projects/odroid-scripts/Developer/download-clang-src.sh" "${HOME}/Projects/"
	exit 0
fi

echo "Downloading clang/llvm source code..."

svn co http://llvm.org/svn/llvm-project/llvm/trunk              llvm                                           || exit "$?"
svn co http://llvm.org/svn/llvm-project/cfe/trunk               llvm/tools/clang                               || exit "$?"
svn co http://llvm.org/svn/llvm-project/compiler-rt/trunk       llvm/projects/compiler-rt                      || exit "$?"
svn co http://llvm.org/svn/llvm-project/clang-tools-extra/trunk llvm/tools/clang/tools/extra/clang-tools-extra || exit "$?"

svn upgrade llvm                                           || exit "$?"
svn upgrade llvm/tools/clang                               || exit "$?"
svn upgrade llvm/projects/compiler-rt                      || exit "$?"
svn upgrade llvm/tools/clang/tools/extra/clang-tools-extra || exit "$?"

exit "$?"
