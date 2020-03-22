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
