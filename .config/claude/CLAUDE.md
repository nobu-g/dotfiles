# CLAUDE.md/AGENTS.md

This file is an **agent router**. It provides high-level rules and directs agents to the appropriate doc files for detailed instructions.

Detailed task-specific procedures are in `~/.config/claude/docs/*.md`.

## Environment

- This machine's environment is managed by a dotfiles repo (at `$GHQ_ROOT/github.com/nobu-g/dotfiles` or `~/dotfiles`). Edit the dotfiles source, not the deployed files.
- The Claude Code config dir is `~/.config/claude` (`CLAUDE_CONFIG_DIR`), **not** `~/.claude`. See [environment](docs/environment.md) for details.

## Hard Rules (Always Apply)

- Never commit raw data, credentials, API keys, tokens, or customer-level records.
- Never modify, overwrite, delete, or regenerate raw data directly.
- Prefer small, reviewable changes.
- Explain assumptions before non-trivial analytical decisions.
- Ask for clarification when data semantics are unclear.
- Use `uv` exclusively for Python dependency management. Never use pip, conda, poetry, or pipenv.

## Routing Table

| Task | Doc |
| ---- | --- |
| Machine setup, dotfiles, shell, Claude config | [environment](docs/environment.md) |
| Every coding task (start here) | [coding-principles](docs/coding-principles.md) |
| Dependencies, tests, lint, type check | [python-project-ops](docs/python-project-ops.md) |
| Writing or reviewing Python code | [python-style](docs/python-style.md) |
| DataFrame operations | [dataframe-polars](docs/dataframe-polars.md) |
| File paths and I/O | [path-and-io](docs/path-and-io.md) |
