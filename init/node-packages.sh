#!/usr/bin/env bash

set -u

if [[ ${FULL_INSTALL} -eq 1 ]]; then
  npm install -g @google/gemini-cli
fi
