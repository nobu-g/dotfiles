#!/usr/bin/env bash

set -xu

# Environment variables:
# - HOMEBREW_PREFIX: directory where Homebrew and its dependencies are installed
# - SUDO: 1 if the user has sudo previledge and wants to exercise it
# - FULL_INSTALL: 1 if the user wants to install all the Homebrew dependencies

here=$(dirname "${BASH_SOURCE[0]:-$0}")

mkdir -p "${HOME}"/{.emacs.d,.config,scripts,.local}
mkdir -p "${HOME}"/.local/{bin,share,lib,include,src}
mkdir -p "${HOME}"/.local/share/{node,shell}

# install Homebrew and its packages
case "${OSTYPE}" in
linux* | cygwin*)
  HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-"$HOME/.linuxbrew"}
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
  if ! (type ~/.emacs.d/bin/doom &> /dev/null); then
    rm -rf ~/.emacs.d &&
      git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d &&
      yes | ~/.emacs.d/bin/doom install
  fi
  ;;
esac

# install Rust and its packages
export RUSTUP_INIT_SKIP_PATH_CHECK="yes"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
export PATH="$HOME/.cargo/bin:$PATH"
if (type cargo &> /dev/null); then
  bash -x "$here/rust-packages.sh"
fi

# install zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if ! [[ -d ${ZINIT_HOME} ]]; then
  mkdir -p "$(dirname "${ZINIT_HOME}")"
  git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}"
fi

# install python packages
if (type pipx &> /dev/null); then
  bash -x "$here/python-packages.sh"
fi

# install golang packages
if (type go &> /dev/null); then
  go install github.com/itchyny/fillin@latest
  go install golang.org/x/tools/gopls@latest  # or brew install gopls
fi

# install libstderred (https://github.com/sickill/stderred)
case "${OSTYPE}" in
linux* | cygwin*)
  lib_name=libstderred.so
  ;;
freebsd* | darwin*)
  lib_name=libstderred.dylib
  ;;
esac
if ! [[ -f "${HOME}/.local/lib/${lib_name}" ]] && (type cmake &> /dev/null); then
  git clone https://github.com/sickill/stderred.git "${HOME}/.local/src/stderred"
  cd "${HOME}/.local/src/stderred" || exit
  make
  ln -snfv "$(pwd)/build/${lib_name}" "$HOME/.local/lib/"
fi
