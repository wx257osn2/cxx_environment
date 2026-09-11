#!/bin/bash

set -euo pipefail

UBUNTU_VERSION=${1}
BOOST_VERSION=${2}
COMPILER=${3}

mkdir -p /opt
curl -sSL https://github.com/wx257osn2/build-archive/releases/download/boost-${BOOST_VERSION}-${COMPILER}/ubuntu${UBUNTU_VERSION}-$(uname -m).tar.zst | tar -C /opt -Ipzstd -xf -
find /opt/boost -type d -exec chmod 755 {} +
chown root:root -R /opt/boost
