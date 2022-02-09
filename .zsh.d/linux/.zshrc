set_iterm2_status_bar() {
  mycmd=(${(s: :)${1}})
  printf "\e]1337;SetUserVar=%s=%s\a" lastcmd "$(echo $mycmd | tr -d '\n' | base64)"
}

add-zsh-hook preexec set_iterm2_status_bar

# https://linuxfan.info/disable-ctrl-s
if [[ -t 0 ]]; then
  stty stop undef
  stty start undef
fi

# install specified debian package to ${HOME}/usr/bin
apt-user-install() {
  local cur_dir=$(pwd)
  cd "$(mktemp -d)" || exit
  apt download $1
  dpkg -x "$(ls)" "${HOME}"
  cd "${cur_dir}" || exit
}

export HOMEBREW_NO_AUTO_UPDATE=1

# stderred
if [[ -f "${HOME}/.local/lib/libstderred.so" ]]; then
  export STDERRED_ESC_CODE=$(echo -e "$(tput setaf 9)")
  export LD_PRELOAD="${HOME}/.local/lib/libstderred.so${LD_PRELOAD:+:$LD_PRELOAD}"
fi

# alias
alias pbcopy='clipcopy'
alias pbpaste='clippaste'
alias gzcat='zcat'
alias ssh='LC_PWD="${PWD}" /usr/bin/ssh -o SendEnv=LC_PWD'
[[ -x /usr/bin/git ]] && alias git='/usr/bin/git'
alias nv='nvidia-smi'

# directory alias
hash -d larch="/mnt/larch/${USER}"   # ~larch
hash -d hinoki="/mnt/hinoki/${USER}" # ~hinoki
hash -d elm="/mnt/elm/${USER}"       # ~elm
hash -d zamia="/mnt/zamia/${USER}"   # ~zamia
