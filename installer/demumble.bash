#!/bin/bash

set -euo pipefail

VERSION=${1:-main}

mkdir -p _demumble
pushd _demumble
trap 'popd; rm -rf _demumble' EXIT
git init
git remote add origin https://github.com/wx257osn2/nico-demumble
git fetch --depth 1 origin ${VERSION}
git reset --hard FETCH_HEAD
/opt/cmake-*/bin/cmake -DCMAKE_INSTALL_PREFIX=/opt/demumble-${VERSION} -DCMAKE_BUILD_TYPE=Release -GNinja .
ninja
/opt/cmake-*/bin/cmake --install .
