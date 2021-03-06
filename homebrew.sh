#!/usr/bin/env bash

# Install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install GNU utilities
brew install binutils  # ld, ar, ...
brew install coreutils # ls, cp, rm, ...
brew install diffutils # diff, cmp, ...
brew install findutils # find, locate, updatedb, xargs
brew install moreutils
brew install gnu-sed # sed
brew install gnu-tar # tar
brew install gawk    # awk
brew install ed
brew install grep
brew install gzip
brew install wget

# Install a modern version of Zsh.
brew install zsh

# Switch to using brew-installed zsh as default shell
BREW_PREFIX=$(brew --prefix)
if ! fgrep -q "${BREW_PREFIX}/bin/zsh" /etc/shells; then
  echo "${BREW_PREFIX}/bin/zsh" | sudo tee -a /etc/shells
  chsh -s "${BREW_PREFIX}/bin/zsh"
fi

# Install GnuPG to enable PGP-signing commits.
# brew install gnupg

# Install more recent versions of some macOS tools.
brew install vim --with-override-system-vi
brew install openssh
# brew install gmp
brew install git
brew install emacs

# Install other useful binaries.
# brew install git-lfs
# brew install gs
brew install imagemagick --with-webp
# brew install lua
# brew install lynx
# brew install p7zip
# brew install pigz
brew install pv
brew install rename
brew install rlwrap
# brew install ssh-copy-id
brew install tree
# brew install vbindiff
# brew install zopfli
brew install colordiff
brew install htop
brew install readline
brew install nkf
# brew install jumanpp  # old (v1)
brew install pipenv
brew install pyenv
brew install python@3.8
brew install python
brew install sshfs # maybe after osxfuse
brew install zlib
brew install st # statistics
brew install go
brew install rust
brew install peco
brew install ripgrep
brew install procs # alternative of ps
brew install sd    # alternative of sed
brew install ghq

# Cask
brew tap caskroom/cask
brew install --cask osxfuse
brew install --cask google-chrome
brew install --cask google-japanese-ime
brew install --cask iterm2
brew install --cask clipy
brew install --cask docker
brew install --cask dozer  # hide menu bar icons

# AppStore系
brew install mas # AppStore系アプリのCLI管理ツール、リストは mas list で取れる
mas install 497799835 # XCode
mas install 425424353 # The Unarchiver
mas install 803453959 # Slack
mas install 539883307 # LINE
mas install 405399194 # Kindle
mas install 409201541 # Pages
mas install 409183694 # Keynote
mas install 409203825 # Numbers


# Remove outdated versions from the cellar.
brew cleanup
