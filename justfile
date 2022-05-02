export RUSTC_VERSION:=`cat RUSTC_VERSION`
export REPO:="paritytech/srtool"
export TAG:=`cat VERSION`

_default:
    just --choose --chooser "fzf +s -x --tac --cycle"

# Runs a docker system prune to ensure we have the resources to build the image
cleanup:
    docker system prune -f

# Build the docker image
build:
    @echo Building $REPO:$RUSTC_VERSION
    @echo If you encounter issues, try running `just cleanup` and try building again.
    @echo Any arg you pass is forward to 'docker build'... You can pass'`--no-cache' for instance
    docker build $@ --build-arg RUSTC_VERSION=$RUSTC_VERSION -t srtool -t $REPO:$RUSTC_VERSION-$TAG .
    docker images | grep srtool

# Build and Publish the docker image
publish: build
    @echo Pushing docker image $REPO:$RUSTC_VERSION
    docker push $REPO:$RUSTC_VERSION

# Set a git tag
tag:
    @echo Tagging version $TAG
    @git tag v$TAG -f
    @git tag | sort --version-sort -r

# Generate the readme as .md
md:
    asciidoctor -b docbook -a leveloffset=+1 -o - README_src.adoc | pandoc   --markdown-headings=atx --wrap=preserve -t markdown_strict -f docbook - > README.md

# Show version
info:
    @echo RUSTC_VERSION=$RUSTC_VERSION
    @echo REPO=$REPO
    @echo TAG=$TAG
