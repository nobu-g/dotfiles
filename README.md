# dotfiles

![License](http://img.shields.io/badge/license-MIT-blue.svg)
[![Linux](https://github.com/nobu-g/dotfiles/actions/workflows/test-linux.yml/badge.svg)](https://github.com/nobu-g/dotfiles/actions/workflows/test-linux.yml)
[![macOS](https://github.com/nobu-g/dotfiles/actions/workflows/test-macos.yml/badge.svg)](https://github.com/nobu-g/dotfiles/actions/workflows/test-macos.yml)
[![lint](https://github.com/nobu-g/dotfiles/actions/workflows/lint.yml/badge.svg)](https://github.com/nobu-g/dotfiles/actions/workflows/lint.yml)

My dotfiles.

## Features
- zsh
- Homebrew/Linuxbrew
- [zinit](https://github.com/zdharma/zinit)
- [powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [mackup](https://github.com/lra/mackup)

## Setup

### Those who have sudo privileges

```bash
$ git clone https://github.com/nobu-g/dotfiles.git
$ cd dotfiles
$ make install SUDO=1
```

### Those who do not have sudo privileges

```bash
git clone https://github.com/nobu-g/dotfiles.git
cd dotfiles
make install
```
or using installer:
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/nobu-g/dotfiles/main/install.sh)"
```

## Requirements
- make
- gcc
- git
- curl
- sudo
- zsh

## License

MIT
