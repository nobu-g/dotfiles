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

# https://qiita.com/kaishuu0123/items/5d8ebbfc05ae343b91b5
#if [[ -z "$TMUX" && -z "$STY" ]] && type tmux >/dev/null 2>&1; then
#    client=`tmux list-client`
# セッションが存在し、まだ attach してなかったら attach
#    if [ $? -eq 0 ] && [ -z $client ]; then
#	tmux -CC attach
#    fi
#fi

#export PYENV_ROOT=$HOME/.pyenv
#export PATH=$PYENV_ROOT/bin:$PATH
#if command -v pyenv 1>/dev/null 2>&1; then
#  eval "$(pyenv init -)"
#fi

#eval $(/home/ueda/.linuxbrew/bin/brew shellenv)
