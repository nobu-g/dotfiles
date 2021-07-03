# BASE SETTING

autoload -Uz add-zsh-hook
autoload -Uz colors && colors

# COLOR
# export LS_COLORS=':no=00:fi=00:di=36:ln=35:pi=33:so=32:bd=34;46:cd=34;43:ex=31:'
# export LSCOLORS=gxfxcxdxbxegexabagacad  # GNU系の LS_COLORS に相当
export TERM='xterm-256color'

WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

# COMMAND HISTORY
HISTFILE=$HOME/.zsh_history
HISTSIZE=200000
SAVEHIST=100000
## Do not add in root
if [[ $UID == 0 ]]; then
  unset HISTFILE
  export SAVEHIST=0
fi
