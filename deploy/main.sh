#!/usr/bin/env bash

set -exu

if [[ -z ${DOTPATH} ]]; then
  DOTPATH="$(dirname "$(dirname "${BASH_SOURCE[0]:-$0}")")"
  export DOTPATH
fi

for f in "${DOTPATH%/}"/.zsh.d/{.zshenv,.zprofile,.zshrc}; do
  ln -snfv "$f" "$HOME"
done

ln -snfv "${DOTPATH%/}/.zsh.d/.p10k.zsh" "${HOME}/.zsh/.p10k.zsh"

for f in "${DOTPATH%/}"/.config/*; do
  ln -snfv "$f" "$HOME/.config"
done
# Reload bat syntaxes
if (type bat &> /dev/null); then
  bat cache --build
fi

ln -snfv "${HOME}/.config/latex/.latexmkrc" "$HOME"
ln -snfv "${DOTPATH%/}"/bin/{line,line-msg,pyshow,readlinkf} "$HOME/.local/bin"

case "${OSTYPE}" in
linux* | cygwin*)
  ln -snfv "${DOTPATH%/}/.emacs.d/init.el" "$HOME/.emacs.d"
  ;;
freebsd* | darwin*)
  ln -snfv "${DOTPATH%/}/.doom.d" "$HOME/.doom.d"
  ln -snfv "${HOME}"/.config/mackup/{.mackup,.mackup.cfg} "$HOME"
  bash -x "${DOTPATH%/}/deploy/launch-agents.sh"
  ;;
esac
