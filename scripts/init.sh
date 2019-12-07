#!/usr/bin/env bash
# We have this script here because we create the Docker image, we
# are not (yet) aware of any polkadot/substrate code

set -e

echo "*** Initializing WASM build environment"

# Hier we pin down the versions we are using so that everyone gets the same results.
# For now, only nightlies will work.
# rustup toolchain install $RUSTC_VERSION
rustup target add wasm32-unknown-unknown --toolchain $RUSTC_VERSION

# Install wasm-gc. It's useful for stripping slimming down wasm binaries.
command -v wasm-gc || \
	cargo +$RUSTC_VERSION install --git https://github.com/alexcrichton/wasm-gc --force
