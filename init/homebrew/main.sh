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
case "${OSTYPE}" in
  linux* | cygwin*)
    # On Linux the non-standard HOMEBREW_PREFIX forces most formulae to build from
    # source, and Homebrew's JSON-API install path cannot handle that at scale:
    #  - the postinstall child process fails to resolve formulae through the internal
    #    API manifest (FormulaUnavailableError on "packages.<arch>.jws.json"), so every
    #    source-built formula with a post_install step exits non-zero; openssl@3 then
    #    never links cert.pem and all later TLS in brewed git/curl breaks,
    #  - per-formula .rb source downloads race on the download-cache lock ("process has
    #    already locked ....rb.incomplete") or fail silently ("<formula> source code
    #    not found at .../api-source/...").
    # Loading formulae from a full homebrew/core tap clone bypasses that machinery.
    # Exporting SSL_CERT_FILE etc. instead does not work: bin/brew re-executes itself
    # via `env -i` and only lets HOMEBREW_* and a small allowlist through.
    export HOMEBREW_NO_INSTALL_FROM_API=1
    # Route brew's downloads through a wrapper that falls back from the unreliable
    # ftpmirror.gnu.org redirector to the canonical ftp.gnu.org (see the wrapper).
    HOMEBREW_CURL_PATH="$(cd "${BREW_SETUP_DIR}" && pwd)/curl-ftpmirror-fallback.sh"
    export HOMEBREW_CURL_PATH
    ;;
esac
# Download in serial. When building from source, the default parallel downloader
# (HOMEBREW_DOWNLOAD_CONCURRENCY=auto) races on the shared download-cache lock of common
# transitive deps, which aborts the install.
export HOMEBREW_DOWNLOAD_CONCURRENCY=1
# Retry transient download failures (observed 502/504 bursts from ghcr.io and mirrors).
export HOMEBREW_CURL_RETRIES=3
brew update
brew trust --formula nobu-g/tap/stderred
# Install formulae one at a time. `brew bundle`'s default is HOMEBREW_BUNDLE_JOBS=auto
# (parallel up to 4 CPUs); parallel jobs race on shared source-built dependencies and their
# download-cache locks and hang the build. `--jobs 1` is authoritative (an explicit flag
# cannot be overridden by env) and forces sequential; the env var HOMEBREW_BUNDLE_JOBS=1 does
# not reliably take effect.
brew bundle install --jobs 1 --file "${here}/Brewfile"
brew bundle install --jobs 1 --file "${BREW_SETUP_DIR}/Brewfile"
if [[ ${FULL_INSTALL} -eq 1 ]]; then
  brew bundle install --jobs 1 --file "${here}/Brewfile.full"
  brew bundle install --jobs 1 --file "${BREW_SETUP_DIR}/Brewfile.full"
fi
echo "Installed formulae and casks:"
brew list
