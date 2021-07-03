# KEY BINDINGS

bindkey -d

# KEY SETTING FOR COMMAND HISTORY
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

# EMACS-LIKE KEYBINDINGS
bindkey -e
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
# allow ctrl-a and ctrl-e to move to beginning/end of line
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
# allow ctrl-z, ctrl-y for undo redo
bindkey '^z' undo
# bindkey '^y' redo
