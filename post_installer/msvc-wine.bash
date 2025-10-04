#!/bin/bash

set -euo pipefail

version=${1}
major=${version%.*}

second=${2:-""}
if [[ ${second} == "--preview" ]]; then
  preview="--preview"
  shift
  second=${2:-""}
else
  preview=""
fi

dest=${second:-/opt/msvc}

mkdir -p _msvc-wine
pushd _msvc-wine
trap 'popd; rm -rf _msvc-wine' EXIT
git init
git remote add origin https://github.com/mstorsjo/msvc-wine
git fetch --depth 1 origin 91759aa0131a166f17602f81012737a6f353d608
git reset --hard FETCH_HEAD
./vsdownload.py --major ${major} ${preview} --accept-license --only-host --dest ${dest}
rm -r ${dest}/VC/Tools/MSVC/*
./vsdownload.py --major ${major} --msvc-version ${version} ${preview} --accept-license --only-host --dest ${dest}
if [ ${major} -ne 17 ]; then
  sed "s/170/${major}0/g" -i wrappers/msbuild
fi
./install.sh ${dest}

wine_version=$(wine --version | sed -e 's/wine-\([0-9.]*\) (.*)/\1/')
curl -sSL -o wine-mono.msi https://dl.winehq.org/wine/wine-mono/${wine_version}.0/wine-mono-${wine_version}.0-x86.msi
wine msiexec /i wine-mono.msi
