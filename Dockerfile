FROM ubuntu:bionic as builder
LABEL maintainer "chevdor@gmail.com"
LABEL description="This image contains tools for Substrate blockchains."

ARG RUSTC_VERSION="nightly-2020-10-27"
ENV RUSTC_VERSION=$RUSTC_VERSION
ENV PROFILE=release
ENV PACKAGE=polkadot-runtime

RUN mkdir -p /cargo-home /rustup-home 
WORKDIR /build
ENV RUSTUP_HOME="/rustup-home"
ENV CARGO_HOME="/cargo-home"

# We first init as much as we can in the first layers
COPY ./scripts/init.sh /srtool/
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
        cmake pkg-config libssl-dev make \
        git clang bsdmainutils ca-certificates curl && \
    curl -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 --output /usr/bin/jq && \
    chmod a+x /usr/bin/jq && \
    curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain $RUSTC_VERSION -y && \
    curl -L https://dist.ipfs.io/go-ipfs/v0.8.0/go-ipfs_v0.8.0_linux-amd64.tar.gz --output /tmp/ipfs.tar.gz && \
    tar -xvzf /tmp/ipfs.tar.gz -C /tmp/ && \
    /tmp/go-ipfs/install.sh && \
    ipfs init && \
    ipfs --version && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# ipfs init could be remove in the future once https://github.com/ipfs/go-ipfs/issues/7990 gets fixed
# We install jq manually as version 1.5 is broken

ENV PATH="/srtool:/cargo-home/bin:$PATH"
RUN export PATH=/cargo-home/bin:/rustup-home:$PATH && \
    /srtool/init.sh && \
    cargo install --git https://gitlab.com/chevdor/substrate-runtime-hasher.git && \
    cargo install toml-cli && \
    mv -f /cargo-home/bin/* /bin && \
    touch /cargo-home/env && \
    mkdir /out && \
    rustup show && rustc -V

# We copy the .cargo/bin away for 2 reasons.
# - easier with paths
# - mostly because it allows using a volume for .cargo without 'missing' the cargo bin when mapping an empty folder

# RUN echo 'export PATH="/srtool/:$PATH"' >> $HOME/.bashrc

# we copy those only at the end which makes testing of new scripts faster as the other layers are cached
COPY ./scripts/* /srtool/ 
COPY VERSION /srtool/
COPY RUSTC_VERSION /srtool/

VOLUME [ "/build", "/cargo-home", "/out" ]
WORKDIR /srtool

CMD ["/srtool/build"]
