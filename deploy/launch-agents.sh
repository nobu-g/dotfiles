#!/usr/bin/env bash

set -u

here=$(dirname "${BASH_SOURCE[0]:-$0}")

# ~/Library/LaunchAgents does not exist on a fresh account; create it so cp
# below does not abort the whole deploy under `set -e` (via main.sh).
mkdir -p "${HOME}/Library/LaunchAgents"

# The autoUnmount jobs exec $HOME/scripts/auto-unmount, a machine-specific
# helper that is not part of this repo. Without it launchd would relaunch a
# failing job every few minutes, so deploy them only where the script exists.
for f in "${here%/}"/launchd_jobs/*; do
  case "$(basename "${f}")" in
    com.user.autoUnmount.*)
      [[ -e ${HOME}/scripts/auto-unmount ]] || continue
      ;;
  esac
  cp "${f}" "${HOME}/Library/LaunchAgents/"
done
