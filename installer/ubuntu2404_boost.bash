#!/bin/bash

set -euo pipefail

BOOST_VERSION=${1}
COMPILER=${2}

mkdir -p /opt
curl -sSL https://github.com/wx257osn2/build-archive/releases/download/boost-${BOOST_VERSION}-${COMPILER}/ubuntu2404-$(uname -m).tar.zst | tar -C /opt -Ipzstd -xf -
find /opt/boost -type d -exec chmod 755 {} +
chown root:root -R /opt/boost
