#!/usr/bin/env bash

set -xu

here=$(dirname "${BASH_SOURCE[0]:-$0}")

mkdir -p "$HOME"/{.emacs.d,.config,scripts,.local}

case "${OSTYPE}" in
linux* | cygwin*)
  export HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-"$HOME/.linuxbrew"}
  BREW_SETUP_DIR="$here/linuxbrew"
  ;;
freebsd* | darwin*)
  xcode-select --install
  export HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-"/usr/local"}
  BREW_SETUP_DIR="$here/homebrew"
  ;;
esac

# install Homebrew/Linuxbrew
if ! [[ -e ${HOMEBREW_PREFIX}/bin/brew ]]; then
  bash -x "$BREW_SETUP_DIR/init.sh"
fi
eval "$("$HOMEBREW_PREFIX/bin/brew" shellenv)"
if [[ ${FULL_INSTALL} -eq 1 ]]; then
  brew bundle install --file "$BREW_SETUP_DIR/Brewfile.full"
else
  brew bundle install --file "$BREW_SETUP_DIR/Brewfile"
fi
echo "Installed formulae and casks:"
brew list

bash -x "$here/setup-shell.sh"

case "${OSTYPE}" in
linux* | cygwin*)
  # https://qiita.com/aical/items/5b3ebee3840aae741283
  wget http://curl.haxx.se/ca/cacert.pem -O cert.pem
  mv cert.pem "${HOMEBREW_PREFIX}"/etc/openssl*/
  ;;
freebsd* | darwin*)
  bash -x "$here/setup-defaults.sh"
  # install doom-emacs
  if ! (type ~/.emacs.d/bin/doom &> /dev/null); then
    rm -rf ~/.emacs.d &&
      git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d &&
      ~/.emacs.d/bin/doom install
  fi
  ;;
esac

# install Rust and its packages
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
export PATH="$HOME/.cargo/bin:$PATH"
if (type cargo &> /dev/null); then
  bash -x "$here/rust-packages.sh"
fi

# install zinit
if ! [[ -d ${HOME}/.zinit ]]; then
  mkdir ~/.zinit
  git clone https://github.com/zdharma/zinit.git ~/.zinit/bin
fi

# install python packages
if (type pip3 &> /dev/null); then
  bash -x "$here/python-packages.sh"
fi

# install golang packages
if (type go &> /dev/null); then
  bash -x "$here/go-packages.sh"
fi

# install libstderred (https://github.com/sickill/stderred)
case "${OSTYPE}" in
linux* | cygwin*)
  lib_name=libstderred.so
  ;;
freebsd* | darwin*)
  lib_name=libstderred.dylib
  ;;
esac
if ! [[ -f "${HOME}/.local/lib/${lib_name}" ]] && (type cmake &> /dev/null); then
  git clone https://github.com/sickill/stderred.git && cd stderred || exit
  make
  mkdir -p "$HOME/.local/lib"
  ln -snfv "$(pwd)/build/${lib_name}" "$HOME/.local/lib/"
fi
