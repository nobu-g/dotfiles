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
# Point brew's toolchain (curl/git/openssl) at the OS CA bundle. With a non-default
# HOMEBREW_PREFIX, openssl@3/ca-certificates are built from source and their post_install
# (which is what normally links the CA bundle into openssl's cert.pem) is unreliable; when it
# doesn't run, brew's curl/git cannot verify TLS ("unable to get local issuer certificate")
# and every later download fails or hangs. brew's setup_ca_certificates honours these env
# vars and only overrides them when it force-brews CA certs (not on Linux), so this fixes TLS
# via env alone, without depending on the flaky post_install or touching any cert.pem.
for _ca in /etc/ssl/certs/ca-certificates.crt \
  /etc/pki/tls/certs/ca-bundle.crt \
  /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem \
  /etc/ssl/ca-bundle.pem; do
  if [[ -f ${_ca} ]]; then
    export SSL_CERT_FILE="${_ca}" GIT_SSL_CAINFO="${_ca}"
    break
  fi
done
# Pre-build openssl@3 so `brew bundle` doesn't build it as a dependency mid-run: its
# post_install exits non-zero on a source build, which would fail the bundle formula that
# triggered the build. The warning here is harmless — SSL_CERT_FILE already provides the CA
# bundle — so ignore the non-zero exit.
brew install openssl@3 || true
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
