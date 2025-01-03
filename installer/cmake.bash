#!/bin/bash

CMAKE_VERSION=${1}
ARCH=$(uname -m)  # It assumes to be x86_64 or aarch64

set -euo pipefail

curl -sSLO https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-${ARCH}.sh
mkdir -p /opt/cmake-${CMAKE_VERSION}
bash cmake-${CMAKE_VERSION}-linux-${ARCH}.sh --prefix=/opt/cmake-${CMAKE_VERSION} --skip-license
rm cmake-${CMAKE_VERSION}-linux-${ARCH}.sh
