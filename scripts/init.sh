#!/usr/bin/env bash
# This is pretty much a copy of the init script from substrate
# We have this script here because we we create the Docker image, we
# are not (yet) aware of any polkadot/substrate code

set -e
# export PATH=$PATH:$HOME/.cargo/bin # TODO this should be in the image

echo "*** Initializing WASM build environment"

rustup update nightly
rustup update stable

rustup target add wasm32-unknown-unknown --toolchain nightly

# Install wasm-gc. It's useful for stripping slimming down wasm binaries.
command -v wasm-gc || \
	cargo +nightly install --git https://github.com/alexcrichton/wasm-gc --force
