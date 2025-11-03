#!/bin/bash

set -euo pipefail

CLANG_VERSION=${1}

mkdir -p /opt
curl -sSL https://github.com/wx257osn2/build-archive/releases/download/clang-head-${CLANG_VERSION}/ubuntu2404-$(uname -m).tar.zst | tar -C /opt -Ipzstd -xf -
find /opt/clang-${CLANG_VERSION} -type d -exec chmod 755 {} +
