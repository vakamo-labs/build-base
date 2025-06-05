ARG BASE_IMAGE=ubuntu:24.04
FROM ${BASE_IMAGE}

ARG EXPIRES=2y
LABEL maintainer="Vakamo, Inc." quay.expires-after=${EXPIRES}

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y ca-certificates gcc build-essential curl perl git bash cmake pkg-config python3 linux-headers-generic clang libclang-dev

WORKDIR /build
ENV SQLX_OFFLINE=true
ENV RUST_BACKTRACE=full