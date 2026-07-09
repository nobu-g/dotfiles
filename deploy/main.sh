#!/usr/bin/env bash

set -exu

export ZDOTDIR="${ZDOTDIR:-${HOME}/.zsh}"
if [[ -z ${DOTPATH:-} ]]; then
  # Resolve to an absolute path so the symlinks below never point relative.
  DOTPATH="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")/.." && pwd)"
  export DOTPATH
fi

mkdir -p "${ZDOTDIR}" "${HOME}/.local/bin"

backup_path_with_date() {
  local src="${1%%/}"
  local backup="${src}.bak$(date "+%Y-%m-%d")"
  local candidate="${backup}"
  local i=1

  while [[ -e ${candidate} || -L ${candidate} ]]; do
    candidate="${backup}.${i}"
    i=$((i + 1))
  done

  mv -v "${src}" "${candidate}"
}

# link DEST SRC...
# Symlink each SRC into place. If DEST is an existing directory, each link is
# created inside it (named after SRC); otherwise DEST is the exact link path
# (use a single SRC in that case). Anything already at a target that is not
# already the intended symlink is backed up before the link is (re)created, so
# real files are never silently clobbered on deploy.
link() {
  local dest="$1"
  shift

  local src link_path
  for src in "$@"; do
    if [[ -d ${dest} ]]; then
      link_path="${dest%/}/${src##*/}"
    else
      link_path="${dest}"
    fi
    if { [[ -e ${link_path} ]] || [[ -L ${link_path} ]]; } && [[ "$(readlink "${link_path}" 2> /dev/null)" != "$src" ]]; then
      backup_path_with_date "${link_path}"
    fi
    ln -snfv "$src" "${link_path}"
  done
}

link "${ZDOTDIR}" "${DOTPATH%/}"/.zsh.d/{.zshenv,.zprofile,.zshrc,.p10k.zsh}
# .zshenv is placed in $HOME, which is the default $ZDOTDIR, for the initial login
link "${HOME}/.zshenv" "${ZDOTDIR%/}/.zshenv"

for f in "${DOTPATH%/}"/.config/*; do
  case "${f##*/}" in
  claude)
    mkdir -p "${HOME}/.config/claude"
    link "${HOME}/.config/claude" "${f}"/*
    ;;
  codex)
    mkdir -p "${HOME}/.config/codex" "${HOME}/.agents/skills"
    link "${HOME}/.config/codex/AGENTS.md" "${f}/AGENTS.md"
    # Codex loads skills from ~/.agents/skills; share the personal Claude skills
    link "${HOME}/.agents/skills" "${f}"/skills/*
    ;;
  *)
    link "${HOME}/.config" "$f"
    ;;
  esac
done

# Reload bat syntaxes
if (type bat &> /dev/null); then
  bat cache --build
fi

link "${HOME}/.local/bin" "${DOTPATH%/}"/bin/{readlinkf,init-direnv}

# notify: deploy the environment-specific desktop-notification backend as `notify`.
# All variants share the same CLI: notify [-t TITLE] [-s SUBTITLE] [BODY ...].
notify_impl=""
case "${OSTYPE}" in
freebsd* | darwin*)
  notify_impl="notify.darwin"
  ;;
linux* | cygwin*)
  if [[ -n ${WSL_DISTRO_NAME:-} ]] || grep -qiE 'microsoft|wsl' /proc/version 2> /dev/null; then
    notify_impl="notify.wsl"
  else
    notify_impl="notify.ssh_remote"
  fi
  ;;
esac
if [[ -n ${notify_impl} ]]; then
  link "${HOME}/.local/bin/notify" "${DOTPATH%/}/bin/${notify_impl}"
fi

case "${OSTYPE}" in
linux* | cygwin*)
  link "${HOME}/.emacs.d" "${DOTPATH%/}/.emacs.d/init.el"
  # On WSL the local desktop editor is reachable, so run the desktop-bridge here
  # too, started by a systemd user unit (WSL has no launchd).
  if [[ -n ${WSL_DISTRO_NAME:-} ]] || grep -qiE 'microsoft|wsl' /proc/version 2> /dev/null; then
    link "${HOME}/.local/bin" "${DOTPATH%/}/bin/desktop_bridge.py"
    bash -x "${DOTPATH%/}/deploy/systemd-units.sh"
  fi
  ;;
freebsd* | darwin*)
  if [[ ${OSTYPE} == darwin* ]]; then
    link "${HOME}/.local/bin" "${DOTPATH%/}"/bin/{copy-file,paste-file,desktop_bridge.py}
    bash -x "${DOTPATH%/}/deploy/docker-cli-plugins.sh"
  fi
  link "${HOME}" "${HOME}"/.config/mackup/{.mackup,.mackup.cfg}
  bash -x "${DOTPATH%/}/deploy/launch-agents.sh"
  ;;
esac
