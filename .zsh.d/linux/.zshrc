# PROMPT+="[%F{green}%m%f-%F{yellow}(%~)%f]
# $ "

function set_iterm2_status_bar() {
  printf "\e]1337;SetUserVar=%s=%s\a" lastcmd "$(echo $LASTCMD | tr -d '\n' | base64)"
}

function set_iterm2_status_bar_lastcmd() {
  export LASTCMD=(${(s: :)${1}})
  set_iterm2_status_bar()
}

add-zsh-hook preexec set_iterm2_status_bar_lastcmd

watch -n 5 'set_iterm2_status_bar()' &> /dev/null &
