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
  bash "$BREW_SETUP_DIR/init.sh"
fi
eval "$("$HOMEBREW_PREFIX/bin/brew" shellenv)"
brew bundle install --file "$BREW_SETUP_DIR/Brewfile"
echo "Installed formulae and casks:"
brew list

bash "$here/setup-shell.sh"

case "${OSTYPE}" in
linux* | cygwin*)
  # https://qiita.com/aical/items/5b3ebee3840aae741283
  wget http://curl.haxx.se/ca/cacert.pem -O cert.pem
  mv cert.pem "${HOMEBREW_PREFIX}"/etc/openssl*/
  ;;
freebsd* | darwin*)
  bash "$here/setup-defaults.sh"
  # install doom-emacs
  rm -rf ~/.emacs.d &&
    git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d &&
    ~/.emacs.d/bin/doom install
  ;;
esac

# install Rust and its packages
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
export PATH="$HOME/.cargo/bin:$PATH"
if (type cargo &>/dev/null); then
  bash "$here/rust-packages.sh"
fi

# install zinit
if ! [[ -d ${HOME}/.zinit ]]; then
  mkdir ~/.zinit
  git clone https://github.com/zdharma/zinit.git ~/.zinit/bin
fi

# install python packages
if (type pip3 &>/dev/null); then
  bash "$here/python-packages.sh"
fi

# install golang packages
if (type go &>/dev/null); then
  bash "$here/go-packages.sh"
fi

# install libstderred (https://github.com/sickill/stderred)
git clone git://github.com/sickill/stderred.git && cd stderred || exit
make
mkdir -p "$HOME/.local/lib"
ln -snfv "$(pwd)"/build/libstderred.* "$HOME/.local/lib/"
