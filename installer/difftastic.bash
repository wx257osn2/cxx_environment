#!/bin/bash

DIFFTASTIC_VERSION=${1}
ARCH=$(uname -m)  # It assumes to be x86_64 or aarch64

set -euo pipefail

curl -sSL https://github.com/Wilfred/difftastic/releases/download/${DIFFTASTIC_VERSION}/difft-${ARCH}-unknown-linux-gnu.tar.gz | tar xz
mkdir -p /opt/difftastic-${DIFFTASTIC_VERSION}/bin
mv difft /opt/difftastic-${DIFFTASTIC_VERSION}/bin
