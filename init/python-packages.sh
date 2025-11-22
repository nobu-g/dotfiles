#!/usr/bin/env bash

set -u

_uv_install_py313() {
  uv tool install "$1" --python "${HOMEBREW_PREFIX}/opt/python@3.13/bin/python3.13"
}

_uv_install_py314() {
  uv tool install "$1" --python "${HOMEBREW_PREFIX}/opt/python@3.14/bin/python3.14"
}

# command-line tools
_uv_install_py314 csvkit        # A suite of command-line tools for working with CSV, the king of tabular file formats.
_uv_install_py314 pre-commit    # Framework for managing multi-language pre-commit hooks
_uv_install_py314 rhoknp        # Yet another Python binding for Juman++/KNP/KWJA
_uv_install_py314 ruff          # An extremely fast Python linter and code formatter, written in Rust.
_uv_install_py314 speedtest-cli # Command line interface for testing internet bandwidth using speedtest.net
_uv_install_py314 trash-cli     # Command line interface to FreeDesktop.org Trash.
_uv_install_py314 virtualenv    # Virtual Python Environment builder
if [[ ${FULL_INSTALL} -eq 1 ]]; then
  _uv_install_py314 ansible-core # Automate deployment, configuration, and upgrading
  _uv_install_py314 ansible-lint # Checks playbooks for practices and behavior that could potentially be improved
  _uv_install_py314 httpie       # User-friendly cURL replacement (command-line HTTP client)
  _uv_install_py314 ipython      # Interactive computing in Python
  _uv_install_py313 kwja         # A unified Japanese analyzer based on foundation models
  _uv_install_py314 mypy         # Optional static typing for Python
  _uv_install_py314 poetry       # Python dependency management and packaging made easy.
  _uv_install_py314 py-spy       # Sampling profiler for Python programs
  _uv_install_py314 ty           # An extremely fast Python type checker, written in Rust.
fi
