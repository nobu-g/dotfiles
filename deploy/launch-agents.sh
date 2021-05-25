#!/usr/bin/env bash

set -u

here=$(dirname "${BASH_SOURCE[0]:-$0}")

for f in "${here}"/*; do
  cp "${f}" "${HOME}/Library/LaunchAgents/"
done
