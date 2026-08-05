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
| JSON-API 経路を丸ごと回避(api-source 起因の故障全部) | **`export HOMEBREW_NO_INSTALL_FROM_API=1`**(homebrew/core の tap clone 約1.4GB が走る。bottle は引き続き pour される) |
| ダウンロードを逐次化(ロック競合回避) | `export HOMEBREW_DOWNLOAD_CONCURRENCY=1` |
| DL リトライ強化(一過性の部分DL/瞬断) | `export HOMEBREW_CURL_RETRIES=<n>` |
| install 毎の cleanup / bundle 中の auto-update を止める(キャッシュ・tap 状態の mid-run 変化を防ぐ) | `export HOMEBREW_NO_INSTALL_CLEANUP=1 HOMEBREW_NO_AUTO_UPDATE=1` |
| brew のダウンロード URL を書き換える(死んだミラー回避) | `HOMEBREW_CURL_PATH=<wrapper>` に curl ラッパーを指定(例: `init/homebrew/linux/curl-gnu-mirror.sh`)。ラッパー内は**絶対パスの `/usr/bin/curl` を exec** すること(素の `curl` は brew の shim 経由で自分に戻り無限再帰) |
| `post_install` 失敗の実エラーを見る | `HOMEBREW_DEVELOPER=1` で backtrace が出る(通常は握りつぶされる)。ただし DEVELOPER は `forbid_packages_from_paths` も無効化するので、挙動が変わり得る点に注意 |
| ~~TLS の CA を OS バンドルに固定~~ | **効かない(2026-08 に確定)**: `bin/brew` は `env -i` で環境を再構成し、`HOMEBREW_*` と少数の allowlist(HOME/PATH/proxy 系)しか通さないため、`SSL_CERT_FILE`/`GIT_SSL_CAINFO` は brew に届かない |
| 掃除・ヒント抑制でログを見やすく | `HOMEBREW_NO_INSTALL_CLEANUP=1 HOMEBREW_NO_ENV_HINTS=1 HOMEBREW_NO_ANALYTICS=1 HOMEBREW_NO_AUTO_UPDATE=1` |
| ジョブが 6h 上限に達する | ハング原因(壊れた TLS で無限リトライ等)を除去、`timeout-minutes` 設定、重い formula の削減 |
| ビルド依存不足 | `dockerfile/<dist>.dockerfile` に apt/dnf で追加(例: g++, build-essential) |
| どうしても入らない formula | `Brewfile` から外す/代替に変える(スコープ判断はユーザーへ) |

OS の CA バンドル候補(distro 横断):`/etc/ssl/certs/ca-certificates.crt`、`/etc/pki/tls/certs/ca-bundle.crt`、
`/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem`、`/etc/ssl/ca-bundle.pem`。

## 既知の故障クラス(非網羅・辞書として参照)

これは過去に観測した一部。**ここに無い故障も普通に起きる**——上のループで一次情報から分類し直す。

- **JSON-API 経路 × 全ソースビルド(2026-08 に根本解決済みの主犯)**: brew 6 の API インストール経路では
  postinstall 子プロセスの formula 解決が内部マニフェストで失敗する
  (`FormulaUnavailableError: No available formula with the name "packages.<arch>.jws.json"`)。
  post_install を持つ**全** source-built formula(openssl@3, python@3.x, node, ruby…)の install が
  非ゼロ終了になり bundle が失敗扱いにする。openssl@3 の post_install 失敗で cert.pem が張られず、
  brewed git/curl の TLS も全滅(`unable to get local issuer certificate`)。さらに同じ api-source 機構が
  `.rb.incomplete` の自己ロック競合や「`<formula> source code not found at .../api-source/...`」も起こす。
  → **`HOMEBREW_NO_INSTALL_FROM_API=1`** で機構ごと回避(検証済み。下の「事例」)。
- **並列の競合**: `... has already locked ...X.rb.incomplete` / 共有 dep の奪い合い。
  → `--jobs 1` + `HOMEBREW_DOWNLOAD_CONCURRENCY=1`。ハングやランダム失敗の温床。
- **bottle が fetch 完了前に pour される散発バグ**(upstream Homebrew/brew#15957):
  `No such file or directory @ rb_sysopen - ...--<dep>--....bottle.tar.gz`。
  → `HOMEBREW_NO_INSTALL_CLEANUP=1 HOMEBREW_NO_AUTO_UPDATE=1` + **bundle を1回だけリトライ**
  (キャッシュが残るので2回目は即完走)。
- **上流 tarball のダウンロード失敗**: `curl: (22) ... 404`/部分DL。多くは**一過性のミラー障害**
  (同時刻でも別 dist は踏まず完走する等)。→ まず再実行で切り分け、恒常なら `HOMEBREW_CURL_RETRIES` / Brewfile 見直し。
  恒常破損の実例: ftpmirror.gnu.org の多日ダウン、invisible-mirror.net の ncurses tarball 内容破損
  (取得ごとに違うハッシュ、`Formula reports different checksum`)。formula の mirror 定義があっても
  ダウンロードキューはフォールバックしないため、`HOMEBREW_CURL_PATH` の curl ラッパーで正常ホスト
  (ftp.gnu.org)へ URL を書き換えるのが確実。
- **所要時間の構造変化(故障ではない)**: 2026-05/06 の brew 修正
  (「Homebrew versions prior to 5.1.15 generated incorrect :any_skip_relocation」)以降、Linux bottle の
  cellar タグが正しく固定 cellar になり、**非標準 prefix では bottle が pour されなくなった**。
  それ以前(2026-04 まで)は誤タグの bottle を未 relocation のまま pour していたため各ジョブ約1時間で
  完走していたが、以後は正味のソースビルド時間(node 1本で約2時間)がそのままかかる。
  時間超過を故障と混同しないこと。対策はレバーではなく構成側: 重い formula の削減、
  glibc が新しいベースイメージ(古い glibc だと brew が glibc+gcc をフルブートストラップし全 formula が低速化)、
  `timeout-minutes` の引き上げ(GitHub ホストランナー上限 6h)。
- **arch/環境固有のビルド失敗**: 終了コード 132(SIGILL)等。**ローカル arm64 の Docker で頻発するが CI(amd64)では
  起きないことが多い**。CI 実機で再現するまで「CI のバグ」と決めつけない。
- **長時間化・タイムアウト**: 全ソースビルド由来。ハング(上記TLS)を消すと大幅短縮。必要なら timeout や package 削減。

## 事例:2026-08 の全滅(JSON-API 経路の故障クラス、検証済みの修正)

2026-06〜08 に全 dist が毎回失敗した実例。旧事例(SSL_CERT_FILE で CA を渡す)は
**bin/brew の `env -i` フィルタで環境変数が届かないため誤りだった**。確定した修正は
`init/homebrew/main.sh` の Linux ブロック(実 amd64 の ubuntu/debian で全緑を確認):

```bash
export HOMEBREW_NO_INSTALL_FROM_API=1        # 根本修正: formula を tap clone からロード
HOMEBREW_CURL_PATH=".../curl-gnu-mirror.sh"          # GNU 系ホスト(ftpmirror/ftp.gnu.org 等)を mirrors.kernel.org へ書き換え
export HOMEBREW_CURL_PATH
export HOMEBREW_DOWNLOAD_CONCURRENCY=1       # DL 逐次化
export HOMEBREW_CURL_RETRIES=3               # 一過性の 502/504 対策
export HOMEBREW_NO_INSTALL_CLEANUP=1         # 後続 formula が使うキャッシュを消させない
export HOMEBREW_NO_AUTO_UPDATE=1             # bundle 中の tap 状態ドリフト防止
brew update
brew bundle install --jobs 1 --file ... || brew bundle install --jobs 1 --file ...  # pour 競合(#15957)の1回リトライ
```

デバッグの決め手は2つ: (1) `HOMEBREW_DEVELOPER=1 brew postinstall openssl@3` で隠れた実エラーを出す、
(2) ローカル arm64 Docker(`--platform linux/amd64` + Rosetta)でも **postinstall のロジック故障は忠実に再現できた**
(ビルド自体の失敗は偽陽性が出る点は従来どおり)。社内ネットワークでは Zscaler が ghcr.io を TLS 傍受するので、
`security find-certificate -a -p -c "Zscaler" /Library/Keychains/System.keychain` で取った証明書を
コンテナの `/usr/local/share/ca-certificates/` に置いて `update-ca-certificates` してから再現する。

## テンプレート

- `templates/repro-openssl.yml` → `.github/workflows/repro-openssl.yml`(実 amd64・`test-workflow` で回る使い捨て)
- `templates/bundle-race.sh` → `.github/repro/bundle-race.sh`(`MODE` で仮説切替。**新症状には MODE を追加**)

どちらも調査専用。**修正が済んだら削除**し、本体(`init/homebrew/main.sh` 等)の差分だけ残す。
