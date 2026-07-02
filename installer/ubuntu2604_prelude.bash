#!/bin/bash

set -euo pipefail

printf 'Package: coreutils-from-uutils\nPin: release a=*\nPin-Priority: -10\n' > /etc/apt/preferences.d/coreutils

apt-get update
apt-get upgrade -y

apt-get remove -y coreutils-from-uutils --allow-remove-essential --purge

apt-get install -y --no-install-recommends curl ca-certificates lsb-release gnupg xz-utils pipx zstd
