ARG BASE_IMAGE=alpine:3
FROM ${BASE_IMAGE}

ARG EXPIRES=2y
LABEL maintainer="Vakamo, Inc." quay.expires-after=${EXPIRES}

RUN apk update && apk upgrade && \
    apk add --no-cache \
    ca-certificates gcc build-base curl perl git bash cmake pkgconf python3 linux-headers && \
    rm -rf /var/cache/apk/*

WORKDIR /build
ENV SQLX_OFFLINE=true
ENV RUST_BACKTRACE=full
