#!/usr/bin/env bash

set -u

_uv_install_py312() {
  uv tool install "$1" --python "${HOMEBREW_PREFIX}/opt/python@3.12/bin/python3.12"
}

_uv_install_py313() {
  uv tool install "$1" --python "${HOMEBREW_PREFIX}/opt/python@3.13/bin/python3.13"
}

# command-line tools
_uv_install_py313 csvkit        # A suite of command-line tools for working with CSV, the king of tabular file formats.
_uv_install_py313 ipython       # Interactive computing in Python
_uv_install_py313 poetry        # Python dependency management and packaging made easy.
_uv_install_py313 pre-commit    # Framework for managing multi-language pre-commit hooks
_uv_install_py313 rhoknp        # Yet another Python binding for Juman++/KNP/KWJA
_uv_install_py313 ruff          # An extremely fast Python linter and code formatter, written in Rust.
_uv_install_py313 ty            # An extremely fast Python type checker, written in Rust.
_uv_install_py313 speedtest-cli # Command line interface for testing internet bandwidth using speedtest.net
_uv_install_py313 trash-cli     # Command line interface to FreeDesktop.org Trash.
_uv_install_py313 virtualenv    # Virtual Python Environment builder

if [[ ${FULL_INSTALL} -eq 1 ]]; then
  _uv_install_py313 py-spy       # Sampling profiler for Python programs
  _uv_install_py313 httpie       # User-friendly cURL replacement (command-line HTTP client)
  _uv_install_py313 ansible-core # Automate deployment, configuration, and upgrading
  _uv_install_py313 ansible-lint # Checks playbooks for practices and behavior that could potentially be improved
  _uv_install_py312 kwja         # A unified Japanese analyzer based on foundation models
fi
