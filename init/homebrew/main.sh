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
brew trust --formula nobu-g/tap/stderred
# Serialize installs (default is parallel up to 4). With a non-default HOMEBREW_PREFIX
# everything is built from source, and parallel formulae race on the shared download
# cache lock ("process has already locked ...incomplete"), failing the build.
# HOMEBREW_BUNDLE_JOBS=1 did not actually serialize; NO_JOBS is the documented toggle
# that disables parallel jobs entirely.
export HOMEBREW_BUNDLE_NO_JOBS=1
brew bundle install --file "${here}/Brewfile"
brew bundle install --file "${BREW_SETUP_DIR}/Brewfile"
if [[ ${FULL_INSTALL} -eq 1 ]]; then
  brew bundle install --file "${here}/Brewfile.full"
  brew bundle install --file "${BREW_SETUP_DIR}/Brewfile.full"
fi
echo "Installed formulae and casks:"
brew list
