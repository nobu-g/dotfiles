#!/usr/bin/env bash

set -ux

# https://wonderwall.hatenablog.com/entry/rust-command-line-tools

# crates installed with zinit
# ripgrep, fd, bat, exa, delta

cargo install hyperfine # comman-line benchmark tool
cargo install xsv
cargo install bandwidth     # Terminal bandwidth utilization tool
cargo install gping         # Ping, but with a graph
cargo install hexyl         # A command-line hex viewer
cargo install broot         # A new way to see and navigate directory trees
cargo install pastel        # color manipulation
cargo install watchexec-cli # monitor file change
cargo install du-dust       # A more intuitive version of du in rust
cargo install pueue         # process queue
# cargo install mcfly     # better history search
