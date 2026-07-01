#!/usr/bin/env bash
# Minimal reproduction of the openssl@3 source-build / postinstall failure that breaks
# the test-linux CI. Runs inside the same container image as the real workflow, but only
# installs openssl@3 (not the whole Brewfile), so it finishes in ~10 min on a real amd64
# runner instead of the multi-hour full install. Investigates WHY the source build and/or
# post_install fails when HOMEBREW_PREFIX is the (intentional) non-standard /home/user/.linuxbrew.
set -uo pipefail

export HOMEBREW_PREFIX=/home/user/.linuxbrew
export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_DEVELOPER=1   # print backtraces on post_install failure (non-interactive)

sec() { echo; echo "==================== $* ===================="; }

sec "environment"
echo "arch: $(uname -m)"; echo "prefix: ${HOMEBREW_PREFIX}"

sec "install brew at custom prefix"
git clone --depth 1 https://github.com/Homebrew/brew "${HOMEBREW_PREFIX}/Homebrew"
mkdir -p "${HOMEBREW_PREFIX}/bin"
ln -fs "${HOMEBREW_PREFIX}/Homebrew/bin/brew" "${HOMEBREW_PREFIX}/bin"
eval "$("${HOMEBREW_PREFIX}/bin/brew" shellenv)"
brew update

sec "brew install openssl@3"
brew install openssl@3
INSTALL_RC=$?
echo ">>> install exit: ${INSTALL_RC}"

if [[ ${INSTALL_RC} -ne 0 ]]; then
  sec "install FAILED -- dumping openssl build/test log"
  LOG=$(ls -t "${HOMEBREW_PREFIX}"/../.cache/Homebrew/Logs/openssl@3/*.log 2>/dev/null | head -1)
  LOG=${LOG:-$(ls -t /home/user/.cache/Homebrew/Logs/openssl@3/*.log 2>/dev/null | head -1)}
  echo "log: ${LOG}"
  # show the first failing test and any non-zero exit codes (e.g. 132 = SIGILL)
  grep -nE "not ok |Could not open|Failed test|=> [0-9]+$|Result:|FAILED--" "${LOG}" 2>/dev/null | head -40
fi

OPENSSLDIR="${HOMEBREW_PREFIX}/etc/openssl@3"
sec "state after install"
ls -la "${OPENSSLDIR}" 2>&1 || echo "!!! openssldir missing"
echo ">>> cert.pem resolves to: $(readlink -f "${OPENSSLDIR}/cert.pem" 2>&1)"
echo ">>> ca-certificates pkgetc:"; ls -la "${HOMEBREW_PREFIX}/etc/ca-certificates/" 2>&1 || true

sec "re-run post_install with backtrace (the real error)"
brew postinstall --verbose openssl@3 </dev/null
echo ">>> postinstall exit: $?"
echo ">>> cert.pem resolves to: $(readlink -f "${OPENSSLDIR}/cert.pem" 2>&1)"

sec "TLS verify with brew's own openssl"
OB="${HOMEBREW_PREFIX}/opt/openssl@3/bin/openssl"
if [[ -x "${OB}" ]]; then
  "${OB}" version
  "${OB}" version -d
  echo | "${OB}" s_client -connect github.com:443 -servername github.com 2>&1 \
    | grep -iE "verify (return|error)|self.signed|unable to get" | head -5
else
  echo "!!! ${OB} not present (install did not complete)"
fi

sec "DONE"
