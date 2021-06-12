#!/usr/bin/env bash

set -u

here=$(dirname "${BASH_SOURCE[0]:-$0}")

case "${OSTYPE}" in
linux* | cygwin*)
  export HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-"$HOME/.linuxbrew"}
  BREW_SETUP_DIR="$here/linux"
  ;;
freebsd* | darwin*)
  xcode-select --install
  export HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-"/usr/local"}
  BREW_SETUP_DIR="$here/macos"
  ;;
esac

# install Homebrew/Linuxbrew
if ! [[ -e ${HOMEBREW_PREFIX}/bin/brew ]]; then
  bash -x "${BREW_SETUP_DIR}/init.sh"
fi
eval "$("$HOMEBREW_PREFIX/bin/brew" shellenv)"
brew bundle install --file "$here/Brewfile"
brew bundle install --file "${BREW_SETUP_DIR}/Brewfile"
if [[ ${FULL_INSTALL} -eq 1 ]]; then
  brew bundle install --file "$here/Brewfile.full"
  brew bundle install --file "${BREW_SETUP_DIR}/Brewfile.full"
fi
echo "Installed formulae and casks:"
brew list

case "${OSTYPE}" in
linux* | cygwin*)
  # https://qiita.com/aical/items/5b3ebee3840aae741283
  wget http://curl.haxx.se/ca/cacert.pem -O cert.pem
  mv cert.pem "${HOMEBREW_PREFIX}"/etc/openssl*/
  ;;
esac
