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

if [[ "${MODE}" == "hardened" ]]; then
  export HOMEBREW_BUNDLE_NO_JOBS=1
  sec "hardened: mirror main.sh (pre-install + explicit cert.pem link)"
  brew install ca-certificates openssl@3
  brew postinstall openssl@3 || true
  # capture the real post_install error for the record
  sec "post_install error log (root-cause evidence)"
  cat /home/user/.cache/Homebrew/Logs/openssl@3/post_install.* 2>/dev/null | tail -30 || echo "(no post_install log)"
  ln -sf ../ca-certificates/cert.pem "${HOMEBREW_PREFIX}/etc/openssl@3/cert.pem"
  echo ">>> cert.pem after explicit link: $(readlink -f "${HOMEBREW_PREFIX}/etc/openssl@3/cert.pem" 2>&1)"
fi

sec "brew bundle install"
brew bundle install --file /tmp/Brewfile
echo ">>> bundle exit: $?"

sec "openssl / cert health after bundle"
echo ">>> cert.pem resolves to: $(readlink -f "${HOMEBREW_PREFIX}/etc/openssl@3/cert.pem" 2>&1)"
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
