#!/bin/bash

set -euo pipefail

GCC_VERSION=15.1.0
GCC_MAJOR_VERSION=15

mkdir -p /opt
curl -sSL https://github.com/wx257osn2/build-archive/releases/download/gcc-${GCC_VERSION}/ubuntu2404-$(uname -m).tar.zst | tar -C /opt -Ipzstd -xf -
update-alternatives --install /usr/local/bin/gcc        gcc        /opt/gcc-${GCC_VERSION}/bin/gcc-${GCC_MAJOR_VERSION} ${GCC_MAJOR_VERSION} \
                    --slave   /usr/local/bin/g++        g++        /opt/gcc-${GCC_VERSION}/bin/g++-${GCC_MAJOR_VERSION} \
                    --slave   /usr/local/bin/gcc-ar     gcc-ar     /opt/gcc-${GCC_VERSION}/bin/gcc-ar-${GCC_MAJOR_VERSION} \
                    --slave   /usr/local/bin/gcc-nm     gcc-nm     /opt/gcc-${GCC_VERSION}/bin/gcc-nm-${GCC_MAJOR_VERSION} \
                    --slave   /usr/local/bin/gcc-ranlib gcc-ranlib /opt/gcc-${GCC_VERSION}/bin/gcc-ranlib-${GCC_MAJOR_VERSION} \
                    --slave   /usr/local/bin/gcov       gcov       /opt/gcc-${GCC_VERSION}/bin/gcov-${GCC_MAJOR_VERSION} \
                    --slave   /usr/local/bin/gcov-dump  gcov-dump  /opt/gcc-${GCC_VERSION}/bin/gcov-dump-${GCC_MAJOR_VERSION} \
                    --slave   /usr/local/bin/gcov-tool  gcov-tool  /opt/gcc-${GCC_VERSION}/bin/gcov-tool-${GCC_MAJOR_VERSION} \
                    --slave   /usr/local/bin/lto-dump   lto-dump   /opt/gcc-${GCC_VERSION}/bin/lto-dump-${GCC_MAJOR_VERSION}

update-alternatives --install /usr/local/bin/cc         cc         /opt/gcc-${GCC_VERSION}/bin/gcc-${GCC_MAJOR_VERSION} ${GCC_MAJOR_VERSION}
update-alternatives --install /usr/local/bin/c++        c++        /opt/gcc-${GCC_VERSION}/bin/g++-${GCC_MAJOR_VERSION} ${GCC_MAJOR_VERSION}
