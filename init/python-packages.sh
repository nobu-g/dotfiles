#!/usr/bin/env bash

set -u

export PYTHONUSERBASE="${HOME}/.local"

pip3 install --user autopep8
pip3 install --user trash-cli
pip3 install --user speedtest-cli
# https://github.com/googlefonts/pyfontaine/issues/109#issuecomment-604872347
export PATH="${HOMEBREW_PREFIX}/opt/icu4c/bin:${HOMEBREW_PREFIX}/opt/icu4c/sbin:$PATH"
export PKG_CONFIG_PATH="${HOMEBREW_PREFIX}/opt/icu4c/lib/pkgconfig"
pip3 install --user csvkit
pip3 install --user pipenv
pip3 install --user poetry
poetry completions zsh > "${HOME}/.zfunc/_poetry"
