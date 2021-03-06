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
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python

# sudoでTouchIDが使えるようにする
# /etc/pam.d/sudo の最初に以下の１行を追加
# ```
# auth       sufficient     pam_tid.so
# ```
