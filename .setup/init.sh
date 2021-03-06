#!/usr/bin/env bash

set -xu

here=$(dirname "${BASH_SOURCE[0]:-$0}")
id
cat /etc/passwd
cat /etc/sudoers
bash "$here"/install-basic-packages.sh

mkdir -p ~/.emacs.d ~/.config ~/scripts

# install Homebrew/Linuxbrew if not installed
if ! (type brew &> /dev/null); then
  case "${OSTYPE}" in
  linux* | cygwin*)
    bash "$here"/linuxbrew.sh
    BREW_PREFIX=$HOME/.linuxbrew
    ;;
  freebsd* | darwin*)
    bash "$here"/homebrew.sh
    BREW_PREFIX=/usr/local
    bash "$here"/setup-defaults.sh
    # install doom-emacs
    git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
    ~/.emacs.d/bin/doom install
    ;;
  esac
else
  BREW_PREFIX=$(brew --prefix)
fi

eval "$("$BREW_PREFIX/bin/brew" shellenv)"

bash "$here"/setup-shell.sh

# install zinit
if ! [[ -d ${HOME}/.zinit ]]; then
  mkdir ~/.zinit
  git clone https://github.com/zdharma/zinit.git ~/.zinit/bin
fi

# install poetry
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3
