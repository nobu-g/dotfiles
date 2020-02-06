# ssh-agent
SSH_AUTH_SOCK_LINK=/tmp/ueda_ssh_sock/ssh_auth_sock # symlink を貼る場所
## -n : SSH_AUTH_SOCK がないときは symlink を貼らない
## != : SSH_AUTH_SOCK が既に SSH_AUTH_SOCK_LINK のときは貼らない
if [[ -n "$SSH_AUTH_SOCK" && "$SSH_AUTH_SOCK" != "$SSH_AUTH_SOCK_LINK" ]]; then # 接続ごとに symlink の向き先を新しくする
  # 古い agent を使い回す場合
  ## ! -S : SSH_AUTH_SOCK_LINK の向き先が既にソケットのときは貼らない
  # if [[ -n "$SSH_AUTH_SOCK" && "$SSH_AUTH_SOCK" != "$SSH_AUTH_SOCK_LINK" && ! -S $SSH_AUTH_SOCK_LINK ]]; then
  mkdir -p $(dirname "$SSH_AUTH_SOCK_LINK")     # ディレクトリを作っておく
  ln -sf "$SSH_AUTH_SOCK" "$SSH_AUTH_SOCK_LINK" # symlink を現在の場所に貼る
fi
export SSH_AUTH_SOCK="$SSH_AUTH_SOCK_LINK"

# ログインした時自動で tmux attach
if [[ -z "$TMUX" && -z "$STY" ]]; then
  client=$(tmux list-client 2>/dev/null)
  # セッションが存在し、まだ attach してなかったら attach
  if [[ $? -eq 0 && -z $client ]]; then
    tmux -CC attach
  fi
fi

# 別のマシンに移動した時カレントディレクトリを維持
if [[ -n "$LC_PWD" && "$(realpath $PWD)" != "$(realpath $LC_PWD)" && -e "$LC_PWD" ]]; then
  cd "$LC_PWD"
fi

#eval $(/home/ueda/.linuxbrew/bin/brew shellenv)
