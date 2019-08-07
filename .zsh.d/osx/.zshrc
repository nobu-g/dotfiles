# in ~/.zshenv, executed `unsetopt GLOBAL_RCS` and ignored /etc/zshrc
[ -r /etc/zshrc ] && . /etc/zshrc


PROMPT="%F{green}local%f%F{yellow}(%~)%f
$ "

## git (http://tkengo.github.io/blog/2013/05/12/zsh-vcs-info/)
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true  # formats 設定項目で %c,%u が使用可
zstyle ':vcs_info:git:*' stagedstr '%F{yellow}!'  # commit されていないファイルがある
zstyle ':vcs_info:git:*' unstagedstr '%F{red}+'  # add されていないファイルがある
zstyle ':vcs_info:*' formats '%F{green}%c%u[%b]%f'  # 通常
zstyle ':vcs_info:*' actionformats '[%b|%a]'  # rebase 途中,merge コンフリクト等 formats 外の表示
add-zsh-hook precmd vcs_info
RPROMPT='${vcs_info_msg_0_}'


if [ "$EMACS" = t ]; then
    unsetopt zle
    stty -echo
    alias ls='ls -F -G'
fi


# pipenv設定
eval "$(pipenv --completion)"  # compinitが呼ばれていて起動が遅くなる原因になっているが、次バージョンで修正されそう


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
