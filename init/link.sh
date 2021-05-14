#!/usr/bin/env bash

set -exu

BASE_DIR=$(
  cd "$(dirname "$(dirname "${BASH_SOURCE[0]:-$0}")")"
  pwd
)
cd "$BASE_DIR"

for f in "${BASE_DIR%/}"/.zsh.d/{.zshenv,.zprofile,.zshrc,.p10k.zsh}; do
  ln -snfv "$f" "$HOME/"
done

for f in "${BASE_DIR%/}"/.config/*; do
  ln -snfv "$f" "$HOME/.config/"
done

ln -snfv "${BASE_DIR%/}/.latexmkrc" "$HOME/"
ln -snfv "${BASE_DIR%/}/bin/line" "$HOME/scripts/"
ln -snfv "${BASE_DIR%/}/bin/pyshow" "$HOME/scripts/"

case "${OSTYPE}" in
linux* | cygwin*)
  ln -snfv "${BASE_DIR%/}/.emacs.d/init.el" "$HOME/.emacs.d/"
  ;;
freebsd* | darwin*)
  ln -snfv "${BASE_DIR%/}/.doom.d" "$HOME/"
  ;;
esac
