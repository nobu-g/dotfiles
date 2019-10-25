#!/bin/bash

set -exu

ln -sf ~/dotfiles/.zsh.d/.zshenv ~/.zshenv
ln -sf ~/dotfiles/.zsh.d/.zprofile ~/.zprofile
ln -sf ~/dotfiles/.zsh.d/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.emacs.d/init.el ~/.emacs.d/init.el
ln -sf ~/dotfiles/.git.d/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.git.d/.gitignore_global ~/.config/git/ignore
ln -sf ~/dotfiles/.peco/config.json ~/.config/peco/config.json
