#!/usr/bin/env sh

set -eu

export DOTFILES_GITHUB="https://github.com/nobu-g/dotfiles.git"
export DOTFILES_TARBALL="https://github.com/nobu-g/dotfiles/archive/main.tar.gz"
DOTPATH="${DOTPATH:-"$HOME/dotfiles"}"

# https://github.com/yutkat/dotfiles/blob/52db06ac638df87e34ebd7ac323653a328a982ca/install_scripts/lib/dotsinstaller/utilfuncs.sh

# print_default() {
#   echo -e "$*"
# }

# print_info() {
#   echo -e "\e[1;36m$*\e[m" # cyan
# }

# print_notice() {
#   echo -e "\e[1;35m$*\e[m" # magenta
# }

# print_success() {
#   echo -e "\e[1;32m$*\e[m" # green
# }

# print_warning() {
#   echo -e "\e[1;33m$*\e[m" # yellow
# }

# print_error() {
#   echo -e "\e[1;31m$*\e[m" # red
# }

# print_debug() {
#   echo -e "\e[1;34m$*\e[m" # blue
# }

yes_or_no_select() {
  # local answer
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
    echo "${contents}" >>"${target_file}"
  fi
}

whichdistro() {
  #which yum > /dev/null && { echo redhat; return; }
  #which zypper > /dev/null && { echo opensuse; return; }
  #which apt-get > /dev/null && { echo debian; return; }
  if [ -f /etc/debian_version ]; then
    echo debian
  elif [ -f /etc/fedora-release ]; then
    echo fedora
  elif [ -f /etc/redhat-release ]; then
    echo redhat
  elif [ -f /etc/arch-release ]; then
    echo arch
  elif [ -f /etc/alpine-release ]; then
    echo alpine
  fi
}

checkinstall() {
  # local distro
  _distro=$(whichdistro)
  if [ "$_distro" = "redhat" ]; then
    sudo yum clean all
    if ! grep -i "fedora" /etc/redhat-release >/dev/null; then
      sudo yum install -y epel-release
      if [ "$(cat /etc/*release | grep '^VERSION=' | cut -d '"' -f 2 | cut -d " " -f 1)" -ge 8 ]; then
        sudo dnf install -y 'dnf-command(config-manager)'
        sudo dnf config-manager --set-enabled powertools
      fi
    fi
  fi

  pkgs="$*"
  if [ "$_distro" = "debian" ]; then
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ${pkgs}
  elif [ "$_distro" = "redhat" ]; then
    sudo yum install -y ${pkgs}
  elif [ "$_distro" = "arch" ]; then
    sudo pacman -S --noconfirm --needed ${pkgs}
  elif [ "$_distro" = "alpine" ]; then
    # sudo bash -c "$(declare -f append_file_if_not_exist); append_file_if_not_exist http://dl-3.alpinelinux.org/alpine/edge/testing/ /etc/apk/repositories"
    sudo apk add ${pkgs}
  else
    :
  fi
}


# copied from https://github.com/b4b4r07/dotfiles/blob/66dddda6803ada50a0ab879e5db784afea72b7be/etc/install

is_exists() {
  type "$1" > /dev/null 2>&1
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
  if [ -d "$DOTPATH" ]; then
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

    if [ ! -d dotfiles-master ]; then
      die "dotfiles-master: not found"
    fi
    mkdir -p "$(dirname "$DOTPATH")"
    command mv -f dotfiles-master "$DOTPATH"
  else
    die "curl or wget required"
  fi
}

install_basic_packages() {
  distro=$(whichdistro)
  checkinstall sudo make zsh
  if [ "$distro" = "debian" ]; then
    checkinstall gcc build-essential procps curl file git python3-pip zlib1g-dev
  elif [ "$distro" = "fedora" ]; then
    checkinstall gcc 'Development Tools' procps-ng curl file git libxcrypt-compat g++ perl-ExtUtils-MakeMaker perl-FindBin glibc-devel python3
  elif [ "$distro" = "redhat" ]; then
    checkinstall gcc 'Development Tools' procps-ng curl file git libxcrypt-compat g++ perl-ExtUtils-MakeMaker perl-FindBin glibc-devel python3
  else
    :
  fi

  # if [ "$distro" = "redhat" ]; then
  #   :
  # elif [ "$distro" = "arch" ]; then
  #   sudo pacman -S --noconfirm --needed tar
  # elif [ "$distro" = "alpine" ]; then
  #   sudo apk add g++
  # elif [ "$distro" = "debian" ]; then
  #   :
  # else
  #   :
  # fi
}

if [ "${SUDO}" -eq 1 ]; then
  install_basic_packages
fi

dotfiles_download

# move to $DOTPATH
cd "$DOTPATH" || die "not found: $DOTPATH"

make install
