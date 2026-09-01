#!/usr/bin/env bash

set -xu

# Environment variables:
# - HOMEBREW_PREFIX: directory where Homebrew and its dependencies are installed
# - SUDO: 1 if the user has sudo previledge and wants to exercise it
# - FULL_INSTALL: 1 if the user wants to install all the Homebrew dependencies

here=$(dirname "${BASH_SOURCE[0]:-$0}")

mkdir -p "${HOME}"/{.config,scripts,.local,.zsh}
mkdir -p "${HOME}"/.local/{bin,share,lib,include,src}
mkdir -p "${HOME}"/.local/share/{node,shell,less,python}
mkdir -p "${HOME}"/.cache/zsh

# install Homebrew and its packages
case "${OSTYPE}" in
  linux* | cygwin*)
    HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-"${HOME}/.linuxbrew"}
    ;;
  freebsd* | darwin*)
    if [[ $(uname -m) == "arm64" ]]; then
      HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-"/opt/homebrew"}
    else
      # x86_64
      HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-"/usr/local"}
    fi
    ;;
esac
# Stop here if Homebrew setup fails: without brew, every later step (shellenv,
# packages, tools) errors in confusing ways. This script has no `set -e`, so
# the failure would otherwise cascade silently.
bash -x "$here/homebrew/main.sh" || exit 1
eval "$("${HOMEBREW_PREFIX}/bin/brew" shellenv)"
case "${OSTYPE}" in
  linux* | cygwin*)
    export INFOPATH="${HOMEBREW_PREFIX}/share/info:/usr/local/share/info:/usr/share/info"
    ;;
esac

# set the login shell to zsh
bash "$here/setup-shell.sh"

case "${OSTYPE}" in
  freebsd* | darwin*)
    bash -x "$here/setup-defaults.sh"
    ;;
esac

DOOM_EMACS_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/emacs"
if [[ ! -x ${DOOM_EMACS_DIR}/bin/doom ]]; then
  git clone --depth 1 https://github.com/doomemacs/doomemacs "${DOOM_EMACS_DIR}" || exit 1
fi
ln -snfv "$(dirname "${here}")/.config/doom" "${XDG_CONFIG_HOME:-${HOME}/.config}/doom" &&
  "${DOOM_EMACS_DIR}/bin/doom" -! install --no-config || exit 1

# install Rust and its packages
export RUSTUP_INIT_SKIP_PATH_CHECK="yes"
if ! [[ -x ${HOME}/.cargo/bin/cargo ]]; then
  # https://www.rust-lang.org/tools/install
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi
export PATH="${HOME}/.cargo/bin:${PATH}"
if (type cargo &> /dev/null); then
  bash -x "$here/rust-packages.sh"
fi

# install Zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if ! [[ -d ${ZINIT_HOME} ]]; then
  mkdir -p "$(dirname "${ZINIT_HOME}")"
  git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}"
fi

# install Python packages
bash -x "$here/python-packages.sh"

# install Go packages
if (type go &> /dev/null); then
  go install github.com/itchyny/fillin@latest
  go install golang.org/x/tools/gopls@latest # or brew install gopls
fi

# install Claude Code
curl -fsSL https://claude.ai/install.sh | bash

# install iTerm2 shell integration
ZDOTDIR="${ZDOTDIR:-${HOME}/.zsh}"
ITERM2_SHELL_INTEGRATION_RC_URL="https://iterm2.com/shell_integration/zsh"
ITERM2_SHELL_INTEGRATION_RC="${ZDOTDIR}/.iterm2_shell_integration.zsh"
if ! [[ -f ${ITERM2_SHELL_INTEGRATION_RC} ]]; then
  echo "Downloading script from ${ITERM2_SHELL_INTEGRATION_RC_URL} and saving it to ${ITERM2_SHELL_INTEGRATION_RC}..."
  curl -SsL "${ITERM2_SHELL_INTEGRATION_RC_URL}" > "${ITERM2_SHELL_INTEGRATION_RC}" &&
    chmod +x "${ITERM2_SHELL_INTEGRATION_RC}" ||
    echo "Couldn't download script from ${ITERM2_SHELL_INTEGRATION_RC_URL}" 1>&2
fi
