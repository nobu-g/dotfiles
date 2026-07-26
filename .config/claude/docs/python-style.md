# Python Style

Standards for writing, editing, and reviewing Python code.

## Type Hints

- Add type hints to all public function signatures and non-obvious internal
  boundaries.
- Use syntax supported by the project's minimum Python version.
- Prefer precise types such as `list[Path]` over unparameterized containers.
- Omit annotations that only repeat an obvious inferred type.

## Docstrings

- Use Google-style docstrings for public APIs when their behavior, contract,
  exceptions, or assumptions are not self-evident.
- Omit sections that add no information.

## Code Style

- Follow project-local conventions and the `ruff` configuration in
  `pyproject.toml`.
