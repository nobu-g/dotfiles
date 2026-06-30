# CLAUDE.md/AGENTS.md

This file is an **agent router**. It provides high-level rules and directs agents to the appropriate doc files for detailed instructions.

Detailed task-specific procedures are in `~/.config/claude/docs/*.md`.

## Environment

- This machine's environment is managed by a dotfiles repo (at `$GHQ_ROOT/github.com/nobu-g/dotfiles` or `~/dotfiles`). Edit the dotfiles source, not the deployed files.
- The Claude Code config dir is `~/.config/claude` (`CLAUDE_CONFIG_DIR`), **not** `~/.claude`. See [environment](docs/environment.md) for details.

## Hard Rules

Irreversible-action guardrails. These always apply, regardless of task:

- Never commit raw data, credentials, API keys, tokens, or customer-level records.
- Never modify, overwrite, delete, or regenerate raw data directly.

All other rules live in the docs below; consult them per the routing table.

## Routing Table

| Doc | Read when |
| --- | --------- |
| [coding-principles](docs/coding-principles.md) | **Before any coding task.** Language-agnostic rules on scope, simplicity, asking when unclear, and avoiding over-engineering. |
| [python-project-ops](docs/python-project-ops.md) | Managing dependencies, choosing a Python version, or running tests / lint / format / type checks. |
| [python-style](docs/python-style.md) | Writing, editing, or reviewing Python source — type hints, docstrings, imports, comments, error handling. |
| [dataframe-polars](docs/dataframe-polars.md) | Loading, filtering, joining, aggregating, or reshaping tabular data. |
| [path-and-io](docs/path-and-io.md) | Building file paths or reading / writing local files. |
| [environment](docs/environment.md) | Touching machine setup, dotfiles, shell, or Claude Code config — or when a path / symlink behaves unexpectedly. |
