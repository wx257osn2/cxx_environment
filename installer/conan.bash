#!/bin/bash

set -euo pipefail

pipx install conan
mkdir -p ${CONAN_HOME}
chmod -R a+w ${CONAN_HOME}
