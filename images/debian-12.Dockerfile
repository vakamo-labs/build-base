ARG BASE_IMAGE=debian:12
FROM ${BASE_IMAGE}

ARG EXPIRES=2y
LABEL maintainer="Vakamo, Inc." quay.expires-after=${EXPIRES}

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
    libssl-dev ca-certificates fuse-overlayfs wget gcc g++ build-essential lsb-release curl perl git bash cmake pkg-config python3 buildah podman \
    linux-headers-generic clang libclang-dev llvm openssh-client && \
    # Install just from GitHub releases
    JUST_VERSION=$(curl -s https://api.github.com/repos/casey/just/releases/latest | grep -o '"tag_name": "[^"]*' | cut -d'"' -f4) && \
    wget -O just.tar.gz "https://github.com/casey/just/releases/download/${JUST_VERSION}/just-${JUST_VERSION}-x86_64-unknown-linux-musl.tar.gz" && \
    tar -xzf just.tar.gz && \
    mv just /usr/local/bin/ && \
    rm just.tar.gz && \
    # gh cli
    mkdir -p -m 755 /etc/apt/keyrings && \
    out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg && \
    cat $out | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null && \
    chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update -yqq && \
    apt-get install gh -yqq && \
    # Clean up
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /build
