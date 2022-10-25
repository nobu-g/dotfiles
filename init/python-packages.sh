#!/usr/bin/env bash

set -u

# packages to import from everywhere
pip3 install --user rhoknp

# command-line tools
pipx install virtualenv
pipx install autopep8
pipx install flake8
pipx install trash-cli
pipx install speedtest-cli
# https://github.com/googlefonts/pyfontaine/issues/109#issuecomment-604872347
export PATH="${HOMEBREW_PREFIX}/opt/icu4c/bin:${HOMEBREW_PREFIX}/opt/icu4c/sbin:$PATH"
export PKG_CONFIG_PATH="${HOMEBREW_PREFIX}/opt/icu4c/lib/pkgconfig"
pipx install csvkit
pipx install pipenv
pipx install poetry
pipx install kyoto-reader
pipx install ipython      # Interactive computing in Python
pipx install py-spy       # Sampling profiler for Python programs
pipx install httpie       # User-friendly cURL replacement (command-line HTTP client)
pipx install ansible-core # Automate deployment, configuration, and upgrading
pipx install pre-commit   # Framework for managing multi-language pre-commit hooks
