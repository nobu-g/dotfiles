#!/usr/bin/env bash

set -u

if ! (type uv &> /dev/null); then
  echo "uv is not installed. Skipping Python package installation."
  exit 0
fi

# command-line tools
uv tool install csvkit        # A suite of command-line tools for working with CSV, the king of tabular file formats.
uv tool install pre-commit    # Framework for managing multi-language pre-commit hooks
uv tool install rhoknp        # Yet another Python binding for Juman++/KNP/KWJA
uv tool install ruff          # An extremely fast Python linter and code formatter, written in Rust.
uv tool install speedtest-cli # Command line interface for testing internet bandwidth using speedtest.net
uv tool install trash-cli     # Command line interface to FreeDesktop.org Trash.
uv tool install virtualenv    # Virtual Python Environment builder
if [[ ${FULL_INSTALL} -eq 1 ]]; then
  uv tool install ansible-core # Automate deployment, configuration, and upgrading
  uv tool install ansible-lint # Checks playbooks for practices and behavior that could potentially be improved
  uv tool install httpie       # User-friendly cURL replacement (command-line HTTP client)
  uv tool install ipython      # Interactive computing in Python
  uv tool install kwja         # A unified Japanese analyzer based on foundation models
  uv tool install mypy         # Optional static typing for Python
  uv tool install poetry       # Python dependency management and packaging made easy.
  uv tool install py-spy       # Sampling profiler for Python programs
  uv tool install ty           # An extremely fast Python type checker, written in Rust.
fi
