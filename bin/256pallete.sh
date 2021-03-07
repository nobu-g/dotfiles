#!/usr/bin/env bash
# Color pallete checker for shell

for C in {0..255}; do
  tput setab "$C"
  echo
  echo -n "$C"
done
tput sgr0
echo
