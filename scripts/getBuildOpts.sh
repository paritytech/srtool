#!/usr/bin/env bash
CDIR=`dirname "$0"`
source "$CDIR/lib.sh"

# This script helps since version v0.8.30. Starting with this version
# a few feature has been introduced and is highly required to build
# 0.8.30 and above. Lower version however, do not support this feature.
#
# This script checks the project version and return to stdout either:
# - nothing for version up to 0.8.30 excluded
# - --features on-chain-release-build for 0.8.30 and up

# NOTE: We start using the new feature only if Cargo.toml contains version
# 0.8.30 or above. That means that commit after the feature was introduced
# and until Cargo.toml is updated will likely not work.
# srtool however should not count on the source to be a git repo.

PKG_VERSION=`toml get Cargo.toml package.version | jq -r`
REF_VERSION="0.8.30"
DEFAULT_FEATURES="--features on-chain-release-build"

vercomp $PKG_VERSION $REF_VERSION 

case $? in
    0) opts="${DEFAULT_FEATURES}";;
    1) opts="${DEFAULT_FEATURES}";;
    2) opts="";;
esac

echo -n $opts
