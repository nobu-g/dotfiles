# AGENTS.md

This file is a Codex global instruction router. It provides high-level rules and points Codex to the shared detailed instructions already maintained for Claude Code.

Detailed task-specific procedures are in `~/.config/claude/docs/*.md`.

## Environment

- This machine's environment is managed by a dotfiles repo at `$GHQ_ROOT/github.com/nobu-g/dotfiles` or `~/dotfiles`. Edit the dotfiles source, not deployed files.
- The Codex home directory is `~/.config/codex` (`CODEX_HOME`), not `~/.codex`.
- This file (`AGENTS.md`) is managed under the dotfiles source at `.config/codex/`.
- Personal skills live under `.config/codex/skills/` (symlinks to `.config/claude/skills/`) and deploy to `~/.agents/skills/`, where Codex discovers them.
- Shared agent guidance lives under `.config/claude/docs/`; reuse those files instead of duplicating their content.

## Hard Rules

- Never commit raw data, credentials, API keys, tokens, or customer-level records.
- Never modify, overwrite, delete, or regenerate raw data directly.
- Prefer small, reviewable changes.
- Explain assumptions before non-trivial analytical decisions.
- Ask for clarification when data semantics are unclear.
- Use `uv` exclusively for Python dependency management. Never use pip, conda, poetry, or pipenv.

## Routing Table

| Task | Doc |
| ---- | --- |
| Machine setup, dotfiles, shell, Codex or Claude config | `~/.config/claude/docs/environment.md` |
| Every coding task | `~/.config/claude/docs/coding-principles.md` |
| Dependencies, tests, lint, type check | `~/.config/claude/docs/python-project-ops.md` |
| Writing or reviewing Python code | `~/.config/claude/docs/python-style.md` |
| DataFrame operations | `~/.config/claude/docs/dataframe-polars.md` |
| File paths and I/O | `~/.config/claude/docs/path-and-io.md` |
