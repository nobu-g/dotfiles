#!/usr/bin/env bash

set -u

here=$(dirname "${BASH_SOURCE[0]:-$0}")

case "${OSTYPE}" in
  linux* | cygwin*)
    BREW_SETUP_DIR="${here}/linux"
    ;;
  freebsd* | darwin*)
    xcode-select --install
    BREW_SETUP_DIR="${here}/macos"
    ;;
esac

# install Homebrew/Linuxbrew
if ! [[ -e ${HOMEBREW_PREFIX}/bin/brew ]]; then
  bash -x "${BREW_SETUP_DIR}/init.sh"
fi
eval "$("${HOMEBREW_PREFIX}/bin/brew" shellenv)"

# install dependencies from Brewfile
brew update
brew bundle install --file "${here}/Brewfile"
brew bundle install --file "${BREW_SETUP_DIR}/Brewfile"
if [[ ${FULL_INSTALL} -eq 1 ]]; then
  brew bundle install --file "${here}/Brewfile.full"
  brew bundle install --file "${BREW_SETUP_DIR}/Brewfile.full"
fi
echo "Installed formulae and casks:"
brew list
