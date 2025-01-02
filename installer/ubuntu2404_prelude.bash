#!/bin/bash

set -euo pipefail

apt-get update
apt-get upgrade -y

apt-get install -y --no-install-recommends curl ca-certificates gnupg xz-utils
