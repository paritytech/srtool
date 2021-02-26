#!/usr/bin/env bash

RUSTC_VERSION=`cat RUSTC_VERSION`
REPO=chevdor/srtool

echo Building $REPO:$RUSTC_VERSION
docker build --build-arg RUSTC_VERSION=$RUSTC_VERSION -t $REPO:$RUSTC_VERSION .
