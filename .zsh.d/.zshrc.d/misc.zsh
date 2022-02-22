# LESS (https://qiita.com/delphinus/items/b04752bb5b64e6cc4ea9)
export LESS="-iMRx4"
export LESSCHARSET='utf-8'
if [[ -e ${HOMEBREW_PREFIX}/bin/src-hilite-lesspipe.sh ]]; then
  export LESSOPEN="| ${HOMEBREW_PREFIX}/bin/src-hilite-lesspipe.sh %s"
fi
export LESSHISTFILE="${XDG_DATA_HOME:-${HOME}/.local/share}/less/lesshst"

# PAGER
export PAGER="less"
export MANPAGER="sh -c 'col -bx | bat -l man -p'" # https://github.com/sharkdp/bat#man

# EDITOR
export EDITOR='emacsclient -s ${EMACS_SERVER_SOCKET}'
export EMACS_SERVER_SOCKET="${TMPDIR:-/tmp}/emacs$(id -u)/server"

# BurntSushi/ripgrep
export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME:-$HOME/.config}/ripgrep/config"

# Python
export PYTHONSTARTUP="${XDG_CONFIG_HOME:-$HOME/.config}/python/.pythonrc.py"
export JUPYTER_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/jupyter"

# Node.js
export NODE_REPL_HISTORY="${XDG_DATA_HOME:-$HOME/.local/share}/node/.node_repl_history"

# direnv
eval "$(direnv hook zsh)"
p=$PWD
while [[ $p != '/' ]]; do
  if [[ -f $p/.envrc ]]; then
    direnv allow
    break
  fi
  p=$(dirname $p)
done

## peco
peco-select-history() {
  BUFFER=$(\history -Endir 1 | peco --query "$BUFFER" --prompt "[hist]" --print-query | tail -1 | cut -d' ' -f4-)
  CURSOR=${#BUFFER}
  #  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

fzf-select-history() {
  BUFFER="$(history -nr 1 | awk '!a[$0]++' | fzf --query "$BUFFER" | sed 's/\\n/\n/')"
  CURSOR=${#BUFFER} # カーソルを文末に移動
  zle -R -c         # refresh
}
# zle -N fzf-select-history
# bindkey '^r' fzf-select-history

## search a destination from cdr list and cd the destination
peco-cdr() {
  local dest=$(cdr -l | sed -Ee 's/^[0-9]+\s+//' | peco --query "$BUFFER" --prompt "[dest]")
  if [[ -n "${dest}" ]]; then
    BUFFER="cd ${dest}"
    zle accept-line
  else
    zle reset-prompt
  fi
}
zle -N peco-cdr
bindkey '^x' peco-cdr

# cdr設定(pecoの'^x'に必要)
autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 2000
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':chpwd:*' recent-dirs-file "${XDG_DATA_HOME:-$HOME/.local/share}/shell/chpwd-recent-dirs"
zstyle ':completion:*' recent-dirs-insert both

# peco find file (https://k0kubun.hatenablog.com/entry/2014/07/06/033336)
peco-find-file() {
  local source_files
  if git rev-parse 2> /dev/null; then
    source_files=$(git ls-files)
  else
    source_files=$(find . -type f)
  fi
  local selected_files=$(echo ${source_files} | peco --prompt "[file]" | tr '\n', ' ')

  BUFFER=${BUFFER}${selected_files}
  CURSOR=${#BUFFER}
  zle redisplay
}
zle -N peco-find-file
bindkey '^_' peco-find-file # works by ^/

# peco process kill (https://github.com/masutaka/dotfiles-public/blob/master/.zshrc)
peco-pkill() {
  for pid in $(ps aux | peco --prompt "[kill]" | awk '{ print $2 }'); do
    kill $pid
    echo "Killed ${pid}"
	done
}
alias pk="peco-pkill"


# broot
[[ -f ${XDG_CONFIG_HOME:-$HOME/.config}/broot/launcher/bash/br ]] &&
  source ${XDG_CONFIG_HOME:-$HOME/.config}/broot/launcher/bash/br

## auto ls after changing directory
autoload -Uz _ls_abbrev
add-zsh-hook chpwd _ls_abbrev

# https://github.com/ajeetdsouza/zoxide
export _ZO_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zoxide"
export _ZO_ECHO=1
eval "$(zoxide init zsh)"

cd() {
  if [[ $# -eq 1 && $1 = "--" ]]; then
    pushd +2 || return 1
  else
    builtin cd $@ || return 1
  fi
}

fontlist() { fc-list | sed 's,:.*,,' | sort -u }
mvbak() { mv ${1%%/} ${1%%/}"-$(date "+"%Y-%m-%d)" }
cpbak() { cp -R ${1%%/} ${1%%/}"-$(date "+"%Y-%m-%d)" }

# set operations
autoload -Uz union
autoload -Uz isect
autoload -Uz difference

autoload -Uz mkcd     # mkdir and cd
autoload -Uz pss      # search process by command name
autoload -Uz resetenv # unset all environment variables and restart shell
autoload -Uz bm       # bookmark directories
autoload -Uz lspath   # list paths
autoload -Uz les      # less or ls
autoload -Uz fs       # determine size of a file or total size of a directory
autoload -Uz tssh     # ssh and tmux, like tssh <host-name> <session-name>

# git add などの補完が効かなくなるのでコメントアウト
# git() {
#   if [[ $# > 0 ]]; then
#     command git $@
#   else
#     command git status
#   fi
# }

# shell integration 設定
export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
