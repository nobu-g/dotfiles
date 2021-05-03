#!/usr/bin/env bash

set -exu

BASE_DIR=$(
  cd "$(dirname "$(dirname "${BASH_SOURCE[0]:-$0}")")"
  pwd
)
cd "$BASE_DIR"

for f in "${BASE_DIR%/}"/.zsh.d/{.zshenv,.zprofile,.zshrc,.p10k.zsh}; do
  ln -snfv "$f" "$HOME"
done

for f in "${BASE_DIR%/}"/.config/*; do
  ln -snfv "$f" "$HOME/.config"
done

ln -sf "${BASE_DIR%/}"/.latexmkrc "$HOME/.latexmkrc"
ln -sf "${BASE_DIR%/}"/bin/line "$HOME/scripts/"

case "${OSTYPE}" in
linux* | cygwin*)
  ln -sf "${BASE_DIR%/}"/.emacs.d/init.el "$HOME/.emacs.d/init.el"
  ;;
freebsd* | darwin*)
  ln -sf /usr/local/share/git-core/contrib/diff-highlight/diff-highlight /usr/local/bin
  ln -sf "${BASE_DIR%/}"/.doom.d "$HOME/.doom.d"
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
