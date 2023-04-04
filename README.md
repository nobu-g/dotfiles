# dotfiles

![License](http://img.shields.io/badge/license-MIT-blue.svg)
[![CodeFactor](https://www.codefactor.io/repository/github/nobu-g/dotfiles/badge)](https://www.codefactor.io/repository/github/nobu-g/dotfiles)
[![Linux](https://github.com/nobu-g/dotfiles/actions/workflows/test-linux.yml/badge.svg)](https://github.com/nobu-g/dotfiles/actions/workflows/test-linux.yml)
[![macOS](https://github.com/nobu-g/dotfiles/actions/workflows/test-macos.yml/badge.svg)](https://github.com/nobu-g/dotfiles/actions/workflows/test-macos.yml)
[![installer](https://github.com/nobu-g/dotfiles/actions/workflows/test-installer.yml/badge.svg)](https://github.com/nobu-g/dotfiles/actions/workflows/test-installer.yml)
[![lint](https://github.com/nobu-g/dotfiles/actions/workflows/lint.yml/badge.svg)](https://github.com/nobu-g/dotfiles/actions/workflows/lint.yml)

My dotfiles.

## Features

- [zsh](https://zsh.sourceforge.io)
- [Homebrew](https://brew.sh/) / [Linuxbrew](https://docs.brew.sh/Homebrew-on-Linux)
- [Zinit](https://github.com/zdharma-continuum/zinit)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [Mackup](https://github.com/lra/mackup)

## Setup

### Using installer

```bash
[SUDO=1] [FULL_INSTALL=1] sh -c "$(curl -fsSL https://raw.githubusercontent.com/nobu-g/dotfiles/main/install.sh)"
```

Options:

- `SUDO=1`: specify this if you have sudo privileges.
- `FULL_INSTALL=1`: specify this if you want to install all the Homebrew packages listed in `Brewfile` and `Brewfile.full`.
- `HOMEBREW_PREFIX=/somewhere`: specify this if you want to install Homebrew in a directory other than the default.

### Using GNU Make

```bash
git clone https://github.com/nobu-g/dotfiles.git
cd dotfiles
make install [SUDO=1] [FULL_INSTALL=1]
```

## Requirements

### macOS

- `sudo xcode-select --install`
- `softwareupdate --install-rosetta` (for Apple Silicon)

### Ubuntu

- `apt install sudo make zsh` (basic packages)
- `apt install gcc build-essential procps curl file git` (packages for Homebrew)
- `apt install python3-pip zlib1g-dev libp11-kit-dev` (packages for Homebrew packages)

### Debian

- `apt install sudo make zsh`
- `apt install gcc build-essential procps curl file git`
- `apt install python3-pip zlib1g-dev`

### Fedora

- `dnf install sudo make zsh`
- `dnf install gcc 'Development Tools' procps-ng curl file git libxcrypt-compat`
- `dnf install g++ perl-ExtUtils-MakeMaker perl-FindBin glibc-devel python3`

## License

MIT
