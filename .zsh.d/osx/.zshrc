# prompt
PROMPT="%F{green}local%f%F{yellow}(%~)%f
$ "

## git (http://tkengo.github.io/blog/2013/05/12/zsh-vcs-info/)
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true    # formats 設定項目で %c,%u が使用可
zstyle ':vcs_info:git:*' stagedstr '%F{yellow}!'   # commit されていないファイルがある
zstyle ':vcs_info:git:*' unstagedstr '%F{red}+'    # add されていないファイルがある
zstyle ':vcs_info:*' formats '%F{green}%c%u[%b]%f' # 通常
zstyle ':vcs_info:*' actionformats '[%b|%a]'       # rebase 途中,merge コンフリクト等 formats 外の表示
add-zsh-hook precmd vcs_info
RPROMPT='${vcs_info_msg_0_}'

# pipenv
# eval "$(pipenv --completion)" # compinitが呼ばれていて起動が遅くなる原因になっているが、次バージョンで修正されそう

# direnv (after setting PROMPT)
show_virtual_env() {
  if [[ -n "$VIRTUAL_ENV" && -n "$DIRENV_DIR" ]]; then
    echo "($(basename ${DIRENV_DIR:1}))"
  fi
}
PROMPT='$(show_virtual_env)'$PROMPT

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

dotedit() {
  cd ~/dotfiles
  code .
}

dsdel() {
  find $1 -name '.DS_Store' -type f -ls -delete
}
