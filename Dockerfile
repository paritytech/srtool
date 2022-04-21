FROM docker.io/library/ubuntu:20.04

LABEL maintainer "chevdor@gmail.com"
LABEL description="This image contains tools for Substrate blockchains runtimes."
SHELL ["/bin/bash", "-c"]

ARG RUSTC_VERSION="1.60.0"
ENV RUSTC_VERSION=$RUSTC_VERSION
ENV DOCKER_IMAGE="paritytech/srtool"
ENV PROFILE=release
ENV PACKAGE=polkadot-runtime
ENV BUILDER=builder

ENV SRTOOL_TEMPLATES=/srtool/templates

RUN groupadd -g 1000 $BUILDER && \
    useradd --no-log-init  -m -u 1000 -s /bin/bash -d /home/$BUILDER -r -g $BUILDER $BUILDER
RUN mkdir -p ${SRTOOL_TEMPLATES} && \
    mkdir /build && chown -R $BUILDER /build && \
    mkdir /out && chown -R $BUILDER /out

WORKDIR /tmp
ENV DEBIAN_FRONTEND=noninteractive

# Tooling
ARG SUBWASM_VERSION=0.17.0
ARG TERA_CLI_VERSION=0.2.1
ARG TOML_CLI_VERSION=0.2.1

COPY ./templates ${SRTOOL_TEMPLATES}/
RUN apt update && \
    apt upgrade -y && \
    apt install --no-install-recommends -y \
        cmake pkg-config libssl-dev make \
        git clang bsdmainutils ca-certificates curl && \
    curl -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 --output /usr/bin/jq && chmod a+x /usr/bin/jq && \
    rm -rf /var/lib/apt/lists/* /tmp/* && apt clean

ENV PATH="/srtool:/cargo-home/bin:$PATH"
RUN export PATH=/cargo-home/bin:/rustup-home:$PATH && \
    git config --global --add safe.directory /build && \
    /srtool/init.sh && \
    curl -L https://github.com/chevdor/subwasm/releases/download/v${SUBWASM_VERSION}/subwasm_linux_amd64_v${SUBWASM_VERSION}.deb --output subwasm.deb && dpkg -i subwasm.deb && subwasm --version && \
    curl -L https://github.com/chevdor/tera-cli/releases/download/v${TERA_CLI_VERSION}/tera-cli_linux_amd64.deb --output tera_cli.deb && dpkg -i tera_cli.deb && tera --version && \
    curl -L https://github.com/chevdor/toml-cli/releases/download/v${TOML_CLI_VERSION}/toml_linux_amd64_v${TOML_CLI_VERSION}.deb --output toml.deb && dpkg -i toml.deb && toml --version && \
    rm -rf /tmp/*

COPY ./scripts/* /srtool/
COPY VERSION /srtool/
COPY RUSTC_VERSION /srtool/

USER $BUILDER
ENV RUSTUP_HOME="/home/${BUILDER}/rustup"
ENV CARGO_HOME="/home/${BUILDER}/cargo"
ENV PATH="/srtool:$PATH"

# RUN export PATH=$HOME/cargo/bin:$HOME/rustup:$PATH && \
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    source $HOME/cargo/env && \
    rustup toolchain add stable ${RUSTC_VERSION} && \
    # rustup default ${RUSTC_VERSION} && \
    rustup target add wasm32-unknown-unknown --toolchain stable && \
    rustup target add wasm32-unknown-unknown --toolchain $RUSTC_VERSION && \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME && \
    # /srtool/init.sh && \
    rustup show && rustc -V

RUN git config --global --add safe.directory /build && \
    /srtool/version && \
    echo 'PATH=".:$HOME/cargo/bin:$PATH"' >> $HOME/.bashrc

VOLUME [ "/build", "/out" ]
# VOLUME [ "/build", "$CARGO_HOME", "/out" ]
WORKDIR /srtool

CMD ["/srtool/build"]
