# Global Coding Agent Instructions

This file is a global instruction router for coding agents.
Detailed task-specific instructions are in `~/.config/claude/docs/*.md`.

## Environment

- This machine is managed by a dotfiles repo at `$GHQ_ROOT/github.com/nobu-g/dotfiles` or `~/dotfiles`. Before changing machine setup, shell configuration, or agent configuration, read `docs/environment.md` and edit the corresponding source in this repo rather than its deployed copy.

## Hard Rules

- Never commit raw data, credentials, API keys, tokens, or customer-level records.
- Never modify, overwrite, delete, or regenerate data identified as raw or source data. If its status is unclear and the task would mutate it, ask first.
- A question is a request for an answer, not for the work it describes. Answer it, propose the change, and stop. Implement only when explicitly instructed; see `Act only on explicit instructions` in `docs/coding-principles.md`.
- Never run `git commit`, `git push`, or any history-rewriting command unless the user asks for it in that message.

## Routing Table

Read the matching document before your first edit in that area, and state in one line which you read.
Paths are absolute: `~/.config/claude/docs/<name>.md` — never resolve them against the project.

- Any coding task: `coding-principles.md`
- Editing Python source: `python-style.md`
- Adding deps, changing Python versions, or running tests/lint/format/type checks: `python-project-ops.md`
- Editing a Streamlit app: `streamlit.md`
- Writing DataFrame code: `dataframe-polars.md`
- Writing path or file I/O code: `path-and-io.md`
- Changing machine, shell, or agent configuration: `environment.md`
