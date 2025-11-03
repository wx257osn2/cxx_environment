#!/bin/bash

set -euo pipefail

VERSION=${1}
ARCH=$(uname -m)  # It assumes to be x86_64 or aarch64

mkdir -p /opt/mold-${VERSION}
curl -sSL https://github.com/rui314/mold/releases/download/v${VERSION}/mold-${VERSION}-${ARCH}-linux.tar.gz | tar zx -C /opt/mold-${VERSION} --strip=1
