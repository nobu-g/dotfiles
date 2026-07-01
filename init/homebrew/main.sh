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
