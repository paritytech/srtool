# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

srtool (Substrate Runtime Toolbox) is a Docker-based tool for building WASM runtimes for the Polkadot Network deterministically. It produces identical WASM runtime builds across different machines via a containerized environment (Ubuntu 22.04 + pinned Rust version).

The Docker image is published to `paritytech/srtool` on Docker Hub with tags like `$RUSTC_VERSION-$SRTOOL_VERSION`.

## Key Files

- `VERSION` — srtool version (e.g., 0.18.4)
- `RUSTC_VERSION` — Rust toolchain version pinned for deterministic builds (e.g., 1.93.0)
- `Dockerfile` — Container image definition
- `justfile` — Build automation (uses `just`, not `make`)

## Build & Test Commands

All automation uses `just` (not make):

```bash
just build          # Build Docker image
just test_quick     # Run quick container structure tests
just test_acl       # Run ACL/permissions tests
just test_long      # Run extended tests
just test_commands  # Test command execution
just test_all       # Run all test suites
just publish        # Build and push to Docker Hub
just scan           # Vulnerability scan with trivy
just md             # Convert README_src.adoc → README.md via asciidoctor
just info           # Show version info
```

Tests use `container-structure-test` (Google's tool) with YAML test definitions in `tests/`. These validate the Docker image structure: file existence, user/group IDs, environment variables, volumes, and commands.

## Architecture

### Docker Image

The image runs as user `builder` (UID/GID 1001). Key volumes:
- `/build` — Project source (mounted from host)
- `/home/builder/cargo` — Cargo cache
- `/out` — Exported runtime artifacts

Entry point is `/srtool/build`. The `scripts/` directory is copied into the image at `/srtool/`.

### Scripts (`scripts/`)

- **`build`** — Main entry point. Builds the WASM runtime, produces JSON output with hashes (proposal hash, IPFS, SHA256).
- **`lib.sh`** — Shared utilities: `vercomp()` for semver comparison, `find_runtimes()` for discovering runtimes in a repo, `get_runtime_package_version()`.
- **`info`** — Prints pre-build info (git state, package, rustc version).
- **`version`** — Prints tool versions (srtool, rustc, subwasm, tera, toml).
- **`scan`** — Discovers all runtimes in a repository, outputs JSON matrix for GitHub Actions.
- **`getBuildOpts.sh`** — Determines build features based on package name and version (e.g., `--features on-chain-release-build` for Kusama/Polkadot v0.8.30+).

### Key Environment Variables (inside container)

- `PACKAGE` — Runtime package name (default: `polkadot-runtime`)
- `RUNTIME_DIR` — Path to runtime crate
- `PROFILE` — Build profile (default: `release`)
- `BUILD_OPTS` — Additional cargo build options
- `VERBOSE` — Enable verbose output

### Runtime Discovery

`find_runtimes()` in `lib.sh` searches for crates with names ending in `-runtime` that contain the `#[frame_support::runtime]` macro in their `lib.rs`. Output is a JSON matrix suitable for GitHub Actions parallelization.

## CI/CD Workflows

- **`tests.yml`** — Builds image and runs all test suites on push to master, PRs, and weekly
- **`quick-test.yml`** — Subset of tests for fast feedback
- **`release.yml`** — Triggered by `v*` tags; builds, tests, publishes to Docker Hub, creates GitHub release
- **`manual*.yml`** — Manual workflow_dispatch builds for specific chains (polkadot-sdk, moonbeam, acala, shiden, fellowship runtimes)

## Related Ecosystem

- **srtool-cli** — Rust CLI wrapper for running srtool
- **srtool-actions** — GitHub Actions integration
- **subwasm** — WASM analysis tool (bundled in the image)
