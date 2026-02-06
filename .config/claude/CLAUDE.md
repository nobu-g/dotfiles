# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code)

- コード中のコメントやメッセージは英語で記述してください。
- ユーザーからの指示や仕様に疑問などがあれば作業を中断し、質問すること。
- 一般的なコーディング規約をを遵守すること。（Python プロジェクトであれば PEP8）
- レポジトリ直下に `.pre-commit-config.yaml` がある場合は、編集後のコードが pre-commit をパスすることを確認すること。
- 特に指定されない限り**後方互換性は無視**し、できる限りシンプルなコードを書くこと。
- 保守性を重視し、冗長なコードや複雑なコードは避けること。

## Python

- パッケージ管理では基本的に `uv` を使用すること
- linting, formatting では基本的に `ruff` を使用すること
- type checking では基本的に `ty` を使用すること
- ファイル操作では基本的に `os.path.*` ではなく `pathlib` を使用すること
- データ処理では基本的に `pandas` ではなく `polars` を使用すること

### Type hinting ルール

- できる限り型を明示して可読性の向上に努めてください。
  - `files: list` -> `files: list[Path]`
- ただし、type hinting が冗長にならないようにしてください。
  - `path: Path = Path("./data")` -> `path = Path("./data")`
- Python >=3.9 を想定し、typing module から import した型（e.g., `Dict`, `List`）の使用を避けてください。
  - `from typing import Dict` -> `dict`

### その他コーディングルール

- 以下のように `with open`構文の使用は避け、`pathlib`を使ってより簡潔に書いてください。

  - bad

    ```python
    with open("data/my_file.txt") as f:
    data = f.read()
    ```

  - good

    ```python
    data = Path("data/my_file.txt").read_text()
    ```

- JSONファイルの読み書きも同様です。
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
