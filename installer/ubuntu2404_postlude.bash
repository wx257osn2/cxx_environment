#!/bin/bash

set -euo pipefail

apt-get purge -y --auto-remove curl gnupg xz-utils
apt-get clean
rm -rf /var/lib/apt/lists/* /var/cache/apt/*
