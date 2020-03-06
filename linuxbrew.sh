#!/usr/bin/env bash

# Install linuxbrew
git clone --depth 1 https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew
mkdir -p ~/.linuxbrew/bin
ln -fs ~/.linuxbrew/Homebrew/bin/brew ~/.linuxbrew/bin
eval $(~/.linuxbrew/bin/brew shellenv)

# Install command-line tools using Linuxbrew.

# Make sure we’re using the latest Linuxbrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install a modern version of Zsh.
brew install zsh

# Switch to using brew-installed zsh as default shell
BREW_PREFIX=$(brew --prefix)
if ! fgrep -q "${BREW_PREFIX}/bin/zsh" /etc/shells; then
  echo "${BREW_PREFIX}/bin/zsh" | sudo tee -a /etc/shells
  chsh -s "${BREW_PREFIX}/bin/zsh"
fi

brew install git
brew install emacs

# Install other useful binaries.
# brew install ack
# brew install exiv2
# brew install git-lfs
# brew install gs
# brew install lynx
# brew install p7zip
# brew install pigz
brew install pv
# brew install rlwrap
# brew install ssh-copy-id
# brew install vbindiff
# brew install zopfli
brew install colordiff
brew install htop
brew install readline
# brew install jumanpp  # old
brew install pipenv
brew install pyenv
brew install python
brew install zlib
brew install st # statistics
brew install go
brew install peco
brew install ripgrep
brew install openssh
brew install procs  # alternative of ps

# Remove outdated versions from the cellar.
brew cleanup
