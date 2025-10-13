#!/bin/bash

set -euo pipefail

GCC_VERSION=${1}

apt-get install -y --no-install-recommends g++-${GCC_VERSION}
update-alternatives --install /usr/local/bin/gcc        gcc        /usr/bin/gcc-${GCC_VERSION} ${GCC_VERSION} \
                    --slave   /usr/local/bin/g++        g++        /usr/bin/g++-${GCC_VERSION} \
                    --slave   /usr/local/bin/gcc-ar     gcc-ar     /usr/bin/gcc-ar-${GCC_VERSION} \
                    --slave   /usr/local/bin/gcc-nm     gcc-nm     /usr/bin/gcc-nm-${GCC_VERSION} \
                    --slave   /usr/local/bin/gcc-ranlib gcc-ranlib /usr/bin/gcc-ranlib-${GCC_VERSION} \
                    --slave   /usr/local/bin/gcov       gcov       /usr/bin/gcov-${GCC_VERSION} \
                    --slave   /usr/local/bin/gcov-dump  gcov-dump  /usr/bin/gcov-dump-${GCC_VERSION} \
                    --slave   /usr/local/bin/gcov-tool  gcov-tool  /usr/bin/gcov-tool-${GCC_VERSION} \
                    --slave   /usr/local/bin/lto-dump   lto-dump   /usr/bin/lto-dump-${GCC_VERSION}

update-alternatives --install /usr/local/bin/cc         cc         /usr/bin/gcc-${GCC_VERSION} ${GCC_VERSION}
update-alternatives --install /usr/local/bin/c++        c++        /usr/bin/g++-${GCC_VERSION} ${GCC_VERSION}
