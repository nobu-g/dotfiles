# KEY BINDINGS
# https://github.com/gregf/dotfiles/blob/master/zsh/zkbd.zsh
# bindkey -d

# bindkey -e
# bindkey '^h' backward-delete-char
# bindkey '^w' backward-kill-word
# # allow ctrl-a and ctrl-e to move to beginning/end of line
# bindkey '^a' beginning-of-line
# bindkey '^e' end-of-line
# # allow ctrl-z, ctrl-y for undo redo
# bindkey '^z' undo
# # bindkey '^y' redo

autoload -Uz zkbd
bindkey -e

zkbd_file() {
  local zkbd_dir="${ZDOTDIR:-$HOME}/.zkbd"
  [[ -f ${zkbd_dir}/${TERM}-${VENDOR}-${OSTYPE} ]] && echo "${zkbd_dir}/${TERM}-${VENDOR}-${OSTYPE}" && return 0
  [[ -f ${zkbd_dir}/${TERM}-${DISPLAY:t} ]] && echo "${zkbd_dir}/${TERM}-${DISPLAY:t}" && return 0
  return 1
}

keyfile=$(zkbd_file)
ret=$?
if [[ ${ret} -eq 0 ]]; then
  source "${keyfile}"
else
  echo "WARNING: Keybindings may not be set correctly!" 1>&2
  echo "Execute \`zkbd\` to create bindings." 1>&2
fi
unfunction zkbd_file; unset keyfile ret


#################################################################################
# Set some keybindings
#################################################################################

autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# Bind the keys that zkbd set up to some widgets
[[ -n "${key[Home]}" ]]    && bindkey "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}" ]]     && bindkey "${key[End]}"     end-of-line
[[ -n "${key[Insert]}" ]]  && bindkey "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}" ]]  && bindkey "${key[Delete]}"  delete-char
[[ -n "${key[Up]}" ]]      && bindkey "${key[Up]}"      up-line-or-search
[[ -n "${key[Down]}" ]]    && bindkey "${key[Down]}"    down-line-or-search
[[ -n "${key[Left]}" ]]    && bindkey "${key[Left]}"    backward-char
[[ -n "${key[Right]}" ]]   && bindkey "${key[Right]}"   forward-char

bindkey "^k" kill-line
bindkey "^l" clear-screen
bindkey "^r" history-incremental-search-backward
bindkey "^u" kill-whole-line
bindkey '^h' backward-delete-char
bindkey "^w" backward-kill-word

bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

bindkey "^[h" run-help

# Show dots while waiting to complete. Useful for systems with slow net access,
# like those places where they use giant, slow NFS solutions. (Hint.)
# expand-or-complete-with-dots() {
#   echo -n "\e[31m......\e[0m"
#   zle expand-or-complete
#   zle redisplay
# }
# zle -N expand-or-complete-with-dots
# bindkey "^I" expand-or-complete-with-dots
