#!/usr/bin/env bash

set -exu

export ZDOTDIR="${ZDOTDIR:-${HOME}/.zsh}"
if [[ -z ${DOTPATH:-} ]]; then
  # Resolve to an absolute path so the symlinks below never point relative.
  DOTPATH="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")/.." && pwd)"
  export DOTPATH
fi

mkdir -p "${ZDOTDIR}" "${HOME}/.local/bin"

for f in "${DOTPATH%/}"/.zsh.d/{.zshenv,.zprofile,.zshrc,.p10k.zsh}; do
  ln -snfv "$f" "${ZDOTDIR}"
done
# .zshenv is placed in $HOME, which is the default $ZDOTDIR, for the initial login
ln -snfv "${ZDOTDIR%/}/.zshenv" "${HOME}"/.zshenv

for f in "${DOTPATH%/}"/.config/*; do
  if [[ "$(basename "$f")" == "claude" ]]; then
    mkdir -p "${HOME}/.config/claude"
    for cf in "${f}"/*; do
      ln -snfv "$cf" "${HOME}/.config/claude"
    done
    continue
  fi
  if [[ "$(basename "$f")" == "codex" ]]; then
    mkdir -p "${HOME}/.config/codex" "${HOME}/.agents/skills"
    ln -snfv "${f}/AGENTS.md" "${HOME}/.config/codex/AGENTS.md"
    # Codex loads skills from ~/.agents/skills; share the personal Claude skills
    for sf in "${f}"/skills/*; do
      ln -snfv "$sf" "${HOME}/.agents/skills/$(basename "$sf")"
    done
    continue
  fi
  ln -snfv "$f" "${HOME}/.config"
done
# Reload bat syntaxes
if (type bat &> /dev/null); then
  bat cache --build
fi

ln -snfv "${DOTPATH%/}"/bin/{pyshow,readlinkf,init-direnv} "${HOME}/.local/bin"

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
  ln -snfv "${DOTPATH%/}/bin/${notify_impl}" "${HOME}/.local/bin/notify"
fi

case "${OSTYPE}" in
linux* | cygwin*)
  ln -snfv "${DOTPATH%/}/.emacs.d/init.el" "${HOME}/.emacs.d"
  # On WSL the local desktop editor is reachable, so run the desktop-bridge here
  # too, started by a systemd user unit (WSL has no launchd).
  if [[ -n ${WSL_DISTRO_NAME:-} ]] || grep -qiE 'microsoft|wsl' /proc/version 2> /dev/null; then
    ln -snfv "${DOTPATH%/}/bin/desktop_bridge.py" "${HOME}/.local/bin"
    bash -x "${DOTPATH%/}/deploy/systemd-units.sh"
  fi
  ;;
freebsd* | darwin*)
  if [[ ${OSTYPE} == darwin* ]]; then
    ln -snfv "${DOTPATH%/}"/bin/{copy-file,paste-file,desktop_bridge.py} "${HOME}/.local/bin"
    bash -x "${DOTPATH%/}/deploy/docker-cli-plugins.sh"
  fi
  ln -snfv "${HOME}"/.config/mackup/{.mackup,.mackup.cfg} "${HOME}"
  bash -x "${DOTPATH%/}/deploy/launch-agents.sh"
  ;;
esac
