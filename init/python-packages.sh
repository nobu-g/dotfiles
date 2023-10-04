#!/usr/bin/env bash

set -u

# packages to import from everywhere
pip3 install --user rhoknp

_pipx_install_py311() {
  pipx install "$1" --python "${HOMEBREW_PREFIX}/opt/python@3.11/bin/python3.11"
}

_pipx_install_py312() {
  pipx install "$1" --python "${HOMEBREW_PREFIX}/opt/python@3.12/bin/python3.12"
}

# command-line tools
_pipx_install_py312 virtualenv # Virtual Python Environment builder
_pipx_install_py312 autopep8
_pipx_install_py312 flake8
_pipx_install_py312 trash-cli
_pipx_install_py312 speedtest-cli
# https://github.com/googlefonts/pyfontaine/issues/109#issuecomment-604872347
export PATH="${HOMEBREW_PREFIX}/opt/icu4c/bin:${HOMEBREW_PREFIX}/opt/icu4c/sbin:$PATH"
export PKG_CONFIG_PATH="${HOMEBREW_PREFIX}/opt/icu4c/lib/pkgconfig"
_pipx_install_py312 csvkit
_pipx_install_py312 pipenv           # Python Development Workflow for Humans.
_pipx_install_py312 poetry           # Python dependency management and packaging made easy.
_pipx_install_py312 ipython          # Interactive computing in Python
_pipx_install_py312 py-spy           # Sampling profiler for Python programs
_pipx_install_py312 httpie           # User-friendly cURL replacement (command-line HTTP client)
_pipx_install_py312 ansible-core     # Automate deployment, configuration, and upgrading
_pipx_install_py312 pre-commit       # Framework for managing multi-language pre-commit hooks
_pipx_install_py311 kwja             # A unified Japanese analyzer based on foundation models
_pipx_install_py311 openai-whisper   # Robust Speech Recognition via Large-Scale Weak Supervision
_pipx_install_py311 open-interpreter # Let language models run code locally.
