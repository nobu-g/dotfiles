#!/usr/bin/env bash

set -xu

here=$(dirname "${BASH_SOURCE[0]:-$0}")

mkdir -p ~/.emacs.d ~/.config ~/scripts ~/.local

case "${OSTYPE}" in
linux* | cygwin*)
  export BREW_PREFIX="$HOME/.linuxbrew"
  BREW_SETUP_DIR="$here/linuxbrew"
  ;;
freebsd* | darwin*)
  xcode-select --install
  export BREW_PREFIX="/usr/local"
  BREW_SETUP_DIR="$here/homebrew"
  ;;
esac

# install Homebrew/Linuxbrew
if ! [[ -e ${BREW_PREFIX}/bin/brew ]]; then
  bash "$BREW_SETUP_DIR/init.sh"
fi
eval "$("$BREW_PREFIX/bin/brew" shellenv)"
brew bundle install --file "$BREW_SETUP_DIR/Brewfile"
echo "Installed formulae and casks:"
brew list

bash "$here/setup-shell.sh"

case "${OSTYPE}" in
linux* | cygwin*)
  # https://qiita.com/aical/items/5b3ebee3840aae741283
  wget http://curl.haxx.se/ca/cacert.pem -O cert.pem
  mv cert.pem "${BREW_PREFIX}"/etc/openssl*/
  ;;
freebsd* | darwin*)
  bash "$here/setup-defaults.sh"
  # install doom-emacs
  rm -rf ~/.emacs.d &&
    git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d &&
    ~/.emacs.d/bin/doom install
  ;;
esac

# install zinit
if ! [[ -d ${HOME}/.zinit ]]; then
  mkdir ~/.zinit
  git clone https://github.com/zdharma/zinit.git ~/.zinit/bin
fi

# install poetry
if ! (type poetry &>/dev/null); then
  curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3
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
mkdir -p "$HOME/usr"
mkdir -p "$HOME/usr/lib"
ln -s "$(pwd)"/build/libstderred.* "$HOME/usr/lib/"
