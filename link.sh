#!/bin/bash

set -exu

ln -sf ~/dotfiles/.zsh.d/.zshenv ~/.zshenv
ln -sf ~/dotfiles/.zsh.d/.zprofile ~/.zprofile
ln -sf ~/dotfiles/.zsh.d/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.zsh.d/.p10k.zsh ~/.p10k.zsh
ln -sf ~/dotfiles/.emacs.d/init.el ~/.emacs.d/init.el
ln -sf ~/dotfiles/.git.d/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.git.d/.gitignore_global ~/.config/git/ignore
ln -sf ~/dotfiles/.peco/config.json ~/.config/peco/config.json
ln -sf ~/dotfiles/.config/fsh ~/.config/
ln -sf ~/dotfiles/.latexmkrc ~/.latexmkrc

case "${OSTYPE}" in
linux* | cygwin*) ;;
freebsd* | darwin*)
  ln -sf /usr/local/share/git-core/contrib/diff-highlight/diff-highlight /usr/local/bin
  ;;
esac
