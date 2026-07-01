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
# source. The post_install of a source build fails intermittently for both openssl@3 and
# ca-certificates (and *always* under a parallel `brew bundle`, where jobs race on these
# shared dependencies). openssl@3's post_install is what links the CA bundle into
# ${HOMEBREW_PREFIX}/etc/openssl@3/cert.pem; when it does not run, brew's own curl/git can
# no longer verify TLS ("unable to get local issuer certificate") and every subsequent
# download fails or hangs.
#
# Install openssl@3 on its own line first (the keg builds fine even when its post_install
# warns), then link its cert.pem straight to the OS CA bundle — the same store
# ca-certificates bootstraps from — so we never depend on either flaky post_install.
brew install openssl@3
brew postinstall openssl@3 || true
mkdir -p "${HOMEBREW_PREFIX}/etc/openssl@3"
for _ca in /etc/ssl/certs/ca-certificates.crt \
  /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem \
  /etc/ssl/ca-bundle.pem; do
  if [[ -f ${_ca} ]]; then
    ln -sf "${_ca}" "${HOMEBREW_PREFIX}/etc/openssl@3/cert.pem"
    break
  fi
done
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
