# Python Project Operations

Standards for managing dependencies, running tests, linting, formatting, type checking, and executing notebooks.

## Tooling

- Use `uv` for package management.
- Use `ruff` for linting and formatting.
- Use `ty` for type checking.

## Package Manager: uv Only

- Use `uv` for all dependency installation, synchronization, addition, removal, and updates.
- **Never** use pip, pip3, `python -m pip`, poetry, conda, pipenv, or easy_install.
- **Never** manually create or edit `requirements.txt`.
- When running `uv` from a coding agent or sandboxed environment, set `UV_CACHE_DIR=./.uv_cache` so `uv` writes its cache inside the project instead of `~/.cache`.
- Use `uv add <package>` when adding dependencies.
- Use `uv add --group dev <package>` for dev-only dependencies.
- Review diffs in `pyproject.toml` and `uv.lock` after dependency changes.

## Declaring Dependencies

- Declare every directly imported third-party package in the appropriate
  dependency group in `pyproject.toml`; do not rely on transitive dependencies.
- Keep non-imported dependencies when the project uses them as command-line
  tools, plugins, build backends, entry points, type stubs, or data packages.

## Python Version

Two separate decisions — don't conflate them.

### `requires-python` (minimum supported version)

- Keep the project broadly installable across **all currently supported Python versions**. Don't pin to a single version.
- Rule of thumb: set the floor to **(oldest still-supported version) + 1**. Bumping the floor the moment the oldest version reaches end-of-life is a chore, so leaving one version of headroom avoids churn.
- As of 2026 the oldest supported version is 3.10, so use `requires-python = ">=3.11"`.

### Interpreter for building/running the dev environment

- Can be newer than the floor — there's no need to develop on the minimum.
- Avoid the very latest release; libraries often lag behind it. **(latest stable) - 1** is the safe default.
- As of 2026 that means Python 3.13. Pin it with `uv python pin 3.13` (writes `.python-version`).

## Common Commands

```bash
uv sync                    # Install/synchronize dependencies
uv run pytest              # Run tests
uv run ruff check .        # Lint
uv run ruff format .       # Format
uv run ty check            # Type check
```

## Workflow

1. In coding-agent or sandboxed environments, prefix `uv` commands with `UV_CACHE_DIR=./.uv_cache`.
2. After modifying `pyproject.toml`, run `uv sync`.
3. After adding code, run `uv run ruff check .` and `uv run ruff format .`.
4. Before committing, run `uv run pytest` and `uv run ty check`.
