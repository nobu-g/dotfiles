# BASE SETTING

autoload -Uz add-zsh-hook
autoload -Uz colors && colors

[[ -z ${TERM} || ${TERM} == "xterm" ]] && export TERM='xterm-256color'

WORDCHARS='*?_-.[]~&;!#$%^|(){}<>'

# COMMAND HISTORY
HISTFILE=$HOME/.zsh_history
HISTSIZE=200000
SAVEHIST=100000
## Do not add in root
if [[ $UID == 0 ]]; then
  unset HISTFILE
  export SAVEHIST=0
fi
