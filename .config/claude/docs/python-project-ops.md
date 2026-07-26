# Python Project Operations

Standards for managing dependencies, Python versions, and project validation.

## Tooling

- Use `uv` for dependency and environment management. Never invoke `pip`,
  `pip3`, `python -m pip`, Poetry, Conda, Pipenv, or EasyInstall.
- Use `ruff` for linting and formatting.
- Use `ty` for type checking.
- In coding-agent or sandboxed environments, set
  `UV_CACHE_DIR=./.uv_cache` to avoid writing to a home-directory cache.

## Declaring Dependencies

- Preserve an existing project's dependency manifest and lockfile format unless
  the task requires a migration. For new projects, use `pyproject.toml` and
  `uv.lock`.
- In a uv-managed project, use `uv add <package>` for runtime dependencies and
  `uv add --group dev <package>` for development dependencies.
- Declare every directly imported third-party package in the project's
  appropriate runtime or development dependency group; do not rely on
  transitive dependencies.
- Keep non-imported dependencies when the project uses them as command-line
  tools, plugins, build backends, entry points, type stubs, or data packages.
- After dependency changes, synchronize the environment and review the manifest
  and lockfile diffs.

## Python Version

- In an existing project, follow `requires-python`, the CI matrix, and the
  existing `.python-version`.
- For a new project, choose the minimum supported version from its target
  environment and dependencies after checking the current CPython support
  status.
- Keep `requires-python` as a supported range. Pin the development interpreter
  separately with `uv python pin <version>`.

## Validation

```bash
uv sync
uv run pytest path/to/test_file.py
pre-commit run --files path/to/changed_file.py
```

- Follow project-specific validation commands when present.
- Use pre-commit as the canonical runner for linting, formatting, and type
  checking. Start with the changed files; use `pre-commit run --all-files` when
  full-project validation is required.
- If the project declares `ruff` and `ty` as development dependencies, use
  `uv run ruff ...` and `uv run ty ...` for ad hoc checks.
- Broaden tests, linting, formatting checks, and type checks when required by
  project instructions or warranted by the change's scope and risk.
