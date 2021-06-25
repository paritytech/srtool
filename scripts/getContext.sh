#!/usr/bin/env bash

# This script provide all context (usually from the ENV) and returns it as a piece
# of json we can append to the srtool final output

JSON=$( jq -n \
    --arg package "$PACKAGE" \
    --arg runtime_dir "$RUNTIME_DIR" \
    --arg docker_image "$DOCKER_IMAGE" \
    --arg docker_tag "$RUSTC_VERSION" \
    --arg profile "$PROFILE" \
    '{
        package: $package,
        runtime_dir: $runtime_dir,
        docker: {
            image: $docker_image,
            tag: $docker_tag
        },
        profile: $profile,
    }' )

echo $JSON | jq -cM