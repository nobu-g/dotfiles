#!/usr/bin/env bash

# Install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `diff`, `cmp`, ...
brew install diffutils
# Install GNU
brew install ed
# Install GNU `ld`, `ar`, ...
brew install binutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names
# Install GNU `tar`, overwriting the built-in `tar`.
brew install gnu-tar
# Install a modern version of Zsh.
brew install zsh

# Switch to using brew-installed zsh as default shell
BREW_PREFIX=$(brew --prefix)
if ! fgrep -q "${BREW_PREFIX}/bin/zsh" /etc/shells; then
  echo "${BREW_PREFIX}/bin/zsh" | sudo tee -a /etc/shells
  chsh -s "${BREW_PREFIX}/bin/zsh"
fi

# Install `wget` with IRI support.
brew install wget --with-iri

# Install GnuPG to enable PGP-signing commits.
# brew install gnupg

# Install more recent versions of some macOS tools.
brew install vim --with-override-system-vi
brew install grep
brew install openssh
# brew install php
# brew install gmp
brew install zgip
brew install gawk
brew install git
brew install emacs

# Install font tools.
# brew tap bramstein/webfonttools
# brew install sfnt2woff
# brew install sfnt2woff-zopfli
# brew install woff2

# Install other useful binaries.
#brew install exiv2
# brew install git-lfs
# brew install gs
brew install imagemagick --with-webp
# brew install lua
# brew install lynx
# brew install p7zip
# brew install pigz
brew install pv
brew install rename
# brew install rlwrap
# brew install ssh-copy-id
brew install tree
# brew install vbindiff
# brew install zopfli
brew install colordiff
brew install docker
brew install htop
brew install readline
brew install nkf
# brew install jumanpp  # old
brew install pipenv
brew install pyenv
brew install python
brew install sshfs # maybe after osxfuse
brew install zlib
brew install st # statistics
brew install go
brew install peco
brew install ripgrep
brew install procs  # alternative of ps

# Cask
brew tap caskroom/cask
brew cask install osxfuse

# Remove outdated versions from the cellar.
brew cleanup
