FROM docker.io/library/ubuntu:20.04

LABEL maintainer "chevdor@gmail.com"
LABEL description="This image contains tools for Substrate blockchains runtimes."

ARG RUSTC_VERSION="1.60.0"
ENV RUSTC_VERSION=$RUSTC_VERSION
ENV DOCKER_IMAGE="paritytech/srtool"
ENV PROFILE=release
ENV PACKAGE=polkadot-runtime

RUN groupadd -g 1000 builder && \
    useradd --no-log-init  -m -u 1000 -s /bin/bash -d /builder -r -g builder builder
RUN mkdir -p /cargo-home /rustup-home /srtool/templates
WORKDIR /tmp
ENV RUSTUP_HOME="/rustup-home"
ENV CARGO_HOME="/cargo-home"
ENV DEBIAN_FRONTEND=noninteractive

# Tooling
ARG SUBWASM_VERSION=0.17.0
ARG TERA_CLI_VERSION=0.2.1
ARG TOML_CLI_VERSION=0.2.1

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
    git config --global --add safe.directory /build && \
    /srtool/init.sh && \
    curl -L https://github.com/chevdor/subwasm/releases/download/v${SUBWASM_VERSION}/subwasm_linux_amd64_v${SUBWASM_VERSION}.deb --output subwasm.deb && dpkg -i subwasm.deb && subwasm --version && \
    curl -L https://github.com/chevdor/tera-cli/releases/download/v${TERA_CLI_VERSION}/tera-cli_linux_amd64.deb --output tera_cli.deb && dpkg -i tera_cli.deb && tera --version && \
    curl -L https://github.com/chevdor/toml-cli/releases/download/v${TOML_CLI_VERSION}/toml_linux_amd64_v${TOML_CLI_VERSION}.deb --output toml.deb && dpkg -i toml.deb && toml --version && \
    mv -f $CARGO_HOME/bin/* /bin && \
    touch ${RUSTUP_HOME} && chown -R builder ${RUSTUP_HOME} && chmod -R u+rwx ${RUSTUP_HOME} && \
    touch ${CARGO_HOME}/env && chown builder ${CARGO_HOME} &&  chmod -R u+rwx ${CARGO_HOME} && \

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

VOLUME [ "/build", "$CARGO_HOME", "/out" ]
WORKDIR /srtool
USER builder
CMD ["/srtool/build"]
