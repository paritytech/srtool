FROM docker.io/library/ubuntu:20.04

LABEL maintainer "chevdor@gmail.com"
LABEL description="This image contains tools for Substrate blockchains runtimes."

ARG RUSTC_VERSION="1.53.0"
ENV RUSTC_VERSION=$RUSTC_VERSION
ENV DOCKER_IMAGE="paritytech/srtool"
ENV PROFILE=release
ENV PACKAGE=polkadot-runtime

RUN mkdir -p /cargo-home /rustup-home /srtool/templates
WORKDIR /tmp
ENV RUSTUP_HOME="/rustup-home"
ENV CARGO_HOME="/cargo-home"
ENV DEBIAN_FRONTEND=noninteractive

# Tooling
ENV SUBWASM_VERSION=0.12.0
ENV TERA_CLI_VERSION=0.1.3

# We first init as much as we can in the first layers
COPY ./scripts/init.sh /srtool/
COPY ./templates /srtool/templates/
RUN apt update && \
    apt upgrade -y && \
    apt install --no-install-recommends -y \
        cmake pkg-config libssl-dev make \
        git clang bsdmainutils ca-certificates curl && \
    curl -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 --output /usr/bin/jq && chmod a+x /usr/bin/jq && \
    curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain $RUSTC_VERSION -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* && apt clean

ENV PATH="/srtool:/cargo-home/bin:$PATH"
RUN export PATH=/cargo-home/bin:/rustup-home:$PATH && \
    /srtool/init.sh && \
    curl -L https://github.com/chevdor/subwasm/releases/download/v${SUBWASM_VERSION}/subwasm_linux_amd64_v${SUBWASM_VERSION}.deb --output subwasm.deb && \
    dpkg -i subwasm.deb && subwasm --version && \
    curl -L https://github.com/chevdor/tera-cli/releases/download/v${TERA_CLI_VERSION}/tera-cli_linux_amd64.deb --output tera_cli.deb && \
    dpkg -i tera_cli.deb && tera --version && \
    cargo install --git https://github.com/chevdor/toml-cli --tag v0.2.0 && \
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
