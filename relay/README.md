# Agent bridge (phase 1)

複数マシン上の Claude Code セッションを対等に会話させるための最小構成。
現状はフェーズ1（明示的に呼べば届く同期的な送受信）まで。非同期の起床は未実装。

## 構成

```
[マシンA]                  [リレー1プロセス]                 [マシンB]
 Claude Code                  server.py                    Claude Code
   │                    (HTTP transport MCP)                    │
   └─ send ──────────────► mailboxes["b"] ◄──────────── recv ────┘
```

`server.py` 1ファイルだけ。エージェント側のマシンには**何も置かない**。
`claude mcp add --transport http` でリレーの URL を登録するだけで使えるようになる。
uv も Python も dotfiles のチェックアウトも要らない。

## エージェントに見えるもの

リレーが渡すのは `initialize` の応答と `tools/list` だけ。リソースもプロンプトも持たない。

- Claude Code は MCP ツールを遅延ロードすることがあり、その場合セッション開始時にモデルが
  見るのはツール名4つとサーバの `instructions` だけになる。`instructions` にはエラー
  メッセージから学べないことだけを書く
- `ToolAnnotations` の既定は `destructive_hint=true` / `open_world_hint=true` /
  `read_only_hint=false`。**何も付けないことが「破壊的」という誤情報になる**ので、既定と
  食い違うものだけ明示している

## エージェント名

エージェントが `register` で自分で名乗る。**それが唯一の手段**で、リレーが自動で名前を
付けることはない。指定がなければ `<host-name>/<repo-name>` を使うよう description で
指示している。

名前と呼び出し元の対応は `Mcp-Session-Id` で覚える。streamable HTTP transport が
initialize 時に発行するもので、**ステートレスでは発行されない**。`stateless_http=False`
にしているのはこのため。

名乗り直すと、旧名宛の未読メッセージは取り残される。`who` は `register` 済みの名前しか
出さないので、取り残された分に気づく手段は無い。

## トークン

リレーが初回起動時に生成し、`$XDG_CONFIG_HOME/agent-bridge/token`（既定 `~/.config/...`、
`0600`）に保存する。2回目以降は読み直すので、リレーを再起動しても各プロジェクトの登録は
生き続ける。変更したいときはこのファイルを消すか書き換える。
エージェント側は `Authorization: Bearer <token>` を `claude mcp add -H` で固定する。

トークンを引数や URL のクエリに載せない。`/proc` に `hidepid` が設定されていない
共有マシンでは引数は他ユーザから読め、クエリ文字列は uvicorn のアクセスログに残る。
`Authorization` ヘッダならどちらにも出ない。

## 起動

### リレー

```bash
uv run --script relay/server.py --host 127.0.0.1 --port 8787
```

起動時に、そのまま貼れる `claude mcp add` の1行を印字する。

### プロジェクトを1つ登録する

他エージェントと通信させたいプロジェクトは稀なので、user スコープには入れない。
必要になったプロジェクトで、リレーが印字した行をそのまま実行する。

```bash
claude mcp add --transport http agent-bridge -s local \
  http://relay.internal:8787/mcp \
  -H "Authorization: Bearer ..."
```

**スコープは `local`。** `project` はリポジトリ内に `.mcp.json` を作るので、トークンを
コミットすることになる。`local` の保存先は `~/.claude.json`（`0600`）。

## 検証手順

1. リレーを起動し、印字された行をコピーする
2. 対象プロジェクトでその行を実行する
3. `claude mcp list` → `agent-bridge ... ✔ Connected`
4. Aで「agent-bridge の register で名乗って、who を呼んで」→ `you: <名乗った名前>` が返ること
5. Bでも register させる
6. Aで「agent-bridge の send で B に『テスト』を送って」
7. Bで「agent-bridge の recv を呼んで」→ 発信元の名前付きで受信できること

## 注意

- **MCP Python SDK は 2.0 以降が要る。** 1.x の `FastMCP` は廃止され、ヘッダを読む
  `Context.headers` も 2.0 で入った API。
- **`/mcp` エンドポイント自体には認証をかけていない。** トークンの検証はツールの中で行うので、
  ネットワークから届く相手は `initialize` と `tools/list` までは実行できる（ツールは呼べない）。
  信頼できるネットワークに置くこと。
- **`recv` は最大 300 秒ブロックする。** Claude Code 側のツール実行タイムアウトがこれより
  短いと待機中に切られる。切られる場合は `MCP_TOOL_TIMEOUT` を伸ばすか
  `recv(timeout_seconds=...)` を縮める。
- **社内プロキシ環境では `no_proxy` の確認が要る。** リレーがローカルでも、`127.0.0.1` が
  `no_proxy` に入っていないとプロキシ経由で行こうとする。
- 終了したセッションの名前は `who` に残り続ける（セッションの終了をリレーは知らない）。
  リレーを再起動すると名前も未読メッセージも消える。永続化は未実装。
- **このブリッジには Claude Code の agent teams が持つ保護（メッセージの分類器検査、
  権限承認の代理禁止など）が一切ない。** 他エージェント発のテキストはモデルから見れば
  ただの指示文になる。相互に信頼できるエージェント間でのみ使い、外部から書き込める経路を
  リレーに作らないこと。

## 未実装（フェーズ2以降）

- 非同期受信。バックグラウンドシェルの long-poll で、待っていないセッションを起こす。
- メールボックスの永続化（sqlite）
- ループ防止（hops 上限、レート制限）
