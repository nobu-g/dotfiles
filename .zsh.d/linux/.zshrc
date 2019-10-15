PROMPT="[%F{green}%m%f-%F{yellow}(%~)%f]
$ "


# use cached directory for virtualenv
export WORKON_HOME=/mnt/berry_f/home/ueda/.virtualenvs

if [ "$EMACS" = t ]; then
    unsetopt zle
    stty -echo
    alias ls='ls -F --color'
fi


# ssh-agent
SSH_AUTH_SOCK_LINK=/tmp/ueda_ssh_sock/ssh_auth_sock # symlink を貼る場所
## -n : SSH_AUTH_SOCK がないときは symlink を貼らない
## != : SSH_AUTH_SOCK が既に SSH_AUTH_SOCK_LINK のときは貼らない
if [[ -n "$SSH_AUTH_SOCK" && "$SSH_AUTH_SOCK" != "$SSH_AUTH_SOCK_LINK" ]]; then # 接続ごとに symlink の向き先を新しくする
# 古い agent を使い回す場合
## ! -S : SSH_AUTH_SOCK_LINK の向き先が既にソケットのときは貼らない
# if [[ -n "$SSH_AUTH_SOCK" && "$SSH_AUTH_SOCK" != "$SSH_AUTH_SOCK_LINK" && ! -S $SSH_AUTH_SOCK_LINK ]]; then
  mkdir -p $(dirname "$SSH_AUTH_SOCK_LINK") # ディレクトリを作っておく
  ln -sf "$SSH_AUTH_SOCK" "$SSH_AUTH_SOCK_LINK" # symlink を現在の場所に貼る
fi
export SSH_AUTH_SOCK="$SSH_AUTH_SOCK_LINK"


# direnv設定 (PROMPT設定後)
eval "$(direnv hook zsh)"
show_virtual_env() {
  if [[ -n "$VIRTUAL_ENV" && -n "$DIRENV_DIR" ]]; then
    echo "($(basename ${DIRENV_DIR:1}))"
  fi
}
PROMPT='$(show_virtual_env)'$PROMPT


# zsh-syntax-highlighting
if [ -f ~/utils/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source ~/utils/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
# Declare the variable
typeset -A ZSH_HIGHLIGHT_STYLES
# エイリアスコマンドのハイライト
ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
# 存在するパスのハイライト
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
# グロブ
ZSH_HIGHLIGHT_STYLES[globbing]='none'

# zsh-autosuggestions
if [ -f ~/utils/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source ~/utils/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
# zsh-history-substring-search
if [ -f ~/utils/zsh-history-substring-search/zsh-history-substring-search.zsh ]; then
    source ~/utils/zsh-history-substring-search/zsh-history-substring-search.zsh
fi
