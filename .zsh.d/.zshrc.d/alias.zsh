# ALIAS

setopt complete_aliases # don't expand aliases _before_ completion has finished

alias ls='ls -FH --color=tty'
alias ll='lsd -lFh'
alias la='lsd -laFh'
alias lt='lsd -ltFh'
alias lat='lsd -latFh'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias g='git'
alias gti='git'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias wl='wc -l'
alias gomi='rm -f *~'
alias jk='jumanpp | knp'
alias relogin='exec $SHELL -l'
alias re='exec $SHELL -l'
alias wh='which -a'
alias py='python'
alias py3='python3'
alias dpython='python -m ipdb -c continue'
alias dpy='python -m ipdb -c continue'
alias ppython='python -m cProfile -s tottime'
alias ppy='python -m cProfile -s tottime'
alias rename='noglob zmv -W' # rename **/*.xxx **/*.yyy
alias x='exit'
alias brew='env -u LD_LIBRARY_PATH PATH=${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin:/usr/bin:/bin:/usr/sbin:/sbin brew'
alias d='docker'
alias l='les'
alias b='bat'
alias s='ssh'
## http://keisanbutsuriya.hateblo.jp/entry/2015/02/13/133858
alias e='emacsclient --tty -a "" -s ${EMACS_SERVER_SOCKET}'
alias emacs='emacsclient --tty -a "" -s ${EMACS_SERVER_SOCKET}'
alias ekill='emacsclient -e "(kill-emacs)"'
alias zshtime='for i in $(seq 1 10); do time zsh -i -c exit; done'
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
# Show active network interfaces
alias ifactive="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"
# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'
# Enable aliases to be sudo’ed
alias sudo='sudo '
alias sum='paste -sd+ | bc'
alias -- -='cd -'
alias -- --='cd --'

# global alias
alias -g A='| awk'
alias -g H='| head'
alias -g Hn='| head -n'
alias -g T='| tail'
alias -g Tn='| tail -n'
alias -g G=' 2>&1 | grep'
alias -g Gv=' 2>&1 | grep -v'
alias -g L='| wc -l'
alias -g C='| clipcopy'
alias -g X='| xargs'
alias -g XS='| xargs -I{} bash -exuc'
alias -g B='$(git branch -a --sort=-authordate | grep -v -e "->" -e "*" | sed "s#remotes/##"'
alias -g J='| jumanpp'
alias -g K='| knp'
alias -g Kt='| knp -tab'
alias -g JK='| jumanpp | knp'
alias -g JKt='| jumanpp | knp -tab'
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

# suffix alias
alias -s {md,txt,tex,json}="bat"
alias -s zip='zipinfo'
alias -s {gz,tgz}='gzcat'
alias -s xz='xzcat'
alias -s {tbz,bz2}='bzcat'
alias -s {html,pdf}='open'

expand-global-alias() {
  if [[ "$LBUFFER" =~ " [A-Z0-9][^ ]+$" ]]; then
    zle _expand_alias
    # zle expand-word
  fi
  zle self-insert
}
zle -N expand-global-alias
bindkey " " expand-global-alias