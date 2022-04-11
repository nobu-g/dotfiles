#!/usr/bin/env bash

set -euo pipefail

# Install Homebrew
if { [[ $(uname -m) == "arm64" ]] && [[ ${HOMEBREW_PREFIX} == "/opt/homebrew" ]]; } \
  || { [[ $(uname -m) == "x86_64" ]] && [[ ${HOMEBREW_PREFIX} == "/usr/local" ]]; }; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  git clone --depth 1 https://github.com/Homebrew/brew "${HOMEBREW_PREFIX}/Homebrew"
  mkdir -p "${HOMEBREW_PREFIX}/bin"
  ln -fs "${HOMEBREW_PREFIX}/Homebrew/bin/brew" "${HOMEBREW_PREFIX}/bin"
fi
