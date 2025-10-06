#!/bin/bash

set -euo pipefail

apt-get purge -y --auto-remove gnupg lsb-release xz-utils zstd
apt-get clean
