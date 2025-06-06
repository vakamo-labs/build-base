ARG BASE_IMAGE=ubuntu:24.04
FROM ${BASE_IMAGE}

ARG EXPIRES=2y
LABEL maintainer="Vakamo, Inc." quay.expires-after=${EXPIRES}

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    ca-certificates gcc g++ build-essential curl perl git bash cmake pkg-config python3 \
    linux-headers-generic clang libclang-dev llvm musl-tools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /build
ENV SQLX_OFFLINE=true
ENV RUST_BACKTRACE=full