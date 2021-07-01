# dotfiles

![License](http://img.shields.io/badge/license-MIT-blue.svg)
[![Linux](https://github.com/nobu-g/dotfiles/actions/workflows/test-linux.yml/badge.svg)](https://github.com/nobu-g/dotfiles/actions/workflows/test-linux.yml)
[![macOS](https://github.com/nobu-g/dotfiles/actions/workflows/test-macos.yml/badge.svg)](https://github.com/nobu-g/dotfiles/actions/workflows/test-macos.yml)
[![lint](https://github.com/nobu-g/dotfiles/actions/workflows/lint.yml/badge.svg)](https://github.com/nobu-g/dotfiles/actions/workflows/lint.yml)

My dotfiles.

## Features
- [zsh](https://zsh.sourceforge.io)
- [Homebrew](https://brew.sh/) / [Linuxbrew](https://docs.brew.sh/Homebrew-on-Linux)
- [Zinit](https://github.com/zdharma/zinit)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [Mackup](https://github.com/lra/mackup)

## Setup

### For those who have sudo privileges

```bash
$ git clone https://github.com/nobu-g/dotfiles.git
$ cd dotfiles
$ make install SUDO=1
```

### For those who do not have sudo privileges

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

### macOS
Nothing (pre-installed).

### Ubuntu
- sudo, make, zsh
- gcc, build-essential, procps, curl, file, git

### CentOS
- sudo, make, zsh
- gcc, 'Development Tools', procps-ng curl file git
- perl-ExtUtils-MakeMaker, glibc-devel

### Fedora
- sudo, make, zsh
- gcc, 'Development Tools', procps-ng curl file git, libxcrypt-compat
- g++, perl-ExtUtils-MakeMaker, perl-FindBin, glibc-devel

### Rocky Linux
- sudo, make, zsh
- gcc, 'Development Tools', procps-ng curl file git
- perl-ExtUtils-MakeMaker, glibc-devel

## License

MIT
