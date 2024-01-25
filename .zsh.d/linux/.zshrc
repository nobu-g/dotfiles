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

# stderred
# if [[ -f "${HOMEBREW_PREFIX}/lib/libstderred.so" ]] && [[ $HOST != "moss110" ]]; then
#   export STDERRED_ESC_CODE=$(echo -e "$(tput setaf 9)")
#   export LD_PRELOAD="${HOMEBREW_PREFIX}/lib/libstderred.so${LD_PRELOAD:+:$LD_PRELOAD}"
# fi

# LESS man page colors (makes Man pages more readable).
man() {
  env -u LD_PRELOAD -u MANPAGER man "$@" | col -bx | bat -l man -p
}

export EMACS_SERVER_SOCKET="${TMPDIR:-/tmp}/emacs$(id -u)/server"

# alias
alias pbcopy='clipcopy'
alias pbpaste='clippaste'
alias gzcat='zcat'
alias ssh='LC_PWD="${PWD}" /usr/bin/ssh -o SendEnv=LC_PWD'
[[ -x /usr/bin/git ]] && alias git='/usr/bin/git'
alias nv='nvidia-smi'
alias sc='systemctl'
alias tmux=/usr/bin/tmux

# directory alias
for nas in larch hinoki elm zamia mint osmanthus clover; do
  hash -d "${nas}"="/mnt/${nas}/${USER}"  # ~nas points to /mnt/nas/${USER}
done
