ARG GCC_VERSION=15.1.0
ARG BOOST_VERSION=1.88.0
ARG CMAKE_VERSION=4.0.1

FROM ubuntu:24.04 AS base

ENV PIPX_HOME=/opt/pipx \
    PIPX_BIN_DIR=/usr/local/bin \
    PIPX_MAN_DIR=/usr/local/share \
    CONAN_HOME=/opt/conan_home

FROM base AS builder

ARG GCC_VERSION
ARG BOOST_VERSION
ARG CMAKE_VERSION
ARG DEBIAN_FRONTEND=noninteractive

RUN --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=bind,src=installer,target=/installer \
    /installer/ubuntu2404_prelude.bash

RUN --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=bind,src=installer,target=/installer \
    /installer/ubuntu2404_gcc15.bash ${GCC_VERSION}

RUN --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get install -y --no-install-recommends make pkg-config ninja-build meson lcov gcovr git

RUN --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=bind,src=installer,target=/installer \
    /installer/ubuntu2404_clang20.bash

RUN --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=bind,src=installer,target=/installer \
    /installer/ubuntu2404_clang-format17.bash

RUN --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=bind,src=installer,target=/installer \
    /installer/ubuntu2404_clang-format18.bash

RUN --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=bind,src=installer,target=/installer \
    /installer/ubuntu2404_clang-format19.bash

RUN --mount=type=bind,src=installer,target=/installer \
    /installer/ubuntu2404_boost.bash ${BOOST_VERSION} gcc-${GCC_VERSION}

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

RUN --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
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

ENV PATH=${PATH}:/opt/cmake-${CMAKE_VERSION}/bin:/opt/gcc-${GCC_VERSION}/bin \
    CPLUS_INCLUDE_PATH=${CPLUS_INCLUDE_PATH:+${CPLUS_INCLUDE_PATH}:}/opt/boost/${BOOST_VERSION}/gcc-${GCC_VERSION}/include \
    LIBRARY_PATH=${LIBRARY_PATH:+${LIBRARY_PATH}:}/opt/boost/${BOOST_VERSION}/gcc-${GCC_VERSION}/lib \
    LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}/opt/boost/${BOOST_VERSION}/gcc-${GCC_VERSION}/lib
