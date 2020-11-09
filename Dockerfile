FROM ubuntu:bionic as builder
LABEL maintainer "alanxornerd@chainnet.tech"
LABEL description="This image contains tools for Chainx blockchains."

ARG RUSTC_VERSION="nightly-2020-09-30"
ENV RUSTC_VERSION=$RUSTC_VERSION
ENV PROFILE=release
ENV PACKAGE=chainx-runtime

RUN mkdir -p /cargo-home /rustup-home
WORKDIR /build
ENV RUSTUP_HOME="/rustup-home"
ENV CARGO_HOME="/cargo-home"

# We first init as much as we can in the first layers
COPY ./scripts/init.sh /srtool/
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
        cmake pkg-config libssl-dev \
        git clang bsdmainutils jq ca-certificates curl && \
    curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain $RUSTC_VERSION -y && \
    rm -rf /var/lib/apt/lists/*

ENV PATH="/srtool:/cargo-home/bin:$PATH"
RUN  export PATH=/cargo-home/bin:/rustup-home:$PATH && \
    /srtool/init.sh && \
    rustup target add wasm32-unknown-unknown --toolchain $RUSTC_VERSION && \
    cargo install --git https://gitlab.com/chevdor/substrate-runtime-hasher.git && \
    mv -f /cargo-home/bin/* /bin && \
    rustup show && rustc -V

# We copy the .cargo/bin away for 2 reasons.
# - easier with paths
# - mostly because it allows using a volume for .cargo without 'missing' the cargo bin when mapping an empty folder

# RUN echo 'export PATH="/srtool/:$PATH"' >> $HOME/.bashrc

# we copy those only at the end which makes testing of new scripts faster as the other layers are cached
COPY ./scripts/* /srtool/ 
COPY VERSION /srtool/

CMD ["/srtool/build"]
