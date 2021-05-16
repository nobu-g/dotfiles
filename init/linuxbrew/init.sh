#!/usr/bin/env bash

# Install linuxbrew
git clone --depth 1 https://github.com/Homebrew/brew "${HOMEBREW_PREFIX}/Homebrew"
mkdir -p "${HOMEBREW_PREFIX}/bin"
ln -fs "${HOMEBREW_PREFIX}/Homebrew/bin/brew" "${HOMEBREW_PREFIX}/bin"
eval "$("${HOMEBREW_PREFIX}/bin/brew" shellenv)"

# Make sure we’re using the latest Linuxbrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Remove outdated versions from the cellar.
brew cleanup
