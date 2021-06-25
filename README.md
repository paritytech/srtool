# Substrate Runtime Toolbox: srtool

![srtool docker 512px](resources/srtool-docker_512px.png)

## Intro

srtool is a collection of dockerized tools helping with [Substrate](https://substrate.dev) & [Polkadot](https://polkadot.network) Runtime development.

It especially helps with building and verifying Wasm Runtime Blobs. The Docker image is `chevdor/srtool`. You can find it at <https://hub.docker.com/r/chevdor/srtool>.

There are a few other helpers you may want to chcek out when using `srtool`:

-   [srtool-cli](https://github.com/chevdor/srtool-cli): This Rust executable supersedes the preiviously recommended alias solution. It brings many benefits and is moreover much easier to use.

-   [srtool-app](https://gitlab.com/chevdor/srtool-app): The basic features of `srtool` as here available from a simple GUI accessible from a few clicks and available on multiple platforms.

-   [srtool-actions](https://github.com/chevdor/srtool-actions): This Github actions makes it much easier to integrate `srtool` in your CI.

-   …​ and more to come

![Frame 1 256](resources/Frame%201_256.png)

`srtool` is a tool for chain builders, it is widely used in CI such as Github Actions, it can also be used by anyone who wants to indenpendantly check and audit a chain or parachain.

You may also want to have a look at [subwasm](https://github.com/chevdor/subwasm) as it is now part of the tooling included in `srtool`. `subwasm` can also be used independantly upon building your wasm with `srtool`.

## Install

### Install the srtool-cli

Since the `srtool-cli` (<https://gitlab.com/chevdor/srtool-cli>) exists, there is no reason to be using an alias. Using the cli over the alias brings many advantages and will save you time.

The `srtool-cli` is a command line utility written in Rust, you can read more in [its repository](https://gitlab.com/chevdor/srtool-cli), the installation process is described in more details there. In short:

    cargo install --git https://gitlab.com/chevdor/srtool-cli

### Using an alias

This method is legacy and deprecated, prefer the `srtool-cli` utility mentioned above. This information is left here however for documentation purpose but all the functions are now availabe in the `srtool-cli`.

Creating an alias helps hiding the docker complexity behind one simple command. We will see more powerful options but this one is simple enough.

        export RUSTC_VERSION=nightly-2021-06-20; export PACKAGE=kusama-runtime; alias srtool='docker run --rm -it -e PACKAGE=$PACKAGE -v $PWD:/build -v $TMPDIR/cargo:/cargo-home chevdor/srtool:$RUSTC_VERSION'

Note that defining the alias as done above will hardcode the runtime. Using `kusama-runtime` as show above means you will **always** check the kusama runtime. If you need more, check the next chapter.

If you want to check what your alias is, use `type srtool`

The command to invoke a build will then be `srtool build`.

## Use

Now that you defined the srtool alias, you can use it as shown below:

**See the help**

    $ srtool help

**Build the runtime**

    $ srtool build

**Typical run**

Invoking `srtool build` with:

    $ srtool build

Will output something that looks like this:

        🧰 Substrate Runtime Toolbox - srtool v0.9.11 🧰
                  - by Chevdor -
        🏗  Building polkadot-runtime as release using rustc 1.49.0-nightly (fd542592f 2020-10-26)
        ⏳ That can take a little while, be patient... subsequent builds will be faster.
        Since you have to wait a little, you may want to learn more about Substrate runtimes:
        https://substrate.dev/docs/en/#architecture

            Finished release [optimized] target(s) in 37.43s

some times later …​

    ✨ Your Substrate WASM Runtime is ready! ✨
    Summary:
      Generator  : srtool v0.9.12
      Version    : null
      GIT commit : 56b9e95a9b634695f59a7c699bc68a5cfb695f03
      GIT tag    : moonriver-genesis
      GIT branch : master
      Rustc      : rustc 1.54.0-nightly (657bc0188 2021-05-31)
      Package    : moonriver-runtime
      Time       : 2021-06-15T17:44:58Z
    === Compact:
      Size       : 2032 KB (2081495 bytes)
      Proposal   : 0x63a4e0751531b190a910a1d5ae3e7d196f26451014c71455dd708eac05a9d5d6
      IPFS       : QmVAVAHMak2zTm3sjNiZXmrZHofQBTxQx7PBooPsRp22R1
      SHA256     : 0x9d00f4c83ad2bbec37e6d9e9bc2a4aecaeeebbf24f68b69766ba6851b4745173
      Wasm       : runtime/moonriver/target/srtool/release/wbuild/moonriver-runtime/moonriver_runtime.compact.wasm
    === Compressed:
      Size       : 2032 KB (2081495 bytes)
      Proposal   : 0x63a4e0751531b190a910a1d5ae3e7d196f26451014c71455dd708eac05a9d5d6
      IPFS       : QmVAVAHMak2zTm3sjNiZXmrZHofQBTxQx7PBooPsRp22R1
      SHA256     : 0x9d00f4c83ad2bbec37e6d9e9bc2a4aecaeeebbf24f68b69766ba6851b4745173
      Wasm       : runtime/moonriver/target/srtool/release/wbuild/moonriver-runtime/moonriver_runtime.compact.wasm

**JSON output**

If you prefer a json output, srtool has you covered:

    $ srtool build --json

Will give you such an output:

    {
        "gen": "srtool v0.9.12",
        "src": "git",
        "version": "null",
        "commit": "56b9e95a9b634695f59a7c699bc68a5cfb695f03",
        "tag": "moonriver-genesis",
        "branch": "master",
        "rustc": "rustc 1.54.0-nightly (657bc0188 2021-05-31)",
        "pkg": "moonriver-runtime",
        "tmsp": "2021-06-15T17:48:34Z",
        "size": "2081495",
        "prop": "0x63a4e0751531b190a910a1d5ae3e7d196f26451014c71455dd708eac05a9d5d6",
        "ipfs": "QmVAVAHMak2zTm3sjNiZXmrZHofQBTxQx7PBooPsRp22R1",
        "sha256": "0x9d00f4c83ad2bbec37e6d9e9bc2a4aecaeeebbf24f68b69766ba6851b4745173",
        "wasm": "runtime/moonriver/target/srtool/release/wbuild/moonriver-runtime/moonriver_runtime.compact.wasm",
        "details": {
            "compact": {
                "tmsp": "2021-06-15T17:48:17Z",
                "size": "2081495",
                "prop": "0x63a4e0751531b190a910a1d5ae3e7d196f26451014c71455dd708eac05a9d5d6",
                "blake2_256": "0x6acb9ca6508efba0791551d4acaa3f2089b019c9a38434a9b1011d3a2dbf9453",
                "ipfs": "QmVAVAHMak2zTm3sjNiZXmrZHofQBTxQx7PBooPsRp22R1",
                "sha256": "0x9d00f4c83ad2bbec37e6d9e9bc2a4aecaeeebbf24f68b69766ba6851b4745173",
                "wasm": "/build/runtime/moonriver/target/srtool/release/wbuild/moonriver-runtime/moonriver_runtime.compact.wasm",
                "subwasm": {
                    "size": 2081495,
                    "compression": {
                        "size_compressed": 2081495,
                        "size_decompressed": 2081495,
                        "compressed": false
                    },
                    "reserved_meta": [
                        109,
                        101,
                        116,
                        97
                    ],
                    "reserved_meta_valid": true,
                    "metadata_version": 13,
                    "core_version": "moonriver-51 (moonriver-1.tx2.au3)",
                    "proposal_hash": "0x63a4e0751531b190a910a1d5ae3e7d196f26451014c71455dd708eac05a9d5d6",
                    "ipfs_hash": "QmVAVAHMak2zTm3sjNiZXmrZHofQBTxQx7PBooPsRp22R1",
                    "blake2_256": "0x6acb9ca6508efba0791551d4acaa3f2089b019c9a38434a9b1011d3a2dbf9453"
                }
            },
            "compressed": {
                "tmsp": "2021-06-15T17:48:17Z",
                "size": "608158",
                "prop": "0x63a4e0751531b190a910a1d5ae3e7d196f26451014c71455dd708eac05a9d5d6",
                "blake2_256": "0x6acb9ca6508efba0791551d4acaa3f2089b019c9a38434a9b1011d3a2dbf9453",
                "ipfs": "QmVAVAHMak2zTm3sjNiZXmrZHofQBTxQx7PBooPsRp22R1",
                "sha256": "0x7659960c8e875f2a3fdcfd95ec029b28019344a88eeb7bfd278e0c1a39ce4546",
                "wasm": "/build/runtime/moonriver/target/srtool/release/wbuild/moonriver-runtime/moonriver_runtime.compact.compressed.wasm",
                "subwasm": {
                    "size": 2081495,
                    "compression": {
                        "size_compressed": 608158,
                        "size_decompressed": 2081495,
                        "compressed": true
                    },
                    "reserved_meta": [
                        109,
                        101,
                        116,
                        97
                    ],
                    "reserved_meta_valid": true,
                    "metadata_version": 13,
                    "core_version": "moonriver-51 (moonriver-1.tx2.au3)",
                    "proposal_hash": "0x63a4e0751531b190a910a1d5ae3e7d196f26451014c71455dd708eac05a9d5d6",
                    "ipfs_hash": "QmVAVAHMak2zTm3sjNiZXmrZHofQBTxQx7PBooPsRp22R1",
                    "blake2_256": "0x6acb9ca6508efba0791551d4acaa3f2089b019c9a38434a9b1011d3a2dbf9453"
                }
            }
        }
    }

## Troubleshooting

### Outdated repo

If you run into issues while running `srtool`, make sure you are using a decently recent version of Polkadot/Substrate:

Then run the following commands:

    rm -rf target/srtool
    cargo clean
    cargo update

You can now try running `srtool build` again.

### `srtool` tells me the folder is not a cargo project

The error is probably: `` !!! The folder on your host computer does not look like a Cargo project. Are you really in your repo?` ``

Run the following command:

    alias srtool

And make sure that you see `$PWD:/build/` and not `/home/your_name/:/build`.
If you are running into this issue, your `.bash_profile` likely contains double quotes (") where you should have used single ones (').

### Other cases

If you still run into troubles, please open a new issue and describe the error you see and the steps you took.

## Proposal field

What is important in the output of srtool is the `Proposal` field:

        🧰 Substrate Runtime Toolbox 🧰
        ... Bla bla ...
        Proposal : 0x5931690e71e9d3d9f04a43d8c15e45e0968e563858dd87ad6485b2368a286a8f
        ... more blabla ...

The `Proposal` field value should should match the value of the proposal you can see in the Polkadot UI.

## IPFS Hash

Starting with version 0.9.8, the IPFS hash is computed and added to the output. `srtool` is only computing the hash. It does not publish the the file to IPFS nor connect to IPFS.

**Advanced usage**

if you feel fancy, you may also run:

    srtool bash

and look around the `/srtool` folder

## ZSH/ Zinit users

If you are using `zsh` and `zinit`, you may benefit from using the srtool snippet I am maintaining.

To do so, add the following to your `zshconfig`:

    MY_REPO="https://gitlab.com/chevdor/dotfiles/-/raw/master/zsh-plugins"
    for plugin (git cargo srtool); { 
      SNIPPET="$MY_REPO/$plugin/$plugin.plugin.zsh"
      zinit snippet $SNIPPET
    }

-   Chose the snippets you want, the one called `srtool` here is the interesting one.

After that, make sure to:
- upgrade your snippets: `zplugin update --all`
- restart/source your shell: `. ~/.zshrc`

## Build the Docker image

While you don’t have to build the image yourself, you still may!

First you may want to double check what rustc versions are available as you will HAVE to build an image for a given version:

    rustup check

So say you want to build a builder for rustc nightly-2021-06-20:

        RUSTC_VERSION=nightly-2021-06-20 && docker build --build-arg RUSTC_VERSION=$RUSTC_VERSION -t chevdor/srtool:$RUSTC_VERSION .

## User Scripts

You can see the list of available scripts in the `/scripts` folder:

-   `help`: Show some help

-   `version`: Show some version.

-   `info`: Show systems infos that are available before running a build

-   `build`: Run the actual build

The `info` and `version` scripts pass any arguments you pass to the script to `jq`. So you can play with `c` (compact), `-M`(monochrome), `-C` color output. For instance `docker run --rm -it -v $PWD:/build chevdor/srtool:nightly-2021-06-20 info -cM` shows a monochrome output on a single line.

## Build your custom chain / parachain

Building the runtime for your custom chain may not work with the default used for Kusama, Polkadot and Co.
You can however help `srtool` making the right choices using ENV VARs. You will need to make a new alias as shown below

Here is for instance how to build the runtime for the substrate-node-template:

    alias mysrtool='docker run --rm -it --name mysrtool -e RUNTIME_DIR=runtime -e BUILD_OPTS=" " -e PACKAGE=$PACKAGE -v $PWD:/build -v /tmp/cargo:/cargo-home chevdor/srtool:$RUSTC_VERSION'

`BUILD_OPTS` is set to a space, not an empty string.

Using `srtool-cli` makes the above much easier…​

## Export the runtime

In order to easily export your runtime, it will be copied in the container into the `/out` folder.
If you mount this docker volume, you will find the wasm on your local filesystem once the run is complete.

    docker run ... -v /tmp/out:/out ...
