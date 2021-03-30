# pipenv
# eval "$(pipenv --completion)" # compinitが呼ばれていて起動が遅くなる原因になっているが、次バージョンで修正されそう

# search with google
google() {
  if echo $1 | grep -qE "^-[nt]$"; then
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
  cd "$(dirname "$(dirname "$(readlink -f "${ZDOTDIR:-$HOME}/.zshrc")")")" || exit
  code .
}

dsdel() {
  find $1 -name '.DS_Store' -type f -ls -delete
}

# ghq+peco
# https://qiita.com/strsk/items/9151cef7e68f0746820d
peco-src() {
  local dest
  dest=$(ghq list -p | peco --query "$BUFFER" --prompt "[ghq]" --print-query | tail -1)
  if [[ -n "${dest}" ]]; then
    BUFFER="cd ${dest}"
    zle accept-line
  fi
  # zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src

copy-line-as-kill() {
  zle kill-line
  print -rn $CUTBUFFER | pbcopy
}
zle -N copy-line-as-kill
bindkey '^k' copy-line-as-kill

paste-as-yank() {
  LBUFFER="${LBUFFER}$(pbpaste)"
}
zle -N paste-as-yank
bindkey '^y' paste-as-yank

# stderred
export STDERRED_ESC_CODE=$(tput setaf 9)
export DYLD_INSERT_LIBRARIES="${HOME}/usr/lib/libstderred.dylib${DYLD_INSERT_LIBRARIES:+:$DYLD_INSERT_LIBRARIES}"
