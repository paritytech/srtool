set positional-arguments
export RUSTC_VERSION:=`cat RUSTC_VERSION`
export REGISTRY:="docker.io"
export REPO:="paritytech/srtool"
export TAG:=`cat VERSION`
export COMMIT:=`git rev-parse --short HEAD`

_default:
    @just --choose --chooser "fzf +s -x --tac --cycle"

# Runs a system prune to ensure we have the resources to build the image
cleanup:
    podman system prune -f

# Build the container image
build:
    @echo Building $REPO:$RUSTC_VERSION
    @echo If you encounter issues, try running `just cleanup` and try building again.
    @echo Any arg you pass is forward to 'podman build'... You can pass'`--no-cache' for instance
    podman build $@ --build-arg RUSTC_VERSION=$RUSTC_VERSION \
        -t $REGISTRY/chevdor/srtool:$RUSTC_VERSION-$TAG-$COMMIT \
        -t $REGISTRY/$REPO:$RUSTC_VERSION-$TAG \
        -t $REGISTRY/$REPO \
        -t $REGISTRY/${REPO#*/} \
        .
    podman images | grep srtool

# Build and Publish the container image
publish: build
    @echo Pushing podman image $REPO:$RUSTC_VERSION
    podman push $REGISTRY/$REPO:$RUSTC_VERSION

# Set a git tag
tag:
    @echo Tagging v$TAG
    @git tag v$TAG -f
    @git tag | sort --version-sort -r | head

# Push git tag
tag_push:
    @echo Pushing tag v$TAG
    @git push origin v$TAG -f

# Generate the readme as .md
md:
    asciidoctor -b docbook -a leveloffset=+1 -o - README_src.adoc | pandoc   --markdown-headings=atx --wrap=preserve -t markdown_strict -f docbook - > README.md

# Show version
info:
    @echo RUSTC_VERSION=$RUSTC_VERSION
    @echo REPO=$REPO
    @echo TAG=$TAG

# Quick test
test_quick *args='':
    container-structure-test test --image $REPO:$RUSTC_VERSION-$TAG --config tests/quick.yaml --verbosity debug "$@"

# Test ACL
test_acl *args='':
    container-structure-test test --image $REPO:$RUSTC_VERSION-$TAG --config tests/acl.yaml --verbosity debug "$@"

# Container test that takes longer
test_long *args='':
    container-structure-test test --image $REPO:$RUSTC_VERSION-$TAG --config tests/long.yaml --verbosity debug "$@"

# Test commands
test_commands *args='':
    container-structure-test test --image $REPO:$RUSTC_VERSION-$TAG --config tests/commands.yaml --verbosity debug "$@"

# Test all
test_all:
    #!/usr/bin/env bash
    TESTS=$(find tests -type f | sed -e 's/^/ --config /g' | tr -d '\n')
    container-structure-test test --image srtool --verbosity info ${TESTS}

# Scan the srtool image for vuln
scan:
    #!/usr/bin/env bash
    echo "scanning $REPO:$RUSTC_VERSION-$TAG"
    trivy image $REPO:$RUSTC_VERSION-$TAG
