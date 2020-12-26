# pipenv
# eval "$(pipenv --completion)" # compinitが呼ばれていて起動が遅くなる原因になっているが、次バージョンで修正されそう

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

# ghq+peco
# https://qiita.com/strsk/items/9151cef7e68f0746820d
peco-src() {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER" --prompt "[ghq]")
  if [[ -n "${selected_dir}" ]]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  # zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src

# stderred
export STDERRED_ESC_CODE=$(echo -e "$(tput setaf 9)")
export DYLD_INSERT_LIBRARIES="${HOME}/usr/lib/libstderred.dylib${DYLD_INSERT_LIBRARIES:+:$DYLD_INSERT_LIBRARIES}"
