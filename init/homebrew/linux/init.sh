#!/usr/bin/env bash

set -eu

# Install Linuxbrew
git clone --depth 1 https://github.com/Homebrew/brew "${HOMEBREW_PREFIX}/Homebrew"
mkdir -p "${HOMEBREW_PREFIX}/bin"
ln -fs "${HOMEBREW_PREFIX}/Homebrew/bin/brew" "${HOMEBREW_PREFIX}/bin"
# eval "$("${HOMEBREW_PREFIX}/bin/brew" shellenv)"
