#!/usr/bin/env bash

# Install homebrew
if [[ ${HOMEBREW_PREFIX} == "/usr/local" ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  git clone --depth 1 https://github.com/Homebrew/brew "${HOMEBREW_PREFIX}/Homebrew"
  mkdir -p "${HOMEBREW_PREFIX}/bin"
  ln -fs "${HOMEBREW_PREFIX}/Homebrew/bin/brew" "${HOMEBREW_PREFIX}/bin"
  eval "$("${HOMEBREW_PREFIX}/bin/brew" shellenv)"
fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Remove outdated versions from the cellar.
brew cleanup
