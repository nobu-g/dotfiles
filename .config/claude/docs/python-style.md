# Python Style

Standards for writing, editing, and reviewing Python code: type hints, docstrings, naming, imports, error handling, and structure.

## Type Hints

- Add type hints to all public function signatures.
- Use `from __future__ import annotations` when convenient.
- Be as explicit as possible with types to improve readability.
  - `files: list` -> `files: list[Path]`
- However, do not let type hints become redundant.
  - `path: Path = Path("./data")` -> `path = Path("./data")`
- Assume Python >= 3.9; avoid types imported from the `typing` module (e.g., `Dict`, `List`).
  - `from typing import Dict` -> `dict`

## Docstrings

- Use **Google-style** docstrings for all public modules, classes, functions, and methods.
- Docstrings should describe:
  - Purpose
  - Args
  - Returns
  - Raises (if applicable)
  - Examples (when helpful)
  - Important assumptions

## Comments

- **Inline comments and explanatory comments must be written in English.**
- Comments should explain non-obvious intent, assumptions, or business logic.
- Do not comment obvious syntax.

## Code Style

- Prefer small, pure functions where practical.
- Prefer explicit error handling over bare `except`.
- Use `pathlib.Path` for file paths — see [path-and-io](path-and-io.md).
- Follow `ruff` linting and formatting rules configured in `pyproject.toml`.
