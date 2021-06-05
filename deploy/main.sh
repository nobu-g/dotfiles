#!/usr/bin/env bash

set -exu

if [[ -z ${DOTPATH} ]]; then
  DOTPATH="$(dirname "$(dirname "${BASH_SOURCE[0]:-$0}")")"
  export DOTPATH
fi

for f in "${DOTPATH%/}"/.zsh.d/{.zshenv,.zprofile,.zshrc,.p10k.zsh}; do
  ln -snfv "$f" "$HOME"
done

for f in "${DOTPATH%/}"/.config/*; do
  ln -snfv "$f" "$HOME/.config"
done
# Reload bat syntaxes
if (type bat &> /dev/null); then
  bat cache --build
fi

ln -snfv "${DOTPATH%/}/.latexmkrc" "$HOME"
ln -snfv "${DOTPATH%/}/bin/line" "$HOME/scripts"
ln -snfv "${DOTPATH%/}/bin/line-msg" "$HOME/scripts"
ln -snfv "${DOTPATH%/}/bin/pyshow" "$HOME/scripts"

case "${OSTYPE}" in
linux* | cygwin*)
  ln -snfv "${DOTPATH%/}/.emacs.d/init.el" "$HOME/.emacs.d"
  ;;
freebsd* | darwin*)
  ln -snfv "${DOTPATH%/}/.doom.d" "$HOME/.doom.d"
  ln -snfv "${DOTPATH%/}/.mackup" "$HOME"
  ln -snfv "${DOTPATH%/}/.mackup.cfg" "$HOME"
  bash -ex "${DOTPATH%/}/deploy/launch-agents.sh"
  ;;
esac
