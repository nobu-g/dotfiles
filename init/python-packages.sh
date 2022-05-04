#!/usr/bin/env bash

set -u

# packages to import from everywhere
pip3 install --user pyknp

# command-line tools
pipx install virtualenv
pipx install autopep8
pipx install trash-cli
pipx install speedtest-cli
# https://github.com/googlefonts/pyfontaine/issues/109#issuecomment-604872347
export PATH="${HOMEBREW_PREFIX}/opt/icu4c/bin:${HOMEBREW_PREFIX}/opt/icu4c/sbin:$PATH"
export PKG_CONFIG_PATH="${HOMEBREW_PREFIX}/opt/icu4c/lib/pkgconfig"
pipx install csvkit
pipx install pipenv
pipx install poetry
poetry completions zsh > "${HOME}/.zfunc/_poetry"
pipx install kyoto-reader
pipx install ipython
pipx install py-spy
pipx install httpie
