#!/usr/bin/env bash

[[ -n "$(command -v brew)" ]] && zsh_path="$(brew --prefix)/bin/zsh" || zsh_path="$(command -v zsh)"
if ! grep "$zsh_path" /etc/shells; then
  echo "adding $zsh_path to /etc/shells"
  echo "$zsh_path" | sudo tee -a /etc/shells
fi

if [[ "$SHELL" != "$zsh_path" ]]; then
  sudo chsh -s "$zsh_path" && echo "default shell changed to $zsh_path"
fi
