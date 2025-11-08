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

arch=$(uname -m)
uri=${2:-"oras://ghcr.io/wx257osn2/cxx_environment:{}"}

if [[ ${uri} == oras://* ]]; then
  ${SINGULARITY} pull $(echo ${uri} | sed "s/{}/${1}/g")-${arch}
  filename=$(echo ${uri##*/} | sed "s/:{}/_${1}-${arch}/g").sif
  if [ ${filename} != "cxx-${arch}.sif" ]; then
    mv ${filename} ${here}/cxx-${arch}.sif
  fi
else
  curl -sSL -o ${here}/cxx-${arch}.sif $(echo ${uri} | sed "s/{}/${1}/g")/${3:-cxx}-${arch}.sif
fi
