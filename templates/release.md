## Description

The SRTOOL Docker image has been tagged as:

- `{{ REPO }}:{{ RUSTC_VERSION }}`
- `{{ REPO }}:{{ RUSTC_VERSION }}-{{ SRTOOL_VERSION }}`

You can find it on [Docker Hub](https://hub.docker.com/r/{{ REPO }}).

Prefer using `{{ REPO }}:{{ RUSTC_VERSION }}` unless you **really must** pin a specific version or use an ancient version for some reason. Specifying the version (`{{ SRTOOL_VERSION }}`) is not recommended.

{{ CHANGELOG }}
