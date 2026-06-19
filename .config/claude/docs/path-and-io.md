# Path and I/O

Standards for reading and writing local files: building paths, creating directories, and choosing output locations.

## Rules

- Use `pathlib.Path` for all file path operations; prefer `pathlib` over `os.path.*`.
- **Do not** hard-code absolute local paths.
- Prefer paths relative to repository root or configured directories.
- Create parent directories explicitly when writing outputs: `path.parent.mkdir(parents=True, exist_ok=True)`.
- Join paths with the `/` operator, including when joining a `Path` with a `str` (e.g. `base_dir / sub_dir / "file.txt"`); do not use `os.path.join` or `.joinpath(...)` for plain joins.
- When you need to call a method on a freshly joined path, use `.joinpath(...)` instead of wrapping a `/` expression in parentheses.

  - bad

    ```python
    (output_dir / "images").mkdir(parents=True, exist_ok=True)
    ```

  - good

    ```python
    output_dir.joinpath("images").mkdir(parents=True, exist_ok=True)
    ```

- Use descriptive file names.
- Include dates or run identifiers when outputs are time-dependent.
- Avoid overwriting existing outputs unless explicitly requested.

## Reading and Writing Files

- Avoid the `with open` idiom shown below; prefer the more concise `pathlib` form.

  - bad

    ```python
    with open("data/my_file.txt") as f:
        data = f.read()
    ```

  - good

    ```python
    data = Path("data/my_file.txt").read_text()
    ```

- The same applies to reading and writing JSON files.

  - bad

    ```python
    with open("data/my_file.json") as f:
        data = json.load(f)
    with open("data/my_file.json", mode="wt") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    ```

  - good

    ```python
    data = json.loads(Path("data/my_file.json").read_text())
    Path("data/my_file.json").write_text(json.dumps(data, indent=2, ensure_ascii=False))
    ```
