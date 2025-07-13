#!/usr/bin/env bash

set -u

if [[ ${FULL_INSTALL} -eq 1 ]]; then
  npm install -g @anthropic-ai/claude-code
  npm install -g @google/gemini-cli
  npm install -g @openai/codex
fi
