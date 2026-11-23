ARG BASE_IMAGE=ubuntu:22.04
FROM ${BASE_IMAGE}

ARG EXPIRES=2y
LABEL maintainer="Vakamo, Inc." quay.expires-after=${EXPIRES}

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
    libssl-dev ca-certificates jq ldap-utils postgresql-client fuse-overlayfs wget gcc g++ build-essential lsb-release curl perl git bash cmake pkg-config python3 buildah podman \
    linux-headers-generic clang libclang-dev llvm openssh-client && \
    # Install just from GitHub releases (multi-arch)
    # The release page redirects to the latest tag; the GitHub API rate-limits calls without a token.
    JUST_VERSION=$(curl -fsSL -o /dev/null -w '%{url_effective}' https://github.com/casey/just/releases/latest | sed 's#.*/##') && \
    JUST_ARCH="$(uname -m)-unknown-linux-musl" && \
    wget -O just.tar.gz "https://github.com/casey/just/releases/download/${JUST_VERSION}/just-${JUST_VERSION}-${JUST_ARCH}.tar.gz" && \
    tar -xzf just.tar.gz && \
    mv just /usr/local/bin/ && \
    rm just.tar.gz && \
    # Install yq from GitHub releases (multi-arch)
    YQ_ARCH=$(dpkg --print-architecture) && \
    wget -O /usr/local/bin/yq "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${YQ_ARCH}" && \
    chmod +x /usr/local/bin/yq && \
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
