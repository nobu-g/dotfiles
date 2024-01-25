#!/usr/bin/env bash

set -u

if [[ ${FULL_INSTALL} -eq 1 ]]; then
  cargo install cargo-cache # cargo cache cleaner
fi
