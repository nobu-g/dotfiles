#!/usr/bin/env bash

set -xu

mkdir -p ~/.emacs.d
mkdir -p ~/.config
mkdir -p ~/.config/git
mkdir -p ~/.config/peco

# install Homebrew/Linuxbrew if not installed
if ! (type brew &> /dev/null); then
  case "${OSTYPE}" in
  linux* | cygwin*)
    bash "${DOTPATH}"/.setup/linuxbrew.sh
    eval "$(~/.linuxbrew/bin/brew shellenv)"
    ;;
  freebsd* | darwin*)
    bash "${DOTPATH}"/.setup/homebrew.sh
    eval "$(/usr/local/bin/brew shellenv)"
    bash "${DOTPATH}"/.setup/setup-defaults.sh
    # install doom-emacs
    git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
    ~/.emacs.d/bin/doom install
    ;;
  esac
fi

# install zinit
if ! [[ -d ${HOME}/.zinit ]]; then
  mkdir ~/.zinit
  git clone https://github.com/zdharma/zinit.git ~/.zinit/bin
fi

# install poetry
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3
