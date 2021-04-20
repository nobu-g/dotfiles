#!/usr/bin/env bash

# Install linuxbrew
git clone --depth 1 https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew
mkdir -p ~/.linuxbrew/bin
ln -fs ~/.linuxbrew/Homebrew/bin/brew ~/.linuxbrew/bin
eval "$(~/.linuxbrew/bin/brew shellenv)"

# Make sure we’re using the latest Linuxbrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Remove outdated versions from the cellar.
brew cleanup
