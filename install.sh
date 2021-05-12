#!/usr/bin/env bash

set -eu

export DOTFILES_GITHUB="https://github.com/nobu-g/dotfiles.git"
export DOTFILES_TARBALL="https://github.com/nobu-g/dotfiles/archive/master.tar.gz"

#
# copied from https://github.com/b4b4r07/dotfiles/blob/66dddda6803ada50a0ab879e5db784afea72b7be/etc/install
#

# DOTPATH=$HOME/dotfiles

# BRANCH="${1:-master}"
# echo "Bootstrap with branch '${BRANCH}'"

# if [ ! -d "$DOTPATH" ]; then
#   git clone -b "$BRANCH" https://github.com/ikuwow/dotfiles.git "$DOTPATH"
# else
#   echo "$DOTPATH already downloaded. Updating..."
#   cd "$DOTPATH"
#   git stash
#   git checkout "$BRANCH"
#   git pull origin "$BRANCH"
#   echo
# fi

# cd "$DOTPATH"

# ./bootstrap/main.sh

# has returns true if executable $1 exists in $PATH
has() {
  type "$1" >/dev/null 2>&1
  return $?
}

e_error() {
  printf " \033[31m%s\033[m\n" "✖ $*" 1>&2
}

# die returns exit code error and echo error message
die() {
  e_error "$1" 1>&2
  exit "${2:-1}"
}

dotfiles_download() {
  if [[ -d "$DOTPATH" ]]; then
    die "$DOTPATH: already exists"
  fi

  if is_exists "git"; then
    git clone "$DOTFILES_GITHUB" "$DOTPATH"

  elif is_exists "curl" || is_exists "wget"; then
    # curl or wget
    if is_exists "curl"; then
      curl -L "$DOTFILES_TARBALL"

    elif is_exists "wget"; then
      wget -O - "$DOTFILES_TARBALL"

    fi | tar xvz
    if [[ ! -d dotfiles-master ]]; then
      die "dotfiles-master: not found"
    fi
    command mv -f dotfiles-master "$DOTPATH"
  else
    die "curl or wget required"
  fi
}

dotfiles-download

DOTPATH="$HOME/dotfiles"

# move to $DOTPATH
cd "$DOTPATH" || die "not found: $DOTPATH"

make install
