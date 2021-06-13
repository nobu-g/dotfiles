#!/usr/bin/env bash

set -u

here=$(dirname "${BASH_SOURCE[0]:-$0}")

case "${OSTYPE}" in
linux* | cygwin*)
  BREW_SETUP_DIR="$here/linux"
  ;;
freebsd* | darwin*)
  xcode-select --install
  BREW_SETUP_DIR="$here/macos"
  ;;
esac

# install Homebrew/Linuxbrew
if ! [[ -e ${HOMEBREW_PREFIX}/bin/brew ]]; then
  bash -x "${BREW_SETUP_DIR}/init.sh"
fi

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
