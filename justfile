build:
    ./build-scripts/build.sh

publish: build
    ./build-scripts/publish.sh

tag:
    #!/bin/sh
    TAG=`cat VERSION`
    echo Tagging version $TAG
    git tag $TAG -f
    git tag
