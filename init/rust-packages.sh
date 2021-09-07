#!/usr/bin/env bash

set -u

# https://wonderwall.hatenablog.com/entry/rust-command-line-tools

# crates installed via zinit:
#   ripgrep, fd, bat, delta
# crates installed via homebrew:
#   xsv, lsd, fd, ripgrep, ripgrep-all, procs, sd, hyperfine, pastel, du-dust, hexyl, broot

cargo install gping         # Ping, but with a graph
cargo install watchexec-cli # monitor file change
cargo install pueue         # process queue
cargo install cargo-cache   # cargo cache cleaner
# cargo install mcfly     # better history search
