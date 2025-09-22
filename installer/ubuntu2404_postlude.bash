#!/bin/bash

set -euo pipefail

apt-get purge -y --auto-remove curl gnupg xz-utils zstd
apt-get clean
