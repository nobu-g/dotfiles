PROMPT="[%F{green}%m%f-%F{yellow}(%~)%f]
$ "


# use cached directory for virtualenv
export WORKON_HOME=/mnt/berry_f/home/ueda/.virtualenvs

if [ "$EMACS" = t ]; then
    unsetopt zle
    stty -echo
    alias ls='ls -F --color'
fi


# direnv (after setting PROMPT)
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
    # エイリアスコマンドのハイライト
    ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
    # 存在するパスのハイライト
    ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
    # グロブ
    ZSH_HIGHLIGHT_STYLES[globbing]='none'
fi

# zsh-autosuggestions
if [ -f ~/utils/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source ~/utils/zsh-autosuggestions/zsh-autosuggestions.zsh
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
if [ -f ~/utils/zsh-history-substring-search/zsh-history-substring-search.zsh ]; then
    source ~/utils/zsh-history-substring-search/zsh-history-substring-search.zsh
fi
