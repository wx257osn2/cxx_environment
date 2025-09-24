#!/bin/bash

here="$(realpath $(dirname ${BASH_SOURCE:-$0}))"

if [ ! "${SINGULARITY:+true}" ]; then
  if [ `which singularity` ]; then
    SINGULARITY=singularity
  elif [ `which apptainer` ]; then
    SINGULARITY=apptainer
  fi
fi

set -euo pipefail

if [ ! -f "${here}/overlay.img" ]; then
  ${SINGULARITY} overlay create \
    --size 16384 \
    --create-dir /opt/conan_home \
    --create-dir /opt/msvc \
    --create-dir /opt/wineprefix \
    "${here}/overlay.img"
fi
