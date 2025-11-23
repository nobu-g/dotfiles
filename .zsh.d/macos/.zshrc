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
  cd "$(dirname "$(dirname "$(readlink -f "${ZDOTDIR:-$HOME}/.zshrc")")")" || return 1
  code .
}

dsdel() {
  find $1 -name '.DS_Store' -type f -ls -delete
}

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

autoload -Uz o # open directory or file

# stderred
if [[ -f "${HOMEBREW_PREFIX}/lib/libstderred.dylib" ]]; then
  export STDERRED_ESC_CODE=$(tput setaf 9)
  export DYLD_INSERT_LIBRARIES="${HOMEBREW_PREFIX}/lib/libstderred.dylib${DYLD_INSERT_LIBRARIES:+:$DYLD_INSERT_LIBRARIES}"
fi

# completions for google-cloud-sdk
gc_completion="${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
[[ -f ${gc_completion} ]] && zinit snippet "${gc_completion}"

export EMACS_SERVER_SOCKET="${TMPDIR:-/tmp}/emacs$(id -u)/server"

## PyCharm CLI launcher
charm() {
  if [[ -e "/Applications/PyCharm CE.app" ]]; then
    open -na "PyCharm CE.app" --args "$@"
  elif [[ -e "/Applications/PyCharm.app" ]]; then
    open -na "PyCharm.app" --args "$@"
  else
    echo "PyCharm is not installed." >&2
    return 1
  fi
}

# alias
alias rm='trash'  # https://github.com/andreafrancia/trash-cli
alias ldd='otool -L'
# alias jumanpp='docker run -i --rm --platform linux/amd64 kunlp/jumanpp-knp jumanpp'
(($+commands[knp])) || alias knp='docker run -i --rm --platform linux/amd64 kunlp/jumanpp-knp knp'
alias ch='charm'
alias disk='diskutil'
alias dutil='diskutil'
# valid if Intel-based Homebrew is installed
# arch -x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
[[ -x /usr/local/bin/brew ]] && alias ibrew="arch -x86_64 /usr/local/bin/brew"
