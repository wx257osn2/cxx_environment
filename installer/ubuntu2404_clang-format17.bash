#!/bin/bash

set -euo pipefail

LLVM_VERSION=17
UBUNTU_CODENAME=noble

if [ ! -f /usr/local/share/keyrings/llvm-snapshot-archive-keyring.gpg ]; then
  mkdir -p /usr/local/share/keyrings
  curl --tlsv1.2 -sSf https://apt.llvm.org/llvm-snapshot.gpg.key | gpg --dearmor -o /usr/local/share/keyrings/llvm-snapshot-archive-keyring.gpg
fi
echo "deb [signed-by=/usr/local/share/keyrings/llvm-snapshot-archive-keyring.gpg] http://apt.llvm.org/${UBUNTU_CODENAME}/ llvm-toolchain-${UBUNTU_CODENAME}-${LLVM_VERSION} main" \
  >> /etc/apt/sources.list.d/llvm.list
echo "deb-src [signed-by=/usr/local/share/keyrings/llvm-snapshot-archive-keyring.gpg] http://apt.llvm.org/${UBUNTU_CODENAME}/ llvm-toolchain-${UBUNTU_CODENAME}-${LLVM_VERSION} main" \
  >> /etc/apt/sources.list.d/llvm.list
apt-get update

apt-get install -y --no-install-recommends clang-format-${LLVM_VERSION}
