#!/bin/bash

set -euo pipefail

VERSION=${1}
ARCH=$(uname -m)  # It assumes to be x86_64 or aarch64

curl -sSL https://github.com/cabinpkg/cabin/releases/download/${VERSION}/cabin-${VERSION}-${ARCH}-unknown-linux-gnu.tar.xz | tar xJ
mkdir -p /opt/cabin-${VERSION}/bin
mv cabin-${VERSION}-${ARCH}-unknown-linux-gnu/cabin /opt/cabin-${VERSION}/bin
rm -r cabin-${VERSION}-${ARCH}-unknown-linux-gnu
