#!/bin/bash

set -euo pipefail

apt-get purge -y --auto-remove gnupg xz-utils zstd
apt-get clean
