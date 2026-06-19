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
- Use `uv add <package>` when adding dependencies.
- Use `uv add --group dev <package>` for dev-only dependencies.
- Review diffs in `pyproject.toml` and `uv.lock` after dependency changes.

## Python Version

- Python 3.11.

## Common Commands

```bash
uv sync                    # Install/synchronize dependencies
uv run pytest              # Run tests
uv run ruff check .        # Lint
uv run ruff format .       # Format
uv run ty check            # Type check
uv run papermill notebooks/input.ipynb notebooks/output.ipynb  # Execute notebook
bash scripts/run_quality_checks.sh  # Run all quality checks
```

## Workflow

1. After modifying `pyproject.toml`, run `uv sync`.
2. After adding code, run `uv run ruff check .` and `uv run ruff format .`.
3. Before committing, run `uv run pytest` and `uv run ty check`.
4. For notebook execution in CI or automation, prefer `papermill`.
