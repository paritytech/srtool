#!/usr/bin/env bash

# takes the wasm path as input and provide all infos related to it

WASM=$1

# echo WASM: $WASM

SZ=`du -sb $WASM | awk '{print $1}'`
PROP=`subwasm -j info $WASM | jq -r .proposal_hash`
MULTIHASH=`subwasm -j info $WASM | jq -r .ipfs_hash`
SHA256=0x`shasum -a 256 $WASM | awk '{print $1}'`
TMSP=$(date --utc +%FT%TZ -d @$(stat -c "%Y" $WASM))
BLAKE2_256=`subwasm -j info $WASM | jq -r .blake2_256`
SUBWASM=`subwasm -j info $WASM`

JSON=$( jq -n \
    --arg tmsp "$TMSP" \
    --arg size "$SZ" \
    --arg prop "$PROP" \
    --arg blake2_256 "$BLAKE2_256" \
    --arg ipfs "$MULTIHASH" \
    --arg sha256 "$SHA256" \
    --arg wasm "$WASM" \
    --argjson subwasm "$SUBWASM" \
    '{
        tmsp: $tmsp,
        size: $size,
        prop: $prop,
        blake2_256: $blake2_256,
        ipfs: $ipfs,
        sha256: $sha256,
        wasm: $wasm,
        subwasm: $subwasm
    }' )

echo $JSON | jq -cM
