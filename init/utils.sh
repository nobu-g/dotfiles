#!/usr/bin/env bash

print_default() {
  echo -e "$*"
}

print_info() {
  echo -e "\e[1;36m$*\e[m" # cyan
}

print_notice() {
  echo -e "\e[1;35m$*\e[m" # magenta
}

print_success() {
  echo -e "\e[1;32m$*\e[m" # green
}

print_warning() {
  echo -e "\e[1;33m$*\e[m" # yellow
}

print_error() {
  echo -e "\e[1;31m$*\e[m" # red
}

print_debug() {
  echo -e "\e[1;34m$*\e[m" # blue
}

chkcmd() {
  if ! builtin command -v "$1"; then
    print_error "${1} command not found"
    exit
  fi
}

yes_or_no_select() {
  local answer
  print_notice "Are you ready? [yes/no]"
  read -r answer
  case $answer in
    yes | y)
      return 0
      ;;
    no | n)
      return 1
      ;;
    *)
      yes_or_no_select
      ;;
  esac
}

append_file_if_not_exist() {
  contents="$1"
  target_file="$2"
  if ! grep -q "${contents}" "${target_file}"; then
    echo "${contents}" >> "${target_file}"
  fi
}

whichdistro() {
  #which yum > /dev/null && { echo redhat; return; }
  #which zypper > /dev/null && { echo opensuse; return; }
  #which apt-get > /dev/null && { echo debian; return; }
  if [ -f /etc/debian_version ]; then
    echo debian
    return
  elif [ -f /etc/fedora-release ]; then
    # echo fedora; return;
    echo redhat
    return
  elif [ -f /etc/redhat-release ]; then
    echo redhat
    return
  elif [ -f /etc/arch-release ]; then
    echo arch
    return
  elif [ -f /etc/alpine-release ]; then
    echo alpine
    return
  fi
}

checkinstall() {
  local distro
  distro=$(whichdistro)
  if [[ $distro == "redhat" ]]; then
    sudo yum clean all
    if ! grep -i "fedora" /etc/redhat-release > /dev/null; then
      sudo yum install -y epel-release
      if [[ $(cat /etc/*release | grep '^VERSION=' | cut -d '"' -f 2 | cut -d " " -f 1) -ge 8 ]]; then
        sudo dnf install -y 'dnf-command(config-manager)'
        sudo dnf config-manager --set-enabled powertools
      fi
    fi
  fi

  local pkgs="$*"
  if [[ $distro == "debian" ]]; then
    pkgs=${pkgs//python-pip/python3-pip}
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ${pkgs}
  elif [[ $distro == "redhat" ]]; then
    sudo yum install -y ${pkgs}
  elif [[ $distro == "arch" ]]; then
    sudo pacman -S --noconfirm --needed ${pkgs}
  elif [[ $distro == "alpine" ]]; then
    sudo bash -c "$(declare -f append_file_if_not_exist); append_file_if_not_exist http://dl-3.alpinelinux.org/alpine/edge/testing/ /etc/apk/repositories"
    pkgs=${pkgs//python-pip/py-pip}
    sudo apk add ${pkgs}
  else
    :
  fi
}
