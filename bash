#!/bin/bash

here="$(realpath $(dirname ${BASH_SOURCE:-$0}))"

singularity shell --cwd "${PWD}" \
  --bind "${PWD}":"${PWD}" \
  "${here}/cxx.sif"
