#!/usr/bin/env bash

# A function to compare semver versions
vercomp() {
    if [[ $1 == $2 ]]; then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i = ${#ver1[@]}; i < ${#ver2[@]}; i++)); do
        ver1[i]=0
    done
    for ((i = 0; i < ${#ver1[@]}; i++)); do
        if [[ -z ${ver2[i]} ]]; then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]})); then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]})); then
            return 2
        fi
    done
    return 0
}

# Get the version of the runtime package
get_runtime_package_version() {
    PACKAGE=$1
    toml get Cargo.lock . | jq -r '.package[] | select(.name == "'"$PACKAGE"'") | .version'
}

function relative_parent() {
    echo "$1" | sed -E 's/(.*)\/(.*)\/\.\./\1/g'
}

# TODO: The following should be removed once it has been merged into the polkadot-sdk repo and used from there.
# Find all the runtimes, it returns the result as JSON as an array of
# arrays containing the crate name and the runtime_dir
function find_runtimes() {
    libs=($(git grep -I -r --cached --max-depth 20 --files-with-matches 'construct_runtime!' -- '*lib.rs'))
    re=".*-runtime$"
    JSON=$(jq --null-input '{ "include": [] }')

    # EXCLUDED_RUNTIMES is a space separated list of runtime names (without the -runtime postfix)
    # EXCLUDED_RUNTIMES=${EXCLUDED_RUNTIMES:-"substrate-test"}
    IFS=' ' read -r -a exclusions <<< "$EXCLUDED_RUNTIMES"

    for lib in "${libs[@]}"; do
        crate_dir=$(dirname "$lib")
        cargo_toml="$crate_dir/../Cargo.toml"

        name=$(toml get -r $cargo_toml 'package.name')
        chain=${name//-runtime/}

        if [[ "$name" =~ $re ]] && ! [[ ${exclusions[@]} =~ $chain ]]; then
            lib_dir=$(dirname "$lib")
            runtime_dir=$(relative_parent "$lib_dir/..")
            ITEM=$(jq --null-input \
                --arg chain "$chain" \
                --arg name "$name" \
                --arg runtime_dir "$runtime_dir" \
                '{ "chain": $chain, "crate": $name, "runtime_dir": $runtime_dir }')
            JSON=$(echo $JSON | jq ".include += [$ITEM]")
        fi
    done
    echo $JSON
}
