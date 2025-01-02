ARG BOOST_VERSION=1.87.0

FROM ubuntu:24.04 AS builder

ARG BOOST_VERSION

RUN --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=bind,src=installer,target=/installer \
    /installer/ubuntu2404_prelude.bash

RUN --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=bind,src=installer,target=/installer \
    /installer/ubuntu2404_gcc14.bash

RUN --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get install -y --no-install-recommends make

RUN --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=bind,src=installer,target=/installer \
    /installer/ubuntu2404_clang19.bash

RUN --mount=type=bind,src=installer,target=/installer \
    /installer/boost.bash ${BOOST_VERSION}

FROM ubuntu:24.04 AS final

COPY --from=builder /usr /usr
COPY --from=builder /opt /opt
COPY --from=builder /etc/alternatives /etc/alternatives

ARG BOOST_VERSION

ENV CPLUS_INCLUDE_PATH=${CPLUS_INCLUDE_PATH:+${CPLUS_INCLUDE_PATH}:}/opt/boost-${BOOST_VERSION}/include \
    LIBRARY_PATH=${LIBRARY_PATH:+${LIBRARY_PATH}:}/opt/boost-${BOOST_VERSION}/lib \
    LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}/opt/boost-${BOOST_VERSION}/lib
