---
name: arxiv-download
description: arXiv論文の本文をローカルにダウンロードする。arxiv IDまたは論文タイトルを受け取り、HTML版(優先)→ar5iv→PDFのフォールバックで取得。レート制限(10秒/回)とキャッシュ付き。ユーザーが「arxivから論文をダウンロードして」「arxiv-download」「論文の本文を取得して」「<arxiv_id>をダウンロード」などと言ったときに使う。
---

# arXiv 論文ダウンロード

arXiv の論文本文をローカルにキャッシュ取得する。WebFetch より高速（~10秒 vs ~11分）で、レート制限・キャッシュ・並列安全を備える。

## 使い方

### arxiv ID が分かっている場合

ダウンロードスクリプト `arxiv_download.py` はこの SKILL.md と同じディレクトリに同梱されている。スキルディレクトリ内のスクリプトを実行する:

```bash
python "$(dirname "$0")/arxiv_download.py" <arxiv_id>   # シェルスクリプト内の場合
# もしくはスキルディレクトリの絶対パスで直接:
python ~/.config/claude/skills/arxiv-download/arxiv_download.py <arxiv_id>
```

stdout にキャッシュ済みファイルのパス（HTML or PDF）が出力される。そのファイルを Read で読めば本文が得られる。

例:

```bash
python ~/.config/claude/skills/arxiv-download/arxiv_download.py 2501.00663
# → ~/.config/claude/skills/arxiv-download/cache/2501.00663.html
```

### タイトルしか分からない場合

1. WebSearch でタイトルを検索し、arxiv ID を特定する
2. 上記コマンドで本文を取得する

## 取得優先順
1. `arxiv.org/html/<id>` — HTML版（軽量、~400KB）
2. `ar5iv.labs.arxiv.org/html/<id>` — HTML代替
3. `arxiv.org/pdf/<id>` — PDF（重い、~3MB、最終手段）

## 仕様
- **レート制限**: flock + タイムスタンプで 10秒/回（並列呼び出しでも安全に直列化）
- **キャッシュ**: 2回目以降は即座（~0.1秒）で返る。キャッシュ先は既定でスキルディレクトリ内の `cache/`（`~/.config/claude/skills/arxiv-download/cache/`）。環境変数 `ARXIV_CACHE_DIR` を設定すると別の場所を使う（既存キャッシュの再利用などに）。
- **arXiv に無い論文**: スクリプトが `FAILED` で終了する。WebSearch の結果や他のソースで対応する

## 注意
- スクリプトはスキルに同梱（`arxiv_download.py`、SKILL.md と同じディレクトリ）。外部パスへの依存は無く、スキル単体で完結する。
- cache / .fetch_lock / .fetch_timestamp はランタイム生成物で、スキルディレクトリの `.gitignore` で版管理対象外にしている。
- 社内プロキシ環境では `export.arxiv.org`（API）が到達不能な場合がある。`arxiv.org` 本体（HTML/PDF）は通常アクセス可能
