#!/bin/bash -i

set +o history

here="$(realpath $(dirname ${BASH_SOURCE:-$0}))"

image_path="${here}/cxx-$(uname -m).sif"

if [ ! "${SINGULARITY:+true}" ]; then
  if [ `which singularity` ]; then
    export SINGULARITY=singularity
  elif [ `which apptainer` ]; then
    export SINGULARITY=apptainer
  fi
fi

generate_def() {
  cat ${here}/${1}.def.in > ${here}/.generated.def
  echo "PS1=\"\e[36m(cxx singularity)\e[0m ${PS1:-${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ }\"" >> ${here}/.generated.def
  echo 'EOF' >> ${here}/.generated.def
  echo '  chmod +x $CUSTOM_ENV' >> ${here}/.generated.def
}

unset XDG_RUNTIME_DIR

groups | grep docker > /dev/null && which proot > /dev/null
docker_user=$?

set -euo pipefail

if which docker > /dev/null && [[ $docker_user = 0 ]] || [[ $EUID = 0 ]] ; then
  # docker is available, so let use docker to cache build steps
  mkdir -p ${here}/docker_build
  cp -r ${here}/installer ${here}/docker_build
  docker buildx build -t cxx:latest -f ${here}/Dockerfile ${DOCKER_BUILD_EXTRA_OPTIONS:+${DOCKER_BUILD_EXTRA_OPTIONS}} ${here}/docker_build
  rm -r ${here}/docker_build/installer
  rmdir ${here}/docker_build
  generate_def with_docker
  ${SINGULARITY} build ${image_path} ${here}/.generated.def
else
  # docker is unavailable, so use singularity directly
  generate_def standalone
  echo '' >> ${here}/.generated.def
  echo '%setup' >> ${here}/.generated.def
  echo "  mkdir \$SINGULARITY_ROOTFS/installer" >> ${here}/.generated.def
  ${SINGULARITY} build --bind ${here}/installer:/installer --fakeroot ${image_path} ${here}/.generated.def
fi
