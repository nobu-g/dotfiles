#!/usr/bin/env bash

set -ue

source "$(dirname "${BASH_SOURCE[0]:-$0}")/utils.sh"

distro=$(whichdistro)
if [[ $distro == "redhat" ]]; then
  checkinstall sudo make zsh git bc curl wget gawk python3-pip unzip sqlite sqlite-devel gettext jq
elif [[ $distro == "debian" ]]; then
  checkinstall sudo make zsh git bc curl wget gawk python3-pip unzip sqlite gettext jq
else
  checkinstall sudo make zsh git bc curl wget gawk python-pip unzip sqlite gettext jq
fi

if [[ $distro == "redhat" ]]; then
  :
elif [[ $distro == "arch" ]]; then
  sudo pacman -S --noconfirm --needed tar
elif [[ $distro == "alpine" ]]; then
  sudo apk add --no-cache libc-dev g++ procps coreutils grep file grep libc6-compat ruby ruby-bigdecimal ruby-etc ruby-fiddle ruby-irb ruby-json ruby-test-unit
elif [[ $distro == "debian" ]]; then
  :
else
  :
fi
