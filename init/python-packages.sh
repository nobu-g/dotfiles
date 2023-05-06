#!/usr/bin/env bash

set -u

# packages to import from everywhere
pip3 install --user rhoknp

_pipx_install() {
  pipx install "$1" --python "${HOMEBREW_PREFIX}/opt/python@3.11/bin/python3.11"
}

# command-line tools
_pipx_install virtualenv
_pipx_install autopep8
_pipx_install flake8
_pipx_install trash-cli
_pipx_install speedtest-cli
# https://github.com/googlefonts/pyfontaine/issues/109#issuecomment-604872347
export PATH="${HOMEBREW_PREFIX}/opt/icu4c/bin:${HOMEBREW_PREFIX}/opt/icu4c/sbin:$PATH"
export PKG_CONFIG_PATH="${HOMEBREW_PREFIX}/opt/icu4c/lib/pkgconfig"
_pipx_install csvkit
_pipx_install pipenv
_pipx_install poetry
_pipx_install kyoto-reader
_pipx_install ipython      # Interactive computing in Python
_pipx_install py-spy       # Sampling profiler for Python programs
_pipx_install httpie       # User-friendly cURL replacement (command-line HTTP client)
_pipx_install ansible-core # Automate deployment, configuration, and upgrading
_pipx_install pre-commit   # Framework for managing multi-language pre-commit hooks
