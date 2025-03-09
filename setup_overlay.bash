#!/bin/bash

here="$(realpath $(dirname ${BASH_SOURCE:-$0}))"

if [ ! "${SINGULARITY:+true}" ]; then
  if [ `which singularity` ]; then
    SINGULARITY=singularity
  elif [ `which apptainer` ]; then
    SINGULARITY=apptainer
  fi
fi

if [ ! -f "${here}/overlay.img" ]; then
  ${SINGULARITY} overlay create \
    --size 2048 \
    --create-dir /opt/conan_home \
    "${here}/overlay.img"
  ${SINGULARITY} exec --overlay "${here}/overlay.img" \
    "${here}/cxx-$(uname -m).sif" \
    chmod -R a+w /opt/conan_home
fi
