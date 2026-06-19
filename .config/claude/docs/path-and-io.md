# Path and I/O

Standards for reading and writing local files: building paths, creating directories, and choosing output locations.

## Rules

- Use `pathlib.Path` for all file path operations; prefer `pathlib` over `os.path.*`.
- **Do not** hard-code absolute local paths.
- Prefer paths relative to repository root or configured directories.
- Use the path utilities in `src/analysis_project/paths.py`.
- **Do not** write outputs into raw data directories (`data/raw/`, `data/external/`).
- Create parent directories explicitly when writing outputs: `path.parent.mkdir(parents=True, exist_ok=True)`.
- Use descriptive file names.
- Include dates or run identifiers when outputs are time-dependent.
- Avoid overwriting existing outputs unless explicitly requested.

## Example

```python
from analysis_project.paths import outputs_dir, ensure_parent_dir

# Build the output path
output_path = outputs_dir() / "tables" / "summary_2024q1.csv"

# Create the parent directory before writing
ensure_parent_dir(output_path)
df.write_csv(output_path)
```

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