# Repository Guidelines

## Project Structure & Module Organization
- `Makefile` is the main entry point for setup, deployment, updates, and tests.
- `init/` contains installation logic (`main.sh`) plus platform-specific package definitions in `init/homebrew/{macos,linux}/`.
- `deploy/` manages symlinks and macOS launch-agent files (`deploy/launchd_jobs/*.plist`).
- `.zsh.d/` holds shell startup files and modular zsh config in `.zshrc.d/` and `.zfunc/`.
- `.config/` stores app configs to be linked into `~/.config` (git, tmux, bat, doom, etc.).
- `bin/` includes helper scripts, `dockerfile/` provides Linux test images, and `test/main.zsh` is the runtime verification script.

## Build, Test, and Development Commands
- `make help`: list available targets.
- `make install [SUDO=1] [FULL_INSTALL=1]`: run update + init + deploy.
- `make init [SUDO=1] [FULL_INSTALL=1]`: install packages and environment dependencies only.
- `make deploy`: refresh symlinks into the home directory.
- `make test`: run `zsh -i test/main.zsh` to verify tools, aliases, and functions.
- `pre-commit run --all-files`: run local formatting/lint checks before pushing.

## Coding Style & Naming Conventions
- Shell scripts are the primary implementation language; keep scripts executable and include a correct shebang (`sh`, `bash`, or `zsh`).
- Use 2-space indentation for shell files (enforced by `shfmt` in pre-commit).
- Prefer small, composable scripts and clear function names (`checkinstall`, `dotfiles_download`).
- Keep filenames lowercase and hyphenated for scripts (for example, `python-packages.sh`).

## Testing Guidelines
- Primary validation is command-level smoke testing via `make test`.
- CI runs on pushes to `main`: lint (`shellcheck`, `pre-commit`), Linux matrix tests (Ubuntu/Debian/Fedora Docker), and macOS install/test.
- There is no numeric coverage gate; contributors should ensure changed setup paths are exercised on at least one target OS.

## Commit & Pull Request Guidelines
- Use short, imperative commit subjects consistent with history (for example, `fix test-linux`, `update Brewfile`, `add CODEX_HOME`).
- Keep commits focused by concern (install logic, config updates, CI, docs).
- PRs should include: what changed, why, affected OS targets, and commands run locally (for example, `make test`, `pre-commit run --all-files`).
- Link related issues when applicable and include terminal output snippets when behavior changes are not obvious.

## Security & Configuration Tips
- Do not commit secrets, host-specific tokens, or machine-local credentials.
- Review changes to `install.sh`, `init/main.sh`, and `deploy/main.sh` carefully; they execute privileged or login-shell-affecting operations.
