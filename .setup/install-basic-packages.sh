#!/usr/bin/env bash

set -ue

source "$(dirname "${BASH_SOURCE[0]:-$0}")/utils.sh"

distro=$(whichdistro)
if [[ $distro == "redhat" ]]; then
  checkinstall sudo make zsh git tmux bc curl wget gawk python3-pip unzip sqlite sqlite-devel gettext jq
elif [[ $distro == "debian" ]]; then
  checkinstall sudo make zsh git tmux bc curl wget gawk python3-pip unzip sqlite gettext jq
else
  checkinstall sudo zsh git tmux bc curl wget xsel gawk python-pip unzip sqlite gettext jq
fi

if [[ $distro == "redhat" ]]; then
  :
elif [[ $distro == "arch" ]]; then
  sudo pacman -S --noconfirm --needed tar
elif [[ $distro == "alpine" ]]; then
  sudo apk add g++ procps
elif [[ $distro == "debian" ]]; then
  :
else
  :
fi
