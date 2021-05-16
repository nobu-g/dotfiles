#!/usr/bin/env bash

set -u

# set zsh_path only when zsh installed via Homebrew is not under $HOME
brew_prefix=$(realpath "${HOMEBREW_PREFIX}")
if (type brew &>/dev/null) && [[ -n ${brew_prefix##$(realpath "${HOME}")/*} ]]; then
  zsh_path="${HOMEBREW_PREFIX}/bin/zsh"
else
  zsh_path="$(command -v zsh)"
  for p in $(which -a zsh); do
    if [[ -n ${p##$(realpath "${HOME}")/*} ]]; then
      zsh_path="${p}"
      break
    fi
  done
fi

if ! grep "$zsh_path" /etc/shells; then
  echo "adding $zsh_path to /etc/shells"
  echo "$zsh_path" | sudo tee -a /etc/shells
fi

if [[ "$SHELL" != "$zsh_path" ]]; then
  sudo chsh -s "$zsh_path" && echo "default shell changed to $zsh_path"
fi
