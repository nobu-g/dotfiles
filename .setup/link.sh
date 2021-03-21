#!/usr/bin/env bash

set -exu

DOTDIR=$(
  cd "$(dirname "$(dirname "$0")")"
  pwd
)
cd "$DOTDIR"

ZDOTDIR=${DOTDIR%/}/.zsh.d
for f in "${ZDOTDIR%/}"/{.zshenv,.zprofile,.zshrc,.p10k.zsh}; do
  ln -snfv "$f" "$HOME"
done

for f in "${DOTDIR%/}"/.config/*; do
  ln -snfv "$f" "$HOME/.config"
done

ln -sf "${DOTDIR%/}"/.git.d/.gitconfig "$HOME/.gitconfig"
ln -sf "${DOTDIR%/}"/.latexmkrc "$HOME/.latexmkrc"
ln -sf "${DOTDIR%/}"/bin/line "$HOME/scripts/"

case "${OSTYPE}" in
linux* | cygwin*)
  ln -sf "${DOTDIR%/}"/.emacs.d/init.el "$HOME/.emacs.d/init.el"
  ;;
freebsd* | darwin*)
  ln -sf /usr/local/share/git-core/contrib/diff-highlight/diff-highlight /usr/local/bin
  ln -sf "${DOTDIR%/}"/.doom.d "$HOME/.doom.d"
  ;;
esac

if [[ -e ${HOME}/.linuxbrew/share/git-core/contrib/diff-highlight/diff-highlight ]]; then
  ln -sf "$HOME"/.linuxbrew/share/git-core/contrib/diff-highlight/diff-highlight "$HOME/.linuxbrew/bin"
fi
if [[ -e /home/.linuxbrew/share/git-core/contrib/diff-highlight/diff-highlight ]]; then
  ln -sf /home/.linuxbrew/share/git-core/contrib/diff-highlight/diff-highlight /home/.linuxbrew/bin
fi
if [[ -e /usr/local/share/git-core/contrib/diff-highlight/diff-highlight ]]; then
  ln -sf /usr/local/share/git-core/contrib/diff-highlight/diff-highlight /usr/local/bin
fi
