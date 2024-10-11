#!/usr/bin/env bash

set -u

# packages to import from everywhere
pip3 install --user rhoknp

_pipx_install_py312() {
  pipx install "$1" --python "${HOMEBREW_PREFIX}/opt/python@3.12/bin/python3.12"
}

_pipx_install_py313() {
  pipx install "$1" --python "${HOMEBREW_PREFIX}/opt/python@3.13/bin/python3.13"
}

# command-line tools
_pipx_install_py313 ipython       # Interactive computing in Python
_pipx_install_py313 poetry        # Python dependency management and packaging made easy.
_pipx_install_py313 pipenv        # Python Development Workflow for Humans.
_pipx_install_py313 pre-commit    # Framework for managing multi-language pre-commit hooks
_pipx_install_py313 ruff          # An extremely fast Python linter and code formatter, written in Rust.
_pipx_install_py313 speedtest-cli # Command line interface for testing internet bandwidth using speedtest.net
_pipx_install_py313 trash-cli     # Command line interface to FreeDesktop.org Trash.
_pipx_install_py313 uv            # An extremely fast Python package installer and resolver, written in Rust.
_pipx_install_py313 virtualenv    # Virtual Python Environment builder
# https://github.com/googlefonts/pyfontaine/issues/109#issuecomment-604872347
export PATH="${HOMEBREW_PREFIX}/opt/icu4c/bin:${HOMEBREW_PREFIX}/opt/icu4c/sbin:$PATH"
export PKG_CONFIG_PATH="${HOMEBREW_PREFIX}/opt/icu4c/lib/pkgconfig"
_pipx_install_py313 csvkit # A suite of command-line tools for working with CSV, the king of tabular file formats.

if [[ ${FULL_INSTALL} -eq 1 ]]; then
  _pipx_install_py313 py-spy           # Sampling profiler for Python programs
  _pipx_install_py313 httpie           # User-friendly cURL replacement (command-line HTTP client)
  _pipx_install_py313 ansible-core     # Automate deployment, configuration, and upgrading
  _pipx_install_py312 kwja             # A unified Japanese analyzer based on foundation models
  _pipx_install_py312 openai-whisper   # Robust Speech Recognition via Large-Scale Weak Supervision
  _pipx_install_py312 open-interpreter # Let language models run code locally.
fi
