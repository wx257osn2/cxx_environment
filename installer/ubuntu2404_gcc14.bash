#!/bin/bash

set -euo pipefail

GCC_VERSION=14

apt-get install -y --no-install-recommends g++-${GCC_VERSION}
update-alternatives --install /usr/local/bin/gcc        gcc        /usr/bin/gcc-${GCC_VERSION} ${GCC_VERSION} \
                    --slave   /usr/local/bin/g++        g++        /usr/bin/g++-${GCC_VERSION} \
                    --slave   /usr/local/bin/cpp        cpp        /usr/bin/cpp-${GCC_VERSION} \
                    --slave   /usr/local/bin/gcc-ar     gcc-ar     /usr/bin/gcc-ar-${GCC_VERSION} \
                    --slave   /usr/local/bin/gcc-nm     gcc-nm     /usr/bin/gcc-nm-${GCC_VERSION} \
                    --slave   /usr/local/bin/gcc-ranlib gcc-ranlib /usr/bin/gcc-ranlib-${GCC_VERSION} \
                    --slave   /usr/local/bin/gcov       gcov       /usr/bin/gcov-${GCC_VERSION} \
                    --slave   /usr/local/bin/gcov-dump  gcov-dump  /usr/bin/gcov-dump-${GCC_VERSION} \
                    --slave   /usr/local/bin/gcov-tool  gcov-tool  /usr/bin/gcov-tool-${GCC_VERSION} \
                    --slave   /usr/local/bin/lto-dump   lto-dump   /usr/bin/lto-dump-${GCC_VERSION}

# Fix libstdc++ of g++-14.1 for clang++-19
# this will be able to be removed with g++-14.2
# see. https://github.com/llvm/llvm-project/issues/92586, https://gcc.gnu.org/bugzilla/show_bug.cgi?id=115119
sed -i /usr/include/c++/14/bits/unicode.h -e 's/++this/++*this/g'
