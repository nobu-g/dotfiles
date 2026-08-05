#!/usr/bin/env bash

set -u

here=$(dirname "${BASH_SOURCE[0]:-$0}")

case "${OSTYPE}" in
  linux* | cygwin*)
    BREW_SETUP_DIR="${here}/linux"
    ;;
  freebsd* | darwin*)
    xcode-select -p &> /dev/null || xcode-select --install
    BREW_SETUP_DIR="${here}/macos"
    ;;
esac

# install Homebrew/Linuxbrew
if ! [[ -e ${HOMEBREW_PREFIX}/bin/brew ]]; then
  bash -x "${BREW_SETUP_DIR}/init.sh"
fi
eval "$("${HOMEBREW_PREFIX}/bin/brew" shellenv)"

# install dependencies from Brewfile
#
# The settings below work around Homebrew failure modes that a non-default
# HOMEBREW_PREFIX (mass source builds) exposes; background and evidence are in
# .claude/skills/debug-actions-test-linux/SKILL.md.
case "${OSTYPE}" in
  linux* | cygwin*)
    # The JSON-API install path breaks post_install for source-built formulae;
    # load formulae from a homebrew/core tap clone instead.
    export HOMEBREW_NO_INSTALL_FROM_API=1
    # Reroute unreliable GNU download hosts to the kernel.org mirror.
    HOMEBREW_CURL_PATH="$(cd "${BREW_SETUP_DIR}" && pwd)/curl-gnu-mirror.sh"
    export HOMEBREW_CURL_PATH
    ;;
esac
export HOMEBREW_DOWNLOAD_CONCURRENCY=1 # parallel downloads race on cache locks
export HOMEBREW_CURL_RETRIES=3
export HOMEBREW_NO_INSTALL_CLEANUP=1 # cleanup deletes caches later formulae need
export HOMEBREW_NO_AUTO_UPDATE=1
brew update
brew trust --formula nobu-g/tap/stderred

# --jobs 1: parallel jobs race on shared deps. Retry once: bottles are sometimes
# poured before fully downloaded (https://github.com/Homebrew/brew/issues/15957).
bundle_install() {
  brew bundle install --jobs 1 --file "$1" ||
    brew bundle install --jobs 1 --file "$1"
}
bundle_install "${here}/Brewfile"
bundle_install "${BREW_SETUP_DIR}/Brewfile"
if [[ ${FULL_INSTALL} -eq 1 ]]; then
  bundle_install "${here}/Brewfile.full"
  bundle_install "${BREW_SETUP_DIR}/Brewfile.full"
fi
echo "Installed formulae and casks:"
brew list
