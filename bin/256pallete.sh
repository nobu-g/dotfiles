#!/usr/bin/env bash
# Color pallete checker for shell

for C in {0..255}; do
    echo "$(tput setab $C)"
    echo -n $C
done
tput sgr0
echo
echo