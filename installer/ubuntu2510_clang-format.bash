#!/bin/bash

set -euo pipefail

LLVM_VERSION=$1

apt-get install -y --no-install-recommends clang-format-${LLVM_VERSION}
