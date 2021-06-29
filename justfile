export RUSTC_VERSION:=`cat RUSTC_VERSION`
export REPO:="chevdor/srtool"
export TAG:=`cat VERSION`

build:
    #!/usr/bin/env bash
    echo Building $REPO:$RUSTC_VERSION
    echo Any arg you pass is forward to 'docker build'... You can pass'`--no-cache' for instance
    docker build $@ --build-arg RUSTC_VERSION=$RUSTC_VERSION -t $REPO:$RUSTC_VERSION-$TAG .

publish: build
    #!/usr/bin/env bash
    echo Pushing docker image $REPO:$RUSTC_VERSION
    docker push $REPO:$RUSTC_VERSION

tag:
    #!/bin/sh
    echo Tagging version $TAG
    git tag $TAG -f
    git tag

# Generate the readme as .md
md:
    #!/usr/bin/env bash
    asciidoctor -b docbook -a leveloffset=+1 -o - README_src.adoc | pandoc   --markdown-headings=atx --wrap=preserve -t markdown_strict -f docbook - > README.md

info:
    echo $RUSTC_VERSION
