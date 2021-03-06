#!/usr/bin/env bash

# Install linuxbrew
git clone --depth 1 https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew
mkdir -p ~/.linuxbrew/bin
ln -fs ~/.linuxbrew/Homebrew/bin/brew ~/.linuxbrew/bin
eval $(~/.linuxbrew/bin/brew shellenv)

# Install command-line tools using Linuxbrew.

# Make sure we’re using the latest Linuxbrew.
brew update

# some fomulae need to be built from source and require gcc
brew install gcc

# Upgrade any already-installed formulae.
brew upgrade

brew install zsh

BREW_PREFIX=$(brew --prefix)
# # Switch to using brew-installed zsh as default shell
# if ! fgrep -q "${BREW_PREFIX}/bin/zsh" /etc/shells; then
#   echo "${BREW_PREFIX}/bin/zsh" | sudo tee -a /etc/shells
#   chsh -s "${BREW_PREFIX}/bin/zsh"
# fi

brew install git
brew install emacs
brew install curl
# https://qiita.com/aical/items/5b3ebee3840aae741283
wget http://curl.haxx.se/ca/cacert.pem -O cert.pem
mv cert.pem ${BREW_PREFIX}/etc/openssl*/

# Install other useful binaries.
# brew install gs
# brew install lynx
# brew install p7zip
# brew install pigz
# brew install pv
brew install rlwrap
# brew install ssh-copy-id
# brew install vbindiff
# brew install zopfli
brew install colordiff
brew install htop
brew install openssh
brew install readline
brew install zlib
brew install pipenv
brew install pyenv
brew install python@3.8
brew install python
brew install st # statistics
brew install peco
brew install ripgrep
brew install rga  # ripgrep-all
brew install procs  # alternative of ps
brew install fd  # alternative of find
brew install sd  # alternative of sed
brew install source-highlight
brew install xclip
brew install go
brew install rust
brew install shellcheck

# Remove outdated versions from the cellar.
brew cleanup
