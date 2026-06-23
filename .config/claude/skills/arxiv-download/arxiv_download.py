"""arXiv 本文ダウンローダ（レート制限付き・並列安全）.

エージェントが arxiv ID を特定したら、このスクリプトで本文を取得する。
WebFetch の ~660s stall を回避し、ローカルに数秒でキャッシュする。

Usage:
    python <skill_dir>/arxiv_download.py <arxiv_id>
    # → キャッシュ済みファイルのパスを stdout に出力
    # このスクリプトは arxiv-download スキルに同梱されている（SKILL.md と同じディレクトリ）。

キャッシュ先:
    既定では本スクリプトと同じディレクトリの cache/。
    環境変数 ARXIV_CACHE_DIR を設定すると、そのパスを使う（既存キャッシュの再利用などに）。

取得優先順:
    1. arxiv.org/html/<id>  (HTML版、軽量)
    2. ar5iv.labs.arxiv.org/html/<id>  (HTML版代替)
    3. arxiv.org/pdf/<id>   (PDF、重いが確実)

レート制限:
    flock + タイムスタンプファイルで、プロセス横断で 10秒に1リクエスト。
    5並列エージェントから同時に呼ばれても安全に直列化される。
"""

from __future__ import annotations

import fcntl
import os
import sys
import time
import urllib.error
import urllib.request
from pathlib import Path

# ── 設定 ──

MIN_INTERVAL = 10.0  # 秒: リクエスト間の最小間隔
FETCH_TIMEOUT = 60   # 秒: 1回のHTTPリクエストのタイムアウト

SCRIPT_DIR = Path(__file__).parent
CACHE_DIR = Path(os.environ["ARXIV_CACHE_DIR"]) if os.environ.get("ARXIV_CACHE_DIR") else SCRIPT_DIR / "cache"
LOCK_FILE = SCRIPT_DIR / ".fetch_lock"
TS_FILE = SCRIPT_DIR / ".fetch_timestamp"

UA = {"User-Agent": "Mozilla/5.0 (paper-reading-pipeline; arxiv-fetch)"}


# ── レート制限 ──

def _wait_for_rate_limit(lock_fd) -> None:
    """flock を保持した状態で、前回フェッチから MIN_INTERVAL 秒待つ."""
    try:
        last = float(TS_FILE.read_text().strip())
    except (FileNotFoundError, ValueError):
        last = 0.0
    elapsed = time.time() - last
    if elapsed < MIN_INTERVAL:
        wait = MIN_INTERVAL - elapsed
        print(f"[arxiv_download] rate limit: waiting {wait:.1f}s", file=sys.stderr)
        time.sleep(wait)


def _update_timestamp() -> None:
    TS_FILE.write_text(str(time.time()))


# ── フェッチ ──

def _fetch(url: str) -> tuple[int, bytes]:
    """URL を取得し (status, body) を返す."""
    req = urllib.request.Request(url, headers=UA)
    try:
        with urllib.request.urlopen(req, timeout=FETCH_TIMEOUT) as r:
            return r.status, r.read()
    except urllib.error.HTTPError as e:
        return e.code, b""
    except Exception:
        return 0, b""


def download(arxiv_id: str) -> Path | None:
    """arxiv ID の本文をキャッシュに取得し、パスを返す.

    既にキャッシュ済みならフェッチをスキップする。
    """
    CACHE_DIR.mkdir(parents=True, exist_ok=True)
    base_id = arxiv_id.split("v")[0]  # バージョンタグ除去

    # キャッシュチェック（HTML か PDF）
    for ext in (".html", ".pdf"):
        cached = CACHE_DIR / f"{base_id}{ext}"
        if cached.exists() and cached.stat().st_size > 1000:
            return cached

    # flock でプロセス横断の直列化
    LOCK_FILE.touch(exist_ok=True)
    # LOCK_EX は書き込み可能な fd を要求するファイルシステムがある（overlayfs 等）。
    # 読み取り専用("r")だと "Bad file descriptor" になるため追記モードで開く。
    lock_fd = open(LOCK_FILE, "a")
    try:
        fcntl.flock(lock_fd, fcntl.LOCK_EX)  # 排他ロック（他プロセスはここで待つ）

        # ロック取得後に再度キャッシュチェック（他プロセスがフェッチ済みかも）
        for ext in (".html", ".pdf"):
            cached = CACHE_DIR / f"{base_id}{ext}"
            if cached.exists() and cached.stat().st_size > 1000:
                return cached

        _wait_for_rate_limit(lock_fd)

        # 1. arxiv HTML
        urls = [
            (f"https://arxiv.org/html/{arxiv_id}", ".html"),
            (f"https://ar5iv.labs.arxiv.org/html/{base_id}", ".html"),
            (f"https://arxiv.org/pdf/{base_id}", ".pdf"),
        ]
        for url, ext in urls:
            print(f"[arxiv_download] fetching {url}", file=sys.stderr)
            status, body = _fetch(url)
            _update_timestamp()
            if status == 200 and len(body) > 1000:
                out = CACHE_DIR / f"{base_id}{ext}"
                out.write_bytes(body)
                print(f"[arxiv_download] saved {out} ({len(body)//1024}KB)", file=sys.stderr)
                return out
            print(f"[arxiv_download]   -> {status} ({len(body)}B), trying next", file=sys.stderr)
            # 次の URL も rate limit 守る
            _wait_for_rate_limit(lock_fd)

        print(f"[arxiv_download] all sources failed for {arxiv_id}", file=sys.stderr)
        return None

    finally:
        fcntl.flock(lock_fd, fcntl.LOCK_UN)
        lock_fd.close()


# ── CLI ──

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} <arxiv_id>", file=sys.stderr)
        sys.exit(1)
    arxiv_id = sys.argv[1].strip()
    result = download(arxiv_id)
    if result:
        print(result)  # stdout にパスを出力（エージェントが読む）
    else:
        print(f"FAILED: could not download {arxiv_id}", file=sys.stderr)
        sys.exit(1)
