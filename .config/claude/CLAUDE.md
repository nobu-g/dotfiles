# Global Coding Agent Instructions

This file is a global instruction router for coding agents.
Detailed task-specific instructions are in `~/.config/claude/docs/*.md`.

## Environment

- This machine is managed by a dotfiles repo at `$GHQ_ROOT/github.com/nobu-g/dotfiles` or `~/dotfiles`. Before changing machine setup, shell configuration, or agent configuration, read `docs/environment.md` and edit the corresponding source in this repo rather than its deployed copy.

## Hard Rules

- Never commit raw data, credentials, API keys, tokens, or customer-level records.
- Never modify, overwrite, delete, or regenerate data identified as raw or source data. If its status is unclear and the task would mutate it, ask first.

## Routing Table

Before acting, read every document that applies:

- Any coding task: `docs/coding-principles.md`
- Dependencies, Python versions, tests, lint, formatting, or type checks: `docs/python-project-ops.md`
- Python source: `docs/python-style.md`
- Streamlit applications: `docs/streamlit.md`
- DataFrame operations: `docs/dataframe-polars.md`
- File paths or I/O: `docs/path-and-io.md`
- Machine setup, shell configuration, agent configuration, paths, or symlinks: `docs/environment.md`
