ARG BASE_IMAGE=rust:1-alpine
FROM ${BASE_IMAGE}

ARG EXPIRES=2y
LABEL maintainer="Vakamo, Inc." quay.expires-after=${EXPIRES}

RUN apk update && apk upgrade && \
    apk add --no-cache \
    ca-certificates gcc build-base curl perl nodejs npm git bash cmake pkgconf python3 linux-headers && \
    rm -rf /var/cache/apk/*

WORKDIR /build
