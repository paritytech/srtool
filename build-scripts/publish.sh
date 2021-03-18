#!/usr/bin/env bash

RUSTC_VERSION=`cat RUSTC_VERSION`
REPO=chevdor/srtool

echo Pushing docker image $REPO:$RUSTC_VERSION
docker push $REPO:$RUSTC_VERSION 
