#!/usr/bin/env bash

set -u

# https://wonderwall.hatenablog.com/entry/rust-command-line-tools

# crates installed via zinit:
#   ripgrep, fd, bat, delta
# crates installed via homebrew:
#   xsv, lsd, fd, ripgrep, ripgrep-all, procs, sd, hyperfine, pastel, du-dust

cargo install gping         # Ping, but with a graph
cargo install hexyl         # A command-line hex viewer
cargo install broot         # A new way to see and navigate directory trees
cargo install watchexec-cli # monitor file change
cargo install pueue         # process queue
# cargo install mcfly     # better history search
cargo install cargo-cache # cargo cache cleaner
