#!/usr/bin/env bash

RUSTC_VERSION=`cat RUSTC_VERSION`
REPO=chevdor/srtool

echo Building $REPO:$RUSTC_VERSION
echo Any arg you pass is forward to 'docker build'... You can pass'`--no-cache' for instance

docker build $@ --build-arg RUSTC_VERSION=$RUSTC_VERSION -t $REPO:$RUSTC_VERSION .