#!/usr/bin/env bash

set -u

# https://wonderwall.hatenablog.com/entry/rust-command-line-tools

# crates installed via zinit:
#   ripgrep, fd, bat, delta

cargo install cargo-cache   # cargo cache cleaner
cargo install cargo-edit    # Utility for managing cargo dependencies from the command-line
# cargo install mcfly     # better history search
