#!/bin/bash

set -exu

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

# install zplugin
if ! [[ -d ${HOME}/.zplugin ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh)"
fi
