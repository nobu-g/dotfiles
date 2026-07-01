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
# With a non-default HOMEBREW_PREFIX, openssl@3 has no usable bottle and is built from
# source. Its post_install (which symlinks the ca-certificates CA bundle into openssl's
# openssldir) fails intermittently on a source build, and *always* under a parallel
# `brew bundle` where multiple jobs race on this shared dependency. When it fails,
# ${HOMEBREW_PREFIX}/etc/openssl@3/cert.pem is never created, so brew's own curl/git can no
# longer verify TLS ("unable to get local issuer certificate") and the rest of the install
# fails or hangs. Install openssl@3 first, on its own, then link the CA bundle ourselves so
# we don't depend on the flaky post_install.
brew install ca-certificates openssl@3
brew postinstall openssl@3 || true
ln -sf ../ca-certificates/cert.pem "${HOMEBREW_PREFIX}/etc/openssl@3/cert.pem"
# Serialize installs (default is parallel up to 4). Parallel formulae race on the shared
# openssl@3 dependency and the download cache lock ("process has already locked
# ...incomplete"), corrupting the openssl@3 post_install and hanging the build.
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
