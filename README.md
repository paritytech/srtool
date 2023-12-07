# Substrate Runtime Toolbox: srtool v0.13.0

<figure>
<img src="resources/srtool-docker_128px.png" alt="srtool docker 128px" />
</figure>

## Intro

`srtool` is a collection of containerized tools helping with building WASM Runtimes for the
[Polkadot Network](https://polkadot.network). `srtool` especially allows building WASM runtimes in a
**deterministic** way, allowing CIs and users, with various machines and OS, to produce a strictly identical WASM runtime.

`srtool` can run on various Operating Systems supporting Podman or Docker. That includes Linux, MacOS and Windows.

`srtool` helps building and verifying WASM Runtimes. The Docker image is named `paritytech/srtool`. You can find the project’s repository at <https://hub.docker.com/r/paritytech/srtool>.

## Docker image naming scheme

The Docker images are tagged with both the rustc version used internally as well as the version of the build script.

You may find for instance the following:

-   `paritytech/srtool:1.74.0-0.13.0`

-   `paritytech/srtool:1.74.0`

The tags not mentioning the build version always point to the latest one. In the example above, `paritytech/srtool:1.74.0` is the same image than `paritytech/srtool:1.74.0-0.13.0`.

## Related tools

There are a few other helpers you may want to check out when using `srtool`:

-   [srtool-cli](https://github.com/chevdor/srtool-cli): This Rust executable supersedes the previously recommended alias solution. It brings many benefits and is much easier to use.

-   [srtool-app](https://gitlab.com/chevdor/srtool-app): The basic features of `srtool` in a simple GUI, available on multiple platforms.

-   [srtool-actions](https://github.com/chevdor/srtool-actions): This Github actions makes it much easier to integrate `srtool` in your CI.

-   …​ and more to come

<figure>
<img src="resources/Frame%201_256.png" alt="Frame 1 256" />
</figure>

`srtool` is a tool for chain builders, it is widely used in CI such as Github Actions, it can also be used by anyone who wants to independently check and audit the runtime of a chain or a parachain.

You may also want to have a look at [subwasm](https://github.com/chevdor/subwasm) as it is now part of the tooling included in `srtool`. `subwasm` can also be used independently upon building your wasm with `srtool`.

## History

The project was initially developed by <https://gitlab.com/chevdor>.
It has now moved to Github under the [Parity Technologies](https://www.github.com/paritytech) organisation to simplify the developement and the integration with other Parity products such as Polkadot and Kusama.

The last version hosted on Gitlab has been built using Rust Stable 1.74.0. It is tagged as v0.13.0 and there is no plan on updating the Gitlab repository further. New versions will be available from [this repository](https://www.github.com/paritytech/srtool) only. The functionalities remain the same so you can (and should!) simply swap `chevdor/srtool` for `paritytech/srtool` in your workflows. The [srtool-actions](https://github.com/chevdor/srtool-actions) will remain available as `chevdor/srtool-actions@<version>` and will be updated to point at the paritytech image.

## Install

### Install the srtool-cli

Since the [`srtool-cli`](https://github.com/chevdor/srtool-cli) exists, there is no reason to be using an alias anymore. Using the cli over the alias brings many advantages and will save you time.

The `srtool-cli` is a command line utility written in Rust. You can read more about the installation process [here](https://github.com/chevdor/srtool-cli).

### Using an alias

This method is legacy and deprecated. It is recommended to use the `srtool-cli` utility mentioned above. This information is left here for documentation purposes only — all the functions are now availabe in the `srtool-cli`.

Creating an alias helps hiding the docker complexity behind one simple command. We will see more powerful options but this one is simple enough.

        export RUSTC_VERSION=1.74.0; export PACKAGE=kusama-runtime; alias srtool='docker run --rm -it -e PACKAGE=$PACKAGE -v $PWD:/build -v $TMPDIR/cargo:/cargo-home paritytech/srtool:$RUSTC_VERSION'

Note that defining the alias as done above will hardcode the runtime. Using `kusama-runtime` as shown above means you will **always** check the Kusama runtime. If you need more, check the next chapter.

If you want to check what your alias is, use `type srtool`

The command to invoke a build will then be `srtool build`.

## Use

Now that you have defined the srtool alias, you can use it as shown below:

**See the help**

    $ srtool help

**Build the runtime**

    $ srtool build

**Typical run**

Invoking `srtool build` with

    $ srtool build

will output something that looks like this:

        🧰 Substrate Runtime Toolbox - srtool v0.13.0 🧰
                  - by Chevdor -
        🏗  Building polkadot-runtime as release using rustc 1.74.0
        ⏳ That can take a little while, be patient... subsequent builds will be faster.
        Since you have to wait a little, you may want to learn more about Substrate runtimes:
        https://docs.substrate.io/learn/architecture/

            Finished release [optimized] target(s) in 37.43s

and finally …​

    ✨ Your Substrate WASM Runtime is ready! ✨
    Summary:
      Generator  : srtool v0.13.0
      Version    : null
      GIT commit : 56b9e95a9b634695f59a7c699bc68a5cfb695f03
      GIT tag    : moonriver-genesis
      GIT branch : master
      Rustc      : rustc 1.53.0-nightly (657bc0188 2021-05-31)
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

The output will look something like:

    {
        "gen": "srtool v0.13.0",
        "src": "git",
        "version": "1.0.0",
        "commit": "85cad2ef48f123d7475385b00d113bc900324ad6",
        "tag": "statemine-v1.0.0",
        "branch": "wk-gh-actions",
        "rustc": "rustc 1.74.0 (...)",
        "pkg": "statemine-runtime",
        "tmsp": "2021-06-22T18:08:50Z",
        "size": "1538747",
        "prop": "0xaf313fb7d1fb37d75080de43d0a0a3c06801c2be302d16f560b1acf1bda53c28",
        "ipfs": "QmRkiTxXEhT8Goxx7Vv2RwRuHV3ZD3AAQhFBovYFuKtaCE",
        "sha256": "0x0fa6fc0110e95bcf61a828d146d1e5a683664415d2c10755875ad3943f42b001",
        "wasm": "polkadot-parachains/statemine-runtime/target/srtool/release/wbuild/statemine-runtime/statemine_runtime.compact.wasm",
        "info": {
          "generator": {
            "name": "srtool",
            "version": "0.13.0"
          },
          "src": "git",
          "version": "1.0.0",
          "git": {
            "commit": "85cad2ef48f123d7475385b00d113bc900324ad6",
            "tag": "statemine-v1.0.0",
            "branch": "wk-gh-actions"
          },
          "rustc": "rustc 1.74.0 (...)",
          "pkg": "statemine-runtime",
          "profile": "release"
        },
        "context": {
          "package": "statemine-runtime",
          "runtime_dir": "polkadot-parachains/statemine-runtime",
          "docker": {
            "image": "chevdor/srtool",
            "tag": "nightly-2021-06-20"
          },
          "profile": "release"
        },
        "runtimes": {
          "compact": {
            "tmsp": "2021-06-22T18:08:30Z",
            "size": "1538747",
            "prop": "0xaf313fb7d1fb37d75080de43d0a0a3c06801c2be302d16f560b1acf1bda53c28",
            "blake2_256": "0x9cf51f8803bc2181ffbc6a9b9c91cd3471e6050b2fb3ed6146d1cad21ad4dd4d",
            "ipfs": "QmRkiTxXEhT8Goxx7Vv2RwRuHV3ZD3AAQhFBovYFuKtaCE",
            "sha256": "0x0fa6fc0110e95bcf61a828d146d1e5a683664415d2c10755875ad3943f42b001",
            "wasm": "/build/polkadot-parachains/statemine-runtime/target/srtool/release/wbuild/statemine-runtime/statemine_runtime.compact.wasm",
            "subwasm": {
              "size": 1538747,
              "compression": {
                "size_compressed": 1538747,
                "size_decompressed": 1538747,
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
              "core_version": "statemine-1 (statemine-1.tx1.au1)",
              "proposal_hash": "0xaf313fb7d1fb37d75080de43d0a0a3c06801c2be302d16f560b1acf1bda53c28",
              "ipfs_hash": "QmRkiTxXEhT8Goxx7Vv2RwRuHV3ZD3AAQhFBovYFuKtaCE",
              "blake2_256": "0x9cf51f8803bc2181ffbc6a9b9c91cd3471e6050b2fb3ed6146d1cad21ad4dd4d"
            }
          },
          "compressed": {
            "tmsp": "2021-06-22T18:08:30Z",
            "size": "452258",
            "prop": "0xaf313fb7d1fb37d75080de43d0a0a3c06801c2be302d16f560b1acf1bda53c28",
            "blake2_256": "0x9cf51f8803bc2181ffbc6a9b9c91cd3471e6050b2fb3ed6146d1cad21ad4dd4d",
            "ipfs": "QmRkiTxXEhT8Goxx7Vv2RwRuHV3ZD3AAQhFBovYFuKtaCE",
            "sha256": "0x90d8a93bfa6d69ea0a2ac1c8983e5777f3af10b0ca8506cd86c8de9ec0f462b8",
            "wasm": "/build/polkadot-parachains/statemine-runtime/target/srtool/release/wbuild/statemine-runtime/statemine_runtime.compact.compressed.wasm",
            "subwasm": {
              "size": 1538747,
              "compression": {
                "size_compressed": 452258,
                "size_decompressed": 1538747,
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
              "core_version": "statemine-1 (statemine-1.tx1.au1)",
              "proposal_hash": "0xaf313fb7d1fb37d75080de43d0a0a3c06801c2be302d16f560b1acf1bda53c28",
              "ipfs_hash": "QmRkiTxXEhT8Goxx7Vv2RwRuHV3ZD3AAQhFBovYFuKtaCE",
              "blake2_256": "0x9cf51f8803bc2181ffbc6a9b9c91cd3471e6050b2fb3ed6146d1cad21ad4dd4d"
            }
          }
        }
      }

## Troubleshooting

### Outdated repo

If you run into issues while running `srtool`, make sure you’re using a decently recent version of Polkadot/Substrate:

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
If you’re running into this issue, your `.bash_profile` likely contains double quotes (") where you should have used single ones (').

### Other cases

If you still run into any trouble, please open a new issue and describe the error you see and the steps you took.

## Proposal field

What is important in the output of srtool is the `Proposal` field:

        🧰 Substrate Runtime Toolbox 🧰
        ... Bla bla ...
        Proposal : 0x5931690e71e9d3d9f04a43d8c15e45e0968e563858dd87ad6485b2368a286a8f
        ... more blabla ...

The `Proposal` field value should match the value of the proposal you can see in the Polkadot UI.

## IPFS Hash

Starting with version 0.9.8, the IPFS hash is computed and added to the output. `srtool` is only computing the hash. It neither publishes the file to IPFS nor connects to IPFS.

**Advanced usage**

If you’re feeling fancy, you may also run:

    srtool bash

and look around the `/srtool` folder.

## User Scripts

You can see the list of available scripts in the `/scripts` folder:

-   `help`: Show some help.

-   `version`: Show some version.

-   `info`: Show available system info before running a build.

-   `build`: Run the actual build.

-   `scan`: Scan a repo for runtimes

The `info` and `version` scripts pass any arguments you pass to the script to `jq`. So you can play with `c` (compact), `-M` (monochrome), `-C` color output. For instance `docker run --rm -it -v $PWD:/build chevdor/srtool:1.74.0 info -cM` shows a monochrome output on a single line.

## Build your custom chain / parachain

Building the runtime for your custom chain may not work with the default used for Kusama, Polkadot and Co.
You can however help `srtool` make the right choices using ENV VARs. You will need to make a new alias as shown below.

Here’s how to build the runtime for the substrate-node-template, for instance:

    alias mysrtool='docker run --rm -it --name mysrtool -e RUNTIME_DIR=runtime -e BUILD_OPTS=" " -e PACKAGE=$PACKAGE -v $PWD:/build -v /tmp/cargo:/cargo-home chevdor/srtool:$RUSTC_VERSION'

`BUILD_OPTS` is set to a space, not an empty string.

Using `srtool-cli` makes the above much easier…​

## Export the runtime

To easily export your runtime, it will be copied in the container into the `/out` folder.
If you mount this docker volume, you will find the wasm on your local filesystem once the run is complete.

    docker run ... -v /tmp/out:/out ...

## Scan

`srtool` includes a command that helps finding runtimes in a repo.

        REPO=/projects/polkadot-sdk
        # or
        # REPO=fellowship-runtimes
        podman run --rm -it \
            -v $REPO:/build \
            `paritytech/srtool:1.74.0-0.13.0` scan

## ZSH/ Zinit users

If you’re using `zsh` and `zinit`, you may benefit from using the srtool snippet maintained [here](https://gitlab.com/chevdor/dotfiles/-/tree/master/zsh-plugins).

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

So say you want to build a builder for rustc 1.74.0:

        RUSTC_VERSION=1.74.0 && docker build --build-arg RUSTC_VERSION=$RUSTC_VERSION -t paritytech/srtool:$RUSTC_VERSION .
