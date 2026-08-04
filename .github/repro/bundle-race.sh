#!/usr/bin/env bash
# Temporary repro/verification script for the test-linux debugging (see the
# `debug-actions-test-linux` skill). MODE selects the scenario:
#   race  -> API-mode install of openssl@3 (reproduces the postinstall failure)
#   noapi -> the fix candidate: mirror init/homebrew/main.sh with
#            HOMEBREW_NO_INSTALL_FROM_API=1 and verify postinstall + cert.pem + TLS.
# DELETE together with the repro workflow once the fix lands in main.sh.
set -uo pipefail

export HOMEBREW_PREFIX=/home/user/.linuxbrew
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_ANALYTICS=1

MODE="${MODE:-noapi}"
sec() { echo; echo "==================== $* ===================="; }
sec "MODE=${MODE}  arch=$(uname -m)"

git clone --depth 1 https://github.com/Homebrew/brew "${HOMEBREW_PREFIX}/Homebrew"
mkdir -p "${HOMEBREW_PREFIX}/bin"
ln -fs "${HOMEBREW_PREFIX}/Homebrew/bin/brew" "${HOMEBREW_PREFIX}/bin"
eval "$("${HOMEBREW_PREFIX}/bin/brew" shellenv)"

if [[ "${MODE}" == "noapi" ]]; then
  export HOMEBREW_NO_INSTALL_FROM_API=1
  export HOMEBREW_CURL_PATH=/home/user/dotfiles/init/homebrew/linux/curl-ftpmirror-fallback.sh
fi
export HOMEBREW_DOWNLOAD_CONCURRENCY=1
export HOMEBREW_CURL_RETRIES=3

sec "brew update (clones homebrew/core when NO_INSTALL_FROM_API=1)"
brew update
echo ">>> brew update exit: $?"

sec "brew trust nobu-g/tap/stderred (tap clone via system git)"
brew trust --formula nobu-g/tap/stderred
echo ">>> brew trust exit: $?"

sec "brew install openssl@3 (source build; postinstall must succeed)"
brew install openssl@3
install_exit=$?
echo ">>> install exit: ${install_exit}"

sec "cert.pem state (must be a symlink to ca-certificates)"
ls -l "${HOMEBREW_PREFIX}/etc/openssl@3/cert.pem"
cert_exit=$?

sec "brew bundle install --jobs 1 (small Brewfile)"
cat > /tmp/Brewfile <<'EOF'
brew "cmake"
brew "curl"
brew "wget"
EOF
brew bundle install --jobs 1 --file /tmp/Brewfile
bundle_exit=$?
echo ">>> bundle exit: ${bundle_exit}"

sec "brewed curl TLS test (the exact op that failed in CI)"
curl_exit=0
BREW_CURL="${HOMEBREW_PREFIX}/opt/curl/bin/curl"
if [[ -x ${BREW_CURL} ]]; then
  "${BREW_CURL}" -sSfI https://github.com | head -3
  curl_exit=$?
  echo ">>> brewed curl exit: ${curl_exit}"
else
  echo ">>> brewed curl missing"
  curl_exit=1
fi

sec "RESULT"
echo "install=${install_exit} cert=${cert_exit} bundle=${bundle_exit} curl=${curl_exit}"
[[ ${install_exit} -eq 0 && ${cert_exit} -eq 0 && ${bundle_exit} -eq 0 && ${curl_exit} -eq 0 ]]
