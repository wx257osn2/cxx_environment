ARG GCC_VERSION=16.1.0
ARG BOOST_VERSION=1.91.0
ARG CMAKE_VERSION=4.3.3
ARG DIFFTASTIC_VERSION=0.69.0
ARG DEMUMBLE_VERSION=main
ARG MOLD_VERSION=2.41.0
ARG WILD_VERSION=0.9.0

ARG WIN_ARCH

FROM ubuntu:26.04 AS base

ENV PIPX_HOME=/opt/pipx \
    PIPX_BIN_DIR=/usr/local/bin \
    PIPX_MAN_DIR=/usr/local/share \
    CONAN_HOME=/opt/conan_home

FROM base AS builder

ARG GCC_VERSION
ARG BOOST_VERSION
ARG CMAKE_VERSION
ARG DIFFTASTIC_VERSION
ARG DEMUMBLE_VERSION
ARG MOLD_VERSION
ARG WILD_VERSION
ARG DEBIAN_FRONTEND=noninteractive

RUN --mount=type=cache,id=cxx_environment-apt-lists,target=/var/lib/apt/gc,sharing=locked \
    --mount=type=cache,id=cxx_environment-apt-cache,target=/var/cache/apt/gc,sharing=locked \
    --mount=type=bind,src=installer,target=/installer \
    /installer/ubuntu2604_prelude.bash

RUN --mount=type=bind,src=installer,target=/installer \
    /installer/ubuntu2604_gcc16.bash

RUN --mount=type=cache,id=cxx_environment-apt-lists,target=/var/lib/apt/gc,sharing=locked \
    --mount=type=cache,id=cxx_environment-apt-cache,target=/var/cache/apt/gc,sharing=locked \
    apt-get install -y --no-install-recommends make pkg-config ninja-build meson lcov gcovr git less

RUN --mount=type=cache,id=cxx_environment-apt-lists,target=/var/lib/apt/gc,sharing=locked \
    --mount=type=cache,id=cxx_environment-apt-cache,target=/var/cache/apt/gc,sharing=locked \
    --mount=type=bind,src=installer,target=/installer \
    /installer/ubuntu_clang.bash 22

RUN --mount=type=cache,id=cxx_environment-apt-lists,target=/var/lib/apt/gc,sharing=locked \
    --mount=type=cache,id=cxx_environment-apt-cache,target=/var/cache/apt/gc,sharing=locked \
    --mount=type=bind,src=installer,target=/installer \
    /installer/ubuntu_clang-format.bash 21

RUN --mount=type=cache,id=cxx_environment-apt-lists,target=/var/lib/apt/gc,sharing=locked \
    --mount=type=cache,id=cxx_environment-apt-cache,target=/var/cache/apt/gc,sharing=locked \
    --mount=type=bind,src=installer,target=/installer \
    /installer/ubuntu2404_msvc-wine_prerequisites.bash

RUN --mount=type=bind,src=installer,target=/installer \
    /installer/ubuntu2604_boost.bash ${BOOST_VERSION} gcc-${GCC_VERSION}

RUN --mount=type=bind,src=installer,target=/installer \
    /installer/cmake.bash ${CMAKE_VERSION}

RUN --mount=type=bind,src=installer,target=/installer \
    /installer/conan.bash

RUN --mount=type=bind,src=installer,target=/installer \
    /installer/cpplint.bash

RUN --mount=type=bind,src=installer,target=/installer \
    /installer/clangd-tidy.bash

RUN --mount=type=bind,src=installer,target=/installer \
    /installer/compiledb.bash

RUN --mount=type=bind,src=installer,target=/installer \
    /installer/difftastic.bash ${DIFFTASTIC_VERSION}

RUN --mount=type=bind,src=installer,target=/installer \
    /installer/demumble.bash ${DEMUMBLE_VERSION}

RUN --mount=type=bind,src=installer,target=/installer \
    /installer/mold.bash ${MOLD_VERSION}

RUN --mount=type=bind,src=installer,target=/installer \
    /installer/wild.bash ${WILD_VERSION}

RUN --mount=type=cache,id=cxx_environment-apt-lists,target=/var/lib/apt/gc,sharing=locked \
    --mount=type=cache,id=cxx_environment-apt-cache,target=/var/cache/apt/gc,sharing=locked \
    --mount=type=bind,src=installer,target=/installer \
    /installer/ubuntu2404_postlude.bash

FROM base AS final

COPY --from=builder /usr /usr
COPY --from=builder /opt /opt
COPY --from=builder /etc/alternatives /etc/alternatives
COPY --from=builder /etc/ssl /etc/ssl

ARG GCC_VERSION
ARG BOOST_VERSION
ARG CMAKE_VERSION
ARG DIFFTASTIC_VERSION
ARG DEMUMBLE_VERSION
ARG MOLD_VERSION
ARG WILD_VERSION
ARG WIN_ARCH

ENV PATH=${PATH}:/opt/cmake-${CMAKE_VERSION}/bin:/opt/gcc-${GCC_VERSION}/bin:/opt/difftastic-${DIFFTASTIC_VERSION}/bin:/opt/demumble-${DEMUMBLE_VERSION}/bin:/opt/mold-${MOLD_VERSION}/bin:/opt/wild-${WILD_VERSION}/bin:/opt/msvc/bin/${WIN_ARCH} \
    CPLUS_INCLUDE_PATH=${CPLUS_INCLUDE_PATH:+${CPLUS_INCLUDE_PATH}:}/opt/boost/${BOOST_VERSION}/gcc-${GCC_VERSION}/include \
    LIBRARY_PATH=${LIBRARY_PATH:+${LIBRARY_PATH}:}/opt/boost/${BOOST_VERSION}/gcc-${GCC_VERSION}/lib \
    LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}/opt/boost/${BOOST_VERSION}/gcc-${GCC_VERSION}/lib \
    FONTCONFIG_FILE=/opt/fontconf/dummy.conf \
    WINEDEBUG=-all \
    WINEPREFIX=/opt/wineprefix
