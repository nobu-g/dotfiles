#!/usr/bin/env bash

set -xu

here=$(dirname "${BASH_SOURCE[0]:-$0}")

mkdir -p "$HOME"/{.emacs.d,.config,scripts,.local}

# install Homebrew and its packages
bash -x "$here/homebrew/main.sh"

# set login shell to zsh
bash -x "$here/setup-shell.sh"

case "${OSTYPE}" in
freebsd* | darwin*)
  bash -x "$here/setup-defaults.sh"
  # install doom-emacs
  if ! (type ~/.emacs.d/bin/doom &> /dev/null); then
    rm -rf ~/.emacs.d &&
      git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d &&
      ~/.emacs.d/bin/doom install
  fi
  ;;
esac

# install Rust and its packages
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
export PATH="$HOME/.cargo/bin:$PATH"
if (type cargo &> /dev/null); then
  bash -x "$here/rust-packages.sh"
fi

# install zinit
if ! [[ -d ${HOME}/.zinit ]]; then
  mkdir ~/.zinit
  git clone https://github.com/zdharma/zinit.git ~/.zinit/bin
fi

# install python packages
if (type pip3 &> /dev/null); then
  bash -x "$here/python-packages.sh"
fi

# install golang packages
if (type go &> /dev/null); then
  bash -x "$here/go-packages.sh"
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
  git clone https://github.com/sickill/stderred.git && cd stderred || exit
  make
  mkdir -p "$HOME/.local/lib"
  ln -snfv "$(pwd)/build/${lib_name}" "$HOME/.local/lib/"
fi
