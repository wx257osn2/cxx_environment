#!/bin/bash

BOOST_VERSION=${1}

set -euo pipefail

curl -L https://github.com/boostorg/boost/releases/download/boost-${BOOST_VERSION}/boost-${BOOST_VERSION}-b2-nodocs.tar.xz | tar xJ
cd boost-${BOOST_VERSION}
./bootstrap.sh
./b2 --without-python --without-mpi --without-graph_parallel --prefix=/opt/boost-${BOOST_VERSION} -j$(($(nproc) / 2 + 1)) link=static runtime-link=shared install
cd ..
rm -rf boost-${BOOST_VERSION}
