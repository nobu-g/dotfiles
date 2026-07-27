# Python Style

Standards for writing, editing, and reviewing Python code.

## Type Hints

- Add type hints to all public function signatures and non-obvious internal boundaries.
- Use syntax supported by the project's minimum Python version.
- Prefer precise types such as `list[Path]` over unparameterized containers.
- Omit annotations that only repeat an obvious inferred type.

## Docstrings

- Use Google-style docstrings for public APIs when their behavior, contract, exceptions, or assumptions are not self-evident.
- Omit sections that add no information.

## Data Modeling

- Use `@dataclass(frozen=True)` for plain internal data, and pydantic v2 `BaseModel` where validation or serialization matters (config, schemas, API payloads). Both coexist in one project — pick per use.

## Logging

- Log through stdlib `logging` with a module-level `logger = logging.getLogger(__name__)`. `loguru` is not used.
- `print` is fine for CLI output.

## Code Style

- Follow project-local conventions and the `ruff` configuration in `pyproject.toml`.
