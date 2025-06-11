ARG BASE_IMAGE=ubuntu:24.04
FROM ${BASE_IMAGE}

ARG EXPIRES=2y
LABEL maintainer="Vakamo, Inc." quay.expires-after=${EXPIRES}

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
    just ca-certificates fuse-overlayfs gcc g++ build-essential curl perl git bash cmake pkg-config python3 buildah podman \
    linux-headers-generic clang libclang-dev llvm && \
    # Clean up
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /build
