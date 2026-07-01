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
# Download in serial. At this non-standard HOMEBREW_PREFIX everything is built from source,
# and the default parallel downloader (HOMEBREW_DOWNLOAD_CONCURRENCY=auto) races on the
# shared download-cache lock of common transitive deps, e.g. "A `brew install --formula
# curl` process has already locked ...m4.rb.incomplete", which aborts the install.
export HOMEBREW_DOWNLOAD_CONCURRENCY=1
# With a non-default HOMEBREW_PREFIX, openssl@3 has no usable bottle and is built from
# source. openssl@3's post_install links the CA bundle into
# ${HOMEBREW_PREFIX}/etc/openssl@3/cert.pem; without it, brew's own curl/git cannot verify
# TLS ("unable to get local issuer certificate") and every later download fails or hangs.
# That post_install fails when it runs inside the same `brew install` that builds the keg
# (the just-built ca-certificates dependency isn't resolvable yet), but a standalone re-run
# succeeds. So install openssl@3 first, then re-run its post_install on its own.
brew install openssl@3
brew postinstall openssl@3
# Install formulae one at a time. `brew bundle`'s default is HOMEBREW_BUNDLE_JOBS=auto
# (parallel up to 4 CPUs); parallel jobs race on shared source-built dependencies and their
# download-cache locks, corrupting openssl@3's post_install and hanging the build. `--jobs 1`
# is authoritative (an explicit flag cannot be overridden by env) and forces sequential.
brew bundle install --jobs 1 --file "${here}/Brewfile"
brew bundle install --jobs 1 --file "${BREW_SETUP_DIR}/Brewfile"
if [[ ${FULL_INSTALL} -eq 1 ]]; then
  brew bundle install --jobs 1 --file "${here}/Brewfile.full"
  brew bundle install --jobs 1 --file "${BREW_SETUP_DIR}/Brewfile.full"
fi
echo "Installed formulae and casks:"
brew list
