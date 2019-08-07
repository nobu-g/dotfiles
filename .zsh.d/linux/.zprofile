# ログインした時自動で tmux attach
if [[ -z "$TMUX" && -z "$STY" ]]; then
    client=`tmux list-client 2> /dev/null`
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
