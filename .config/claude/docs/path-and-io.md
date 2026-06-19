# Path and I/O

ローカルファイルの読み書き（パス構築、ディレクトリ作成、出力先の選定）を行うときの規範。

## Rules

- Use `pathlib.Path` for all file path operations.
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

# 出力パスを構成
output_path = outputs_dir() / "tables" / "summary_2024q1.csv"

# 親ディレクトリを作成してから書き込み
ensure_parent_dir(output_path)
df.write_csv(output_path)