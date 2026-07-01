#!/usr/bin/env bash
# Tests the hypothesis that the openssl@3 postinstall failure on test-linux is caused by
# `brew bundle` installing formulae in PARALLEL, so multiple jobs race on the shared
# openssl@3 dependency and its download-cache lock (see the "process has already locked
# ...incomplete" errors in the old CI log). At the non-standard HOMEBREW_PREFIX every
# formula is built from source, which widens the race window.
#
#   MODE=race   -> default parallel bundle (reproduces the failure)
#   MODE=fixed  -> serialize (HOMEBREW_BUNDLE_NO_JOBS=1) + pre-install openssl@3 (the fix)
set -uo pipefail

export HOMEBREW_PREFIX=/home/user/.linuxbrew
export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1

MODE="${MODE:-race}"
sec() { echo; echo "==================== $* ===================="; }
sec "MODE=${MODE}  arch=$(uname -m)"

git clone --depth 1 https://github.com/Homebrew/brew "${HOMEBREW_PREFIX}/Homebrew"
mkdir -p "${HOMEBREW_PREFIX}/bin"
ln -fs "${HOMEBREW_PREFIX}/Homebrew/bin/brew" "${HOMEBREW_PREFIX}/bin"
eval "$("${HOMEBREW_PREFIX}/bin/brew" shellenv)"
brew update

# Minimal Brewfile: three formulae that all depend on openssl@3 (mirrors the head of the
# real Brewfile: cmake, curl, wget). Parallel bundle makes them race on openssl@3.
cat > /tmp/Brewfile <<'EOF'
brew "cmake"
brew "curl"
brew "wget"
EOF

if [[ "${MODE}" == "fixed" ]]; then
  export HOMEBREW_BUNDLE_NO_JOBS=1
  sec "fix: pre-install + postinstall openssl@3 serially"
  brew install openssl@3
  brew postinstall openssl@3
fi

if [[ "${MODE}" == "envonly" ]]; then
  # Minimal candidate: serialize BOTH parallelism sources via env vars only. No pre-install,
  # no cert.pem manipulation. Tests whether the openssl@3 post_install succeeds on its own
  # once nothing races with it.
  export HOMEBREW_DOWNLOAD_CONCURRENCY=1
  export HOMEBREW_BUNDLE_JOBS=1
  sec "envonly: env vars only (HOMEBREW_DOWNLOAD_CONCURRENCY=1, HOMEBREW_BUNDLE_JOBS=1)"
fi

if [[ "${MODE}" == "hardened" ]]; then
  export HOMEBREW_DOWNLOAD_CONCURRENCY=1
  sec "hardened: mirror main.sh (pre-install openssl@3 + link cert.pem to OS CA bundle)"
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
  echo ">>> cert.pem after explicit link: $(readlink -f "${HOMEBREW_PREFIX}/etc/openssl@3/cert.pem" 2>&1)"
fi

sec "brew bundle install"
if [[ "${MODE}" == "hardened" ]]; then
  brew bundle install --jobs 1 --file /tmp/Brewfile
else
  brew bundle install --file /tmp/Brewfile
fi
echo ">>> bundle exit: $?"

sec "openssl / cert health after bundle"
echo ">>> cert.pem raw: $(ls -l "${HOMEBREW_PREFIX}/etc/openssl@3/cert.pem" 2>&1)"
echo ">>> cert.pem resolves to: $(readlink -f "${HOMEBREW_PREFIX}/etc/openssl@3/cert.pem" 2>&1)"
if [[ ! -e "${HOMEBREW_PREFIX}/etc/openssl@3/cert.pem" ]]; then
  sec "cert.pem MISSING -- openssl@3 post_install log (diagnosis)"
  cat /home/user/.cache/Homebrew/Logs/openssl@3/post_install*.log 2>/dev/null | tail -40 || echo "(no post_install log)"
fi
BREW_CURL="${HOMEBREW_PREFIX}/opt/curl/bin/curl"
if [[ -x "${BREW_CURL}" ]]; then
  echo ">>> brew curl HTTPS test (the exact op that failed in CI):"
  "${BREW_CURL}" -sSfI https://github.com 2>&1 | head -3
  echo ">>> brew curl exit: $?"
fi
OB="${HOMEBREW_PREFIX}/opt/openssl@3/bin/openssl"
[[ -x "${OB}" ]] && echo | "${OB}" s_client -connect github.com:443 -servername github.com 2>&1 \
  | grep -iE "verify (return|error)|unable to get" | head -3

sec "DONE"
