#!/bin/bash

set -euo pipefail

CMAKE_VERSION=${1}
ARCH=$(uname -m)  # It assumes to be x86_64 or aarch64

mkdir -p /opt/cmake-${CMAKE_VERSION}
curl -sSL https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-${ARCH}.tar.gz | tar -xzf - -C /opt/cmake-${CMAKE_VERSION} --strip-components=1
