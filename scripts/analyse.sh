#!/usr/bin/env bash

WASM=$1
WASM_FULLPATH=/build/$WASM

SZ=`du -sb $WASM_FULLPATH | awk '{print $1}'`
PROP=`subwasm -j info $Z_WASM | jq -r .proposal_hash`
AUTHORIZE_UPGRADE_PROP=`subwasm -j info $Z_WASM | jq -r .parachain_authorize_upgrade_hash`
MULTIHASH=`subwasm -j info $WASM_FULLPATH | jq -r .ipfs_hash`
SHA256=0x`shasum -a 256 $WASM_FULLPATH | awk '{print $1}'`
TMSP=$(date --utc +%FT%TZ -d @$(stat -c "%Y" $WASM_FULLPATH))
BLAKE2_256=`subwasm -j info $WASM_FULLPATH | jq -r .blake2_256`
SUBWASM=`subwasm -j info $WASM_FULLPATH`

JSON=$( jq -n \
    --arg tmsp "$TMSP" \
    --arg size "$SZ" \
    --arg prop "$PROP" \
    --arg authorize_upgrade_prop "$AUTHORIZE_UPGRADE_PROP" \
    --arg blake2_256 "$BLAKE2_256" \
    --arg ipfs "$MULTIHASH" \
    --arg sha256 "$SHA256" \
    --arg wasm "$WASM" \
    --argjson subwasm "$SUBWASM" \
    '{
        tmsp: $tmsp,
        size: $size,
        prop: $prop,
        authorize_upgrade_prop: $authorize_upgrade_prop,
        blake2_256: $blake2_256,
        ipfs: $ipfs,
        sha256: $sha256,
        wasm: $wasm,
        subwasm: $subwasm
    }' )

echo $JSON | jq -cM
