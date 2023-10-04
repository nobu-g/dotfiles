#!/usr/bin/env bash

set -u

# packages to import from everywhere
pip3 install --user rhoknp

_pipx_install() {
  pipx install "$1" --python "${HOMEBREW_PREFIX}/opt/python@3.11/bin/python3.11"
}

# command-line tools
_pipx_install virtualenv # Virtual Python Environment builder
_pipx_install autopep8
_pipx_install flake8
_pipx_install trash-cli
_pipx_install speedtest-cli
# https://github.com/googlefonts/pyfontaine/issues/109#issuecomment-604872347
export PATH="${HOMEBREW_PREFIX}/opt/icu4c/bin:${HOMEBREW_PREFIX}/opt/icu4c/sbin:$PATH"
export PKG_CONFIG_PATH="${HOMEBREW_PREFIX}/opt/icu4c/lib/pkgconfig"
_pipx_install csvkit
_pipx_install pipenv           # Python Development Workflow for Humans.
_pipx_install poetry           # Python dependency management and packaging made easy.
_pipx_install ipython          # Interactive computing in Python
_pipx_install py-spy           # Sampling profiler for Python programs
_pipx_install httpie           # User-friendly cURL replacement (command-line HTTP client)
_pipx_install ansible-core     # Automate deployment, configuration, and upgrading
_pipx_install pre-commit       # Framework for managing multi-language pre-commit hooks
_pipx_install kwja             # A unified Japanese analyzer based on foundation models
_pipx_install openai-whisper   # Robust Speech Recognition via Large-Scale Weak Supervision
_pipx_install open-interpreter # Let language models run code locally.
