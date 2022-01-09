FROM docker.io/library/ubuntu:20.04

LABEL maintainer "chevdor@gmail.com"
LABEL description="This image contains tools for Substrate blockchains runtimes."

ARG UID=1000
ARG GID=1000
ARG RUSTC_VERSION="1.57.0"
ENV RUSTC_VERSION=$RUSTC_VERSION
ENV DOCKER_IMAGE="paritytech/srtool"
ENV PROFILE=release
ENV PACKAGE=polkadot-runtime
ENV DEBIAN_FRONTEND=noninteractive

# Tooling
ARG SUBWASM_VERSION=0.16.1
ARG TERA_CLI_VERSION=0.2.1
ARG TOML_CLI_VERSION=0.2.1

# We first init as much as we can in the first layers
RUN apt update && \
    apt upgrade -y && \
    apt install --no-install-recommends -y \
        cmake pkg-config libssl-dev make \
        git clang bsdmainutils ca-certificates curl && \
    curl -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 --output /usr/bin/jq && chmod a+x /usr/bin/jq && \
    rm -rf /var/lib/apt/lists/* /tmp/* && apt clean

RUN curl -L https://github.com/chevdor/subwasm/releases/download/v${SUBWASM_VERSION}/subwasm_linux_amd64_v${SUBWASM_VERSION}.deb --output subwasm.deb && dpkg -i subwasm.deb && subwasm --version && \
    curl -L https://github.com/chevdor/tera-cli/releases/download/v${TERA_CLI_VERSION}/tera-cli_linux_amd64.deb --output tera_cli.deb && dpkg -i tera_cli.deb && tera --version && \
    curl -L https://github.com/chevdor/toml-cli/releases/download/v${TOML_CLI_VERSION}/toml_linux_amd64_v${TOML_CLI_VERSION}.deb --output toml.deb && dpkg -i toml.deb && toml --version && \
    rm subwasm.deb tera_cli.deb toml.deb

RUN addgroup --gid $GID builder
RUN adduser --uid $UID --gid $GID --disabled-password --gecos "" --shell /bin/bash builder
USER builder
WORKDIR /home/builder

COPY ./scripts ./scripts
COPY ./templates ./templates
COPY VERSION VERSION
COPY RUSTC_VERSION RUSTC_VERSION

RUN curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain $RUSTC_VERSION -y

ENV CARGO_HOME="/home/builder/cargo-home"
ENV TARGET_DIR="/home/builder/target/srtool"
ENV OUT_DIR="/home/builder/out"
ENV PATH=/home/builder/.cargo/bin:$PATH

RUN ./scripts/init.sh && \
    rustup show && rustc -V

RUN mkdir -p $CARGO_HOME $TARGET_DIR $OUT_DIR

VOLUME [ "/home/builder/build" ]

CMD ["/home/builder/scripts/build"]
