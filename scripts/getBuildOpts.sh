#!/usr/bin/env bash
CDIR=`dirname "$0"`
source "/srtool/lib.sh"

# This script helps since version v0.8.30. Starting with this version
# a few feature has been introduced and is highly required to build
# 0.8.30 and above for Polkadot and Kusama.
# Lower version however, do not support this feature.
#
# This script checks the project version and return to stdout either:
# - nothing for version up to 0.8.30 excluded
# - --features on-chain-release-build for 0.8.30 and up for Kusama and Polkadot

# NOTE: We start using the new feature only if Cargo.toml contains version
# 0.8.30 or above. That means that commit after the feature was introduced
# and until Cargo.toml is updated will likely not work.
# srtool cannot count on the source to be a git repo.

# PKG_VERSION=`toml get Cargo.toml package.version | jq -r`
PKG_VERSION=$(get_runtime_package_version "$PACKAGE")

REF_VERSION="0.8.30"
DEFAULT_FEATURES="${DEFAULT_FEATURES:---features on-chain-release-build}"

if [[ "$PACKAGE" =~ ^(kusama|polkadot)-runtime$ ]]; then
    vercomp "$PKG_VERSION" "$REF_VERSION"
    case $? in
        0) opts="${DEFAULT_FEATURES}";;
        1) opts="${DEFAULT_FEATURES}";;
        2) opts="";;
    esac
else
    opts=""
fi

echo -n $opts
