#!/usr/bin/env bash

set -u

if [[ "$(basename "${SHELL}")" == "zsh" ]]; then
  echo "already using zsh"
  exit 0
fi

# @usage
# see https://manpages.debian.org/stretch/debianutils/which.1.en.html
bash_which() {
  # locate a command
  local -i opt_a=0
  if (($# > 0)) && [[ ${1:0:1} == - ]]; then
    if [[ $1 != -a ]]; then
      printf >&2 'Illegal option %s\nUsage: which [-a] args\n' "$1"
      return 2
    else
      opt_a=1
    fi
    shift
  fi

  local IFS=:
  local -a path_arr
  read -rd '' -a path_arr < <(printf %s:\\0 "${PATH}")
  local -i rc=0
  while (($# > 0)); do
    local -i found=0
    local dir
    for dir in "${path_arr[@]}"; do
      local path="${dir}/${1}"
      while [[ -L ${path} && "$(ls -l "${path}")" =~ -\>[[:space:]](.*) ]]; do
        path="${BASH_REMATCH[1]}"
      done
      if [[ -f ${path} && -x ${path} ]]; then
        found=1
        echo "${dir}/${1}"
        ((opt_a)) || break
      fi
    done
    ((found)) || rc=1
    shift
  done
  return "${rc}"
}

zsh_path="$(grep "zsh" /etc/shells)"
if [[ -z ${zsh_path} ]]; then
  echo "you don't have zsh in /etc/shells"
  # set zsh_path only when zsh installed via Homebrew is not under $HOME
  brew_prefix=$(realpath "${HOMEBREW_PREFIX}")
  if (type brew &> /dev/null) && [[ -n ${brew_prefix##"$(realpath "${HOME}")"/*} ]]; then
    zsh_path="${HOMEBREW_PREFIX}/bin/zsh"
  else
    zsh_path="$(command -v zsh)"
    for p in $(bash_which -a zsh); do
      if [[ -n ${p##"$(realpath "${HOME}")"/*} ]]; then
        zsh_path="${p}"
        break
      fi
    done
  fi
  if [[ ${SUDO} -eq 1 ]]; then
    echo "Trying to add ${zsh_path} to /etc/shells, but it seems you don't have sudo privileges."
    echo "Try to install dotfiles specifying 'SUDO=1'"
    exit 1
  fi
  echo "adding ${zsh_path} to /etc/shells"
  echo "${zsh_path}" | sudo tee -a /etc/shells
fi

if [[ ${SUDO} -eq 1 ]]; then
  echo "Trying to change your login shell to ${zsh_path}, but it seems you don't have sudo privileges."
  echo "Try to install dotfiles specifying 'SUDO=1'"
  exit 1
fi
sudo chsh -s "$zsh_path" && echo "default shell changed to $zsh_path"
