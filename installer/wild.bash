#!/bin/bash

set -euo pipefail

WILD_VERSION=${1}
ARCH=$(uname -m)  # It assumes to be x86_64 or aarch64

curl -sSL https://github.com/wild-linker/wild/releases/download/${WILD_VERSION}/wild-linker-${WILD_VERSION}-${ARCH}-unknown-linux-gnu.tar.gz | tar xz
mkdir -p /opt/wild-${WILD_VERSION}/bin
mv wild-linker-${WILD_VERSION}-${ARCH}-unknown-linux-gnu/wild /opt/wild-${WILD_VERSION}/bin
rm -r wild-linker-${WILD_VERSION}-${ARCH}-unknown-linux-gnu
