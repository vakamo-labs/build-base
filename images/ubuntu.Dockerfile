ARG BASE_IMAGE=ubuntu:24.04
FROM ${BASE_IMAGE}

ARG EXPIRES=2y
LABEL maintainer="Vakamo, Inc." quay.expires-after=${EXPIRES}

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    ca-certificates gcc g++ build-essential curl perl git bash cmake pkg-config python3 buildah podman \
    linux-headers-generic clang libclang-dev llvm && \
    # Add Docker's official GPG key
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    # Install Docker's stable repository
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    # Install Docker packages
    apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
    # Clean up
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /build
