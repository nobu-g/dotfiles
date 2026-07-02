---
name: debug-actions-test-linux
description: この dotfiles リポジトリの test-linux CI(Linuxbrew を非標準 HOMEBREW_PREFIX に入れ、全部ソースビルドする Docker ベースのジョブ)が失敗したときのデバッグ手法。速い再現ループの作り方・ログの読み方・失敗の分類・使えるレバー(Homebrew の env/フラグ)をまとめた汎用プレイブック。既知の個別事例(openssl@3 の TLS 崩壊など)は一例として収録するが、起き得るエラーは多様なので方法論を優先する。ユーザーが「test-linux を直して」「brew/homebrew の CI が落ちる/ハング/タイムアウト」「test workflow を修正」等と言ったときに使う。ローカルの Docker で最小限検証した後、実環境の GitHub Actions で最小再現するのが要点。
---

# dotfiles test-linux CI デバッグ・プレイブック

`.github/workflows/test-linux.yml` は各ディストリ(ubuntu/ubuntu26.04/debian/fedora)の Docker で
`make init deploy`(インストール実体は `init/homebrew/main.sh`)→ `make test`(導入済みツール検査)を回す。
このジョブは**多様な理由で壊れる**。個別の対症療法を覚えるのではなく、下の方法論で毎回切り分ける。

## メンタルモデル:なぜ多様に壊れるか

`HOMEBREW_PREFIX=/home/user/.linuxbrew` は**非標準(かつ意図的で変更不可)**。標準 prefix でないと Homebrew の
bottle が使えず、**ほぼ全 formula がソースビルド**になる。ソースビルドは以下すべてに晒され、どれでも落ちる:

- 上流ソース URL/ミラーの死活(404・部分DL)、チェックサム不一致、バージョン bump
- ビルド依存の不足・コンパイラ/arch 固有の不具合(SIGILL 等)
- formula の `post_install`/`test do` の失敗、keg のリンク衝突
- 並列実行(bundle のジョブ並列・ダウンロード並列)による共有資源の競合・ロック
- 全ソースビルドゆえの長時間化(GitHub の 6h ジョブ上限に接近)と、失敗の連鎖・ハング

→ **「今回の症状はこの広い故障面のどこか」**という前提で、下のループを回す。個別原因は後半の
「既知の故障クラス」を辞書的に参照するが、そこに無いものも普通に起きる。

## 動かせない制約(最初に確認)

1. **非標準 prefix は意図的**。標準 `/home/linuxbrew/.linuxbrew` に変えるのは解ではない。
2. **ローカル開発機はアーキテクチャが異なる場合があり、ソースビルド失敗を忠実再現できない**
   (Docker VM 内のソースビルドが arch 固有に落ちる等、CI の実 amd64 とは別の偽陽性が出る)。
   **ローカル Docker の結果を CI の証拠にしない。実 amd64 で再現する。**
3. `init/homebrew/main.sh` は `set -u` のみ(`-e` なし)。**失敗した `brew` コマンドは install を中断させず**、
   後段の `make test` に「ツールが無い」形で遅れて現れる。ステップの成否より、install ログ中の
   `has failed!` / `Error:` を先に見る。

## デバッグループ(毎回これを回す)

1. **失敗を特定して読む。** 失敗 run の `Install dotfiles`(`make init`)と `Test dotfiles`(`make test`)を分けて見る。
   **最初に失敗した formula/操作**を突き止める(以降の失敗は連鎖の二次被害が多い)。

   ```sh
   gh run list --workflow test-linux.yml --limit 5
   gh run view --job <id> --log | grep -nE "has failed|Error:|already locked|returned error|unable to|SIGILL|Killed|post-install|Result: FAIL|not ok "
   ```

2. **最小再現に縮める。** テンプレ(`templates/`)を `test-workflow` ブランチに置き、実環境で回す
   (`test-linux.yml` は main 限定・フルで数時間。最小版は該当 formula だけで ~10 分)。
   `bundle-race.sh` は `MODE` 環境変数で仮説を切替できる。**新しい症状には MODE を足す**のが基本の使い方。
3. **分類する。** 症状を「既知の故障クラス」(下)にマップ。無ければ一次情報から新分類を立てる。
4. **レバーを当てる。** 「使えるレバー」(下)から最小の対処を選び、最小再現で効果を確認。
5. **本体に反映して再検証。** 直すのは基本 `init/homebrew/main.sh`(や `dockerfile/*`・`Brewfile`)。
   最小再現で緑を確認してから。
6. **後片付け。** 一時ワークフロー/スクリプトを削除し、修正差分だけを commit。main に push すると
   本物の test-linux(フル)が回る。

## 一次情報の取り方(症状別)

- ビルド/テスト失敗の実体:失敗 formula の `~/.cache/Homebrew/Logs/<formula>/*.log` を末尾から読む。
  `brew install --verbose <formula>` で詳細化。終了コードに注目(例: **132 = SIGILL**、環境固有を疑う)。
- `post_install` 失敗の実体:`HOMEBREW_DEVELOPER=1` でバックトレースが出る。単独 `brew postinstall <formula>` の
  再実行で直るなら「同一 install 内実行のタイミング問題」を疑う。
- ネットワーク/TLS:`unable to get local issuer certificate` は brew の curl/git の CA 未設定。
  `brew config` で `HOMEBREW_*` の効き、`brew.sh` の `setup_ca_certificates` の条件を確認。
- 何がどこから入る/入らない:`brew deps --tree <f>`、`brew info <f>`、`brew list`。

## 使えるレバー(env/フラグの辞書)

多くの症状は「並列を止める」「上流を避ける/リトライ」「壊れた自動処理を env で肩代わり」で片づく。

| 目的 | レバー |
| --- | --- |
| formula を逐次インストール | **`brew bundle install --jobs 1`**(フラグが確実。env `HOMEBREW_BUNDLE_JOBS/NO_JOBS` は効かないことがある) |
| ダウンロードを逐次化(ロック競合回避) | `export HOMEBREW_DOWNLOAD_CONCURRENCY=1` |
| DL リトライ強化(一過性の部分DL/瞬断) | `export HOMEBREW_CURL_RETRIES=<n>` |
| TLS の CA を OS バンドルに固定(cert.pem を触らず) | `export SSL_CERT_FILE=<os-ca> GIT_SSL_CAINFO=<os-ca>`(brew が尊重) |
| `post_install` 失敗の切り分け/回避 | 該当 formula を bundle 前に単独 `brew install`(必要なら `|| true`)、`brew postinstall <f>` を別実行 |
| 掃除・ヒント抑制でログを見やすく | `HOMEBREW_NO_INSTALL_CLEANUP=1 HOMEBREW_NO_ENV_HINTS=1 HOMEBREW_NO_ANALYTICS=1 HOMEBREW_NO_AUTO_UPDATE=1` |
| ジョブが 6h 上限に達する | ハング原因(壊れた TLS で無限リトライ等)を除去、`timeout-minutes` 設定、重い formula の削減 |
| ビルド依存不足 | `dockerfile/<dist>.dockerfile` に apt/dnf で追加(例: g++, build-essential) |
| どうしても入らない formula | `Brewfile` から外す/代替に変える(スコープ判断はユーザーへ) |

OS の CA バンドル候補(distro 横断):`/etc/ssl/certs/ca-certificates.crt`、`/etc/pki/tls/certs/ca-bundle.crt`、
`/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem`、`/etc/ssl/ca-bundle.pem`。

## 既知の故障クラス(非網羅・辞書として参照)

これは過去に観測した一部。**ここに無い故障も普通に起きる**——上のループで一次情報から分類し直す。

- **並列の競合**: `... has already locked ...X.rb.incomplete` / 共有 dep の奪い合い。
  → `--jobs 1` + `HOMEBREW_DOWNLOAD_CONCURRENCY=1`。ハングやランダム失敗の温床。
- **`post_install`/CA 起因の TLS 崩壊**: source-built な openssl@3・ca-certificates の post_install が不安定で
  cert.pem が張られず、以後の HTTPS が `unable to get local issuer certificate` で失敗/ハング。
  → `SSL_CERT_FILE`/`GIT_SSL_CAINFO` を OS バンドルへ(cert.pem は触らない)。詳細は下の「事例」。
- **上流 tarball のダウンロード失敗**: `curl: (22) ... 404`/部分DL。多くは**一過性のミラー障害**
  (同時刻でも別 dist は踏まず完走する等)。→ まず再実行で切り分け、恒常なら `HOMEBREW_CURL_RETRIES` / Brewfile 見直し。
- **arch/環境固有のビルド失敗**: 終了コード 132(SIGILL)等。**ローカル arm64 の Docker で頻発するが CI(amd64)では
  起きないことが多い**。CI 実機で再現するまで「CI のバグ」と決めつけない。
- **長時間化・タイムアウト**: 全ソースビルド由来。ハング(上記TLS)を消すと大幅短縮。必要なら timeout や package 削減。

## 事例:openssl@3 の TLS 崩壊(検証済みの最小修正)

上の「並列の競合」+「post_install/CA 起因の TLS 崩壊」が重なった実例。`brew update` の後、bundle の前に:

```bash
export HOMEBREW_DOWNLOAD_CONCURRENCY=1                      # 並列DLのロック競合を回避
for _ca in /etc/ssl/certs/ca-certificates.crt \
  /etc/pki/tls/certs/ca-bundle.crt \
  /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem \
  /etc/ssl/ca-bundle.pem; do
  [[ -f ${_ca} ]] && export SSL_CERT_FILE="${_ca}" GIT_SSL_CAINFO="${_ca}" && break   # CA を OS バンドルへ
done
brew install openssl@3 || true                             # bundle 途中ビルドとその post_install 失敗を回避
brew bundle install --jobs 1 --file "${here}/Brewfile"     # 逐次化(--jobs 1 が肝)
```

方針:**cert.pem のパスは触らず env で解決**する(保守性)。`brew.sh` の `setup_ca_certificates` は
Linux で `SSL_CERT_FILE` 等を尊重・上書きしないため、これで brew の curl/git の TLS が通る。

## テンプレート

- `templates/repro-openssl.yml` → `.github/workflows/repro-openssl.yml`(実 amd64・`test-workflow` で回る使い捨て)
- `templates/bundle-race.sh` → `.github/repro/bundle-race.sh`(`MODE` で仮説切替。**新症状には MODE を追加**)

どちらも調査専用。**修正が済んだら削除**し、本体(`init/homebrew/main.sh` 等)の差分だけ残す。
