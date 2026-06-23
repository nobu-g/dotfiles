# Environment

How this machine's environment is set up and managed.

## Dotfiles repo

- This machine's environment (shell config, Homebrew/uv/cargo packages, application configs, etc.) is managed by a dotfiles repo.
- It usually lives at `$GHQ_ROOT/github.com/nobu-g/dotfiles` (most commonly `~/Projects/github.com/nobu-g/dotfiles`), but is sometimes at `~/dotfiles`.
- Files there are symlinked into place by `make deploy`, and packages are installed via `make init`.
- To change the system setup, edit the dotfiles source rather than the deployed files.

## Claude Code config

- The Claude Code config directory is `~/.config/claude` (set via `CLAUDE_CONFIG_DIR`), **not** the default `~/.claude`. Write all settings (`settings.json`, `statusline-command.sh`, etc.) here.
- This config dir is managed by the dotfiles repo (under its `.config/claude/`). Files there are symlinked into `~/.config/claude` by `make deploy`. To change global Claude Code config, edit the dotfiles source and reference paths via `${CLAUDE_CONFIG_DIR:-$HOME/.config/claude}`.

## Shell

- The login shell is zsh with `ZDOTDIR=~/.zsh`.
- The config is split into modular files under `.zsh.d/.zshrc.d/` (aliases, completion, keybindings, etc.) in the dotfiles repo.
