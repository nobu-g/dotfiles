function set_iterm2_status_bar() {
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
  cur_dir=$(pwd)
  tmp_dir=$(mktemp -d) && cd tmp_dir
  apt download $1
  dpkg -x $(ls) ${HOME}
  cd ${cur_dir}
}

export HOMEBREW_NO_AUTO_UPDATE=1
