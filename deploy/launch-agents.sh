#!/usr/bin/env bash

set -u

here=$(dirname "${BASH_SOURCE[0]:-$0}")

# ~/Library/LaunchAgents does not exist on a fresh account; create it so cp
# below does not abort the whole deploy under `set -e` (via main.sh).
mkdir -p "${HOME}/Library/LaunchAgents"

for f in "${here%/}"/launchd_jobs/*; do
  cp "${f}" "${HOME}/Library/LaunchAgents/"
done
