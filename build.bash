#!/bin/bash -i


here="$(realpath $(dirname ${BASH_SOURCE:-$0}))"

generate_def() {
  cat ${here}/${1}.in > ${here}/${1}
  echo "PS1=\"Singularity ${PS1}\"" >> ${here}/${1}
  echo 'EOF' >> ${here}/${1}
  echo '  chmod +x $CUSTOM_ENV' >> ${here}/${1}
}

unset XDG_RUNTIME_DIR

groups | grep docker > /dev/null && which proot > /dev/null
docker_user=$?

set -euo pipefail

if which docker > /dev/null && [[ $docker_user = 0 ]] || [[ $EUID = 0 ]] ; then
  # docker is available, so let use docker to cache build steps
  mkdir -p ${here}/empty
  DOCKER_BUILDKIT=1 docker build -t cxx:latest -f ${here}/Dockerfile ${here}/empty
  rmdir ${here}/empty
  generate_def with_docker.def
  singularity build ${here}/cxx.sif ${here}/with_docker.def
else
  # docker is unavailable, so use singularity directly
  generate_def standalone.def
  singularity build --fakeroot ${here}/cxx.sif ${here}/standalone.def
fi
