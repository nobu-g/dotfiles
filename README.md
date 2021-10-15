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
git clone https://github.com/nobu-g/dotfiles.git
cd dotfiles
make install SUDO=1 [FULL_INSTALL=1]
```

### For those who do not have sudo privileges

```bash
git clone https://github.com/nobu-g/dotfiles.git
cd dotfiles
make install [FULL_INSTALL=1]
```
or using installer:
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/nobu-g/dotfiles/main/install.sh)"
```

## Requirements

### macOS
Nothing (requirements are pre-installed).

### Ubuntu
- `apt install sudo make zsh`
- `apt install gcc build-essential procps curl file git`
- `apt install python3-pip zlib-dev`

### CentOS
- `yum install sudo make zsh`
- `yum install gcc 'Development Tools' procps-ng curl file git`
- `yum install perl-ExtUtils-MakeMaker glibc-devel python3`

### Fedora
- `dnf install sudo make zsh`
- `dnf install gcc 'Development Tools' procps-ng curl file git libxcrypt-compat`
- `dnf install g++ perl-ExtUtils-MakeMaker perl-FindBin glibc-devel`

### Rocky Linux
- `dnf install sudo make zsh`
- `dnf install gcc 'Development Tools' procps-ng curl file git`
- `dnf install perl-ExtUtils-MakeMaker glibc-devel python3`

## License

MIT
