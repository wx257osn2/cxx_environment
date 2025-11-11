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
git fetch --depth 1 origin 32b504c63b869681cda6824a20e30b74cb718432
git reset --hard FETCH_HEAD
./vsdownload.py --major ${major} ${preview} --accept-license --only-host --dest ${dest}
rm -r ${dest}/VC/Tools/MSVC/*
./vsdownload.py --major ${major} --msvc-version ${version} ${preview} --accept-license --only-host --dest ${dest}
echo 'REDISTRIBUTABLE_PATH=$(echo ${BASE_UNIX}/VC/Redist/MSVC/${MSVCVER%.*}*)' >> wrappers/msvcenv.sh
echo 'export WINEPATH="${WINEPATH};z:${REDISTRIBUTABLE_PATH//\//\\}\\debug_nonredist\\x64\\Microsoft.VC143.DebugCRT;${SDKBINDIR//\//\\}\\ucrt"' >> wrappers/msvcenv.sh
if [ ${major} -eq 18 ]; then
  sed "s/170/${major}0/g" -i wrappers/msbuild
  sed "s/143/145/g" -i wrappers/msvcenv.sh
fi
./install.sh ${dest}

wine_version=$(wine --version | sed -e 's/wine-\([0-9.]*\) (.*)/\1/')
curl -sSL -o wine-mono.msi https://dl.winehq.org/wine/wine-mono/${wine_version}.0/wine-mono-${wine_version}.0-x86.msi
wine msiexec /i wine-mono.msi
