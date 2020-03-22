function set_iterm2_status_bar() {
  mycmd=(${(s: :)${1}})
  printf "\e]1337;SetUserVar=%s=%s\a" lastcmd "$(echo $mycmd | tr -d '\n' | base64)"
}

add-zsh-hook preexec set_iterm2_status_bar
