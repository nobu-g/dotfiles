# in ~/.zshenv, executed `unsetopt GLOBAL_RCS` and ignored /etc/zshrc
[ -r /etc/zshrc ] && . /etc/zshrc


PROMPT="%F{green}local%f%F{yellow}(%~)%f
$ "


if [ "$EMACS" = t ]; then
    unsetopt zle
    stty -echo
    alias ls='ls -F -G'
fi


# pipenv設定
eval "$(pipenv --completion)"


# pyenv設定
export PYENV_ROOT=/usr/local/var/pyenv
if [ -d "${PYENV_ROOT}" ]; then
    eval "$(pyenv init -)"  # 自動補完機能
fi


# direnv設定
eval "$(direnv hook zsh)"


# zsh-syntax-highlighting
if [ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
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
if [ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
# zsh-history-substring-search
if [ -f /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh ]; then
    source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
fi
