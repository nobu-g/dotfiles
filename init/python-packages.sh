#!/usr/bin/env bash

set -ux

export PYTHONUSERBASE="$HOME/.local"

pip3 install --user autopep8
pip3 install --user trash-cli
pip3 install --user speedtest-cli
# https://github.com/googlefonts/pyfontaine/issues/109#issuecomment-604872347
export PATH="$BREW_PREFIX/opt/icu4c/bin:$BREW_PREFIX/opt/icu4c/sbin:$PATH"
export PKG_CONFIG_PATH="$BREW_PREFIX/opt/icu4c/lib/pkgconfig"
ls "$BREW_PREFIX/opt/icu4c/bin" # debug print
pip3 install --user csvkit
pip3 install --user pipenv
pip3 install --user poetry
