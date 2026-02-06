# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository that provides a comprehensive development environment setup for macOS and Linux systems. The repository includes shell configuration (zsh), package management (Homebrew), and various development tools.

## Key Commands

### Installation and Setup

- `make install [SUDO=1] [FULL_INSTALL=1]` - Full installation (update, init, deploy)
- `make deploy` - Create symlinks to home directory
- `make init` - Setup environment settings and install packages
- `make update` - Fetch changes from main branch
- `make upgrade` - Upgrade all installed packages (Homebrew, pip, zinit)
- `make test` - Test if expected tools are installed

### Installation via Installer Script

```bash
[SUDO=1] [FULL_INSTALL=1] sh -c "$(curl -fsSL https://raw.githubusercontent.com/nobu-g/dotfiles/main/install.sh)"
```

Environment variables:

- `SUDO=1` - Use if you have sudo privileges
- `FULL_INSTALL=1` - Install all packages from Brewfile.full
- `HOMEBREW_PREFIX=/path` - Custom Homebrew installation directory

### Testing

- `make test` - Run comprehensive test suite checking installed tools, aliases, and functions
- `zsh -i test/main.zsh` - Run tests directly

## Architecture

### Configuration Structure

- `.zsh.d/` - Zsh configuration files
  - `.zshenv`, `.zprofile`, `.zshrc`, `.p10k.zsh` - Main zsh config files
  - `.zshrc.d/` - Modular zsh configuration (aliases, completion, keybindings, etc.)
- `.config/` - Application configurations (symlinked to ~/.config)
- `deploy/` - Symlink management and macOS launch agents
- `init/` - Package installation scripts organized by platform

### Package Management

- `init/homebrew/` - Homebrew setup and Brewfiles for different platforms
  - `Brewfile` - Core packages
  - `Brewfile.full` - Extended packages (with FULL_INSTALL=1)
  - `macos/` and `linux/` - Platform-specific packages
- `init/python-packages.sh` - Python tools via uv/pipx
- `init/rust-packages.sh` - Rust packages via cargo
- `init/node-packages.sh` - Node.js packages

### Deployment System

The `deploy/main.sh` script creates symlinks from the dotfiles directory to appropriate locations:
- Zsh configs → `$ZDOTDIR` (default: `~/.zsh`)
- Application configs → `~/.config`
- Binaries → `~/.local/bin`
- macOS-specific: Mackup configs and launch agents

### Platform Detection

Scripts use `$OSTYPE` environment variable to handle platform differences:
- `darwin*` / `freebsd*` - macOS
- `linux*` / `cygwin*` - Linux systems

## Development Workflow

1. **Making Changes**: Edit files in their respective directories (`.zsh.d/`, `.config/`, etc.)
2. **Testing Changes**: Run `make test` to verify installation
3. **Deploying**: Run `make deploy` to update symlinks
4. **Full Setup**: Use `make install` for complete environment setup

## Important Files

- `Makefile` - Main automation interface
- `install.sh` - Remote installation script
- `deploy/main.sh` - Symlink deployment logic
- `init/main.sh` - Environment initialization
- `test/main.zsh` - Test suite for verifying installation
