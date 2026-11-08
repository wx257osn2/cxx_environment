#!/bin/bash

set -euo pipefail

DIFFTASTIC_VERSION=${1}
ARCH=$(uname -m)  # It assumes to be x86_64 or aarch64


if [ "$(printf '%s\n%s\n' ${DIFFTASTIC_VERSION} "0.71.0" | sort -V | head -n1)" = "0.71.0" ]; then
  DIFFT_TARGZ_NAME=difft-${DIFFTASTIC_VERSION}-${ARCH}-unknown-linux-gnu.tar.gz
else
  DIFFT_TARGZ_NAME=difft-${ARCH}-unknown-linux-gnu.tar.gz
fi

curl -sSL https://github.com/Wilfred/difftastic/releases/download/${DIFFTASTIC_VERSION}/${DIFFT_TARGZ_NAME} | tar xz
mkdir -p /opt/difftastic-${DIFFTASTIC_VERSION}/bin
mv difft /opt/difftastic-${DIFFTASTIC_VERSION}/bin
