#!/usr/bin/env bash

set -exu

export ZDOTDIR="${ZDOTDIR:-${HOME}/.zsh}"
if [[ -z ${DOTPATH} ]]; then
  DOTPATH="$(dirname "$(dirname "${BASH_SOURCE[0]:-$0}")")"
  export DOTPATH
fi

for f in "${DOTPATH%/}"/.zsh.d/{.zshenv,.zprofile,.zshrc,.p10k.zsh}; do
  ln -snfv "$f" "${ZDOTDIR}"
done
# .zshenv is placed in $HOME, which is the default $ZDOTDIR, for the initial login
ln -snfv "${ZDOTDIR%/}/.zshenv" "${HOME}"/.zshenv

for f in "${DOTPATH%/}"/.config/*; do
  ln -snfv "$f" "${HOME}/.config"
done
# Reload bat syntaxes
if (type bat &> /dev/null); then
  bat cache --build
fi

ln -snfv "${DOTPATH%/}"/bin/{line,line-msg,pyshow,readlinkf} "${HOME}/.local/bin"

case "${OSTYPE}" in
linux* | cygwin*)
  ln -snfv "${DOTPATH%/}/.emacs.d/init.el" "${HOME}/.emacs.d"
  ;;
freebsd* | darwin*)
  ln -snfv "${HOME}"/.config/mackup/{.mackup,.mackup.cfg} "${HOME}"
  bash -x "${DOTPATH%/}/deploy/launch-agents.sh"
  ;;
esac
