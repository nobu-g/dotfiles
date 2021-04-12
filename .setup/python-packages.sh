#!/usr/bin/env bash

set -ue

source "$(dirname "${BASH_SOURCE[0]:-$0}")/utils.sh"

pip3 install --user autopep8
pip3 install --user trash-cli
pip3 install --user speedtest-cli
pip3 install --user csvkit
