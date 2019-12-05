# prompt
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


if [[ "$EMACS" = t ]]; then
    unsetopt zle
    stty -echo
    alias ls='ls -F -G'
fi


# pipenv
eval "$(pipenv --completion)"  # compinitが呼ばれていて起動が遅くなる原因になっているが、次バージョンで修正されそう
export PIPENV_VENV_IN_PROJECT=true  # pipenv で仮想環境をプロジェクト直下に作るように


# pyenv
export PYENV_ROOT=/usr/local/var/pyenv
if [[ -d "${PYENV_ROOT}" ]]; then
    eval "$(pyenv init -)"  # 自動補完機能
fi


# direnv (after setting PROMPT)
eval "$(direnv hook zsh)"
show_virtual_env() {
    if [[ -n "$VIRTUAL_ENV" && -n "$DIRENV_DIR" ]]; then
        echo "($(basename ${DIRENV_DIR:1}))"
    fi
}
PROMPT='$(show_virtual_env)'$PROMPT
direnv allow


# zsh-syntax-highlighting
if [[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    # エイリアスコマンドのハイライト
    ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
    # 存在するパスのハイライト
    ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
    # グロブ
    ZSH_HIGHLIGHT_STYLES[globbing]='none'
fi

# zsh-autosuggestions
if [[ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    # Widgets that accept the entire suggestion
    ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(
        end-of-line
        vi-end-of-line
        vi-add-eol
    )
    # Widgets that accept the suggestion as far as the cursor moves
    ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=(
        forward-char
        forward-word
        emacs-forward-word
        vi-forward-char
        vi-forward-word
        vi-forward-word-end
        vi-forward-blank-word
        vi-forward-blank-word-end
        vi-find-next-char
        vi-find-next-char-skip
    )
    # Widgets that accept the entire suggestion and execute it
    ZSH_AUTOSUGGEST_EXECUTE_WIDGETS=(
    )
fi

# zsh-history-substring-search
if [[ -f /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh ]]; then
    source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
fi


# search with google
google() {
    if [[ $(echo $1 | egrep "^-[nt]$") ]]; then
        local opt="$1"
        shift
    fi
    local url="https://www.google.co.jp/search?q=${*// /+}"
    # local args=${url}
    if [[ ${opt} != "-t" ]]; then
        open --new -a 'Google Chrome' --args "${url}" --new-window
    else
        open --new -a 'Google Chrome' --args "${url}"
    fi
}
