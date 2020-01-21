#!/bin/bash

set -xu

mkdir -p ~/.emacs.d
mkdir -p ~/.config
mkdir -p ~/.config/git
mkdir -p ~/.config/peco

# install Homebrew/Linuxbrew if not installed
if !(type brew &> /dev/null); then
  case "${OSTYPE}" in
  linux* | cygwin*)
    bash ${DOTPATH}/linuxbrew.sh
    ;;
  freebsd* | darwin*)
    bash ${DOTPATH}/homebrew.sh
    ;;
  esac
fi

# install zinit
if ! [[ -d ${HOME}/.zinit ]]; then
  mkdir ~/.zinit
  git clone https://github.com/zdharma/zinit.git ~/.zinit/bin
fi
