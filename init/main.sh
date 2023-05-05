#!/usr/bin/env bash

set -xu

# Environment variables:
# - HOMEBREW_PREFIX: directory where Homebrew and its dependencies are installed
# - SUDO: 1 if the user has sudo previledge and wants to exercise it
# - FULL_INSTALL: 1 if the user wants to install all the Homebrew dependencies

here=$(dirname "${BASH_SOURCE[0]:-$0}")

mkdir -p "${HOME}"/{.emacs.d,.config,scripts,.local,.zsh}
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
bash -x "$here/homebrew/main.sh"
eval "$("${HOMEBREW_PREFIX}/bin/brew" shellenv)"

# set the login shell to zsh
bash "$here/setup-shell.sh"

case "${OSTYPE}" in
  freebsd* | darwin*)
    bash -x "$here/setup-defaults.sh"
    # install doom-emacs
    if ! (type ~/.config/emacs/bin/doom &> /dev/null); then
      rm -rf ~/.config/emacs &&
        git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs &&
        ln -snfv "$(dirname "${here}")/.config/doom" ~/.config/ &&
        yes | ~/.config/emacs/bin/doom install
    fi
    ;;
esac

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
if (type pipx &> /dev/null); then
  bash -x "$here/python-packages.sh"
fi

# install Go packages
if (type go &> /dev/null); then
  go install github.com/itchyny/fillin@latest
  go install golang.org/x/tools/gopls@latest # or brew install gopls
fi

# # install Docker Compose V2
# DOCKER_CONFIG="${DOCKER_CONFIG:-$HOME/.docker}"
# mkdir -p "${DOCKER_CONFIG}/cli-plugins"
# machine=$(uname -m | sed 's/arm64/aarch64/')
# # https://github.com/docker/compose/releases
# curl -SL "https://github.com/docker/compose/releases/download/v2.17.3/docker-compose-$(uname -s)-${machine}" \
#   -o "${DOCKER_CONFIG}/cli-plugins/docker-compose"
# chmod +x "${DOCKER_CONFIG}/cli-plugins/docker-compose"
