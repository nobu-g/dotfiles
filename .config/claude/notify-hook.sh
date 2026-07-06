#!/usr/bin/env bash
# notify-hook.sh — Claude Code Stop / Notification hook.
# Reads the hook event JSON on stdin and pops a desktop notification via
# ~/.local/bin/notify (platform-specific backend). Wired up from settings.json
# for both the Stop and Notification hooks.
#
# On macOS iTerm2 already rings the bell and shows its own notification, so we
# bail out early there to avoid duplicates; Linux / WSL hosts still notify.
set -u

# macOS: iTerm2's bell notification already covers this — skip.
[[ "$(uname)" == Darwin ]] && exit 0

input=$(cat)

# Notification title: "Claude Code: <cwd basename>".
dir=$(printf '%s' "$input" | jq -r '.cwd // ""' | xargs basename 2>/dev/null)

# Subtitle: the Notification event carries a .message; the Stop event does not,
# so fall back to a fixed string. One script serves both hooks this way.
subtitle=$(printf '%s' "$input" | jq -r '.message // "Action required"')

# Body: the most recent genuine user prompt from the transcript (skipping the
# synthetic <command-*> / <local-command-*> entries), collapsed to one line.
transcript=$(printf '%s' "$input" | jq -r '.transcript_path // ""')
prompt=$(jq -rs '
  first(
    .[]
    | select(.type == "user")
    | .message.content
    | select(type == "string")
    | select(test("^<(command-|local-command-)") | not)
  ) // ""
  | gsub("[\n\r\t]+"; " ")
' "$transcript" 2>/dev/null)

notify -t "Claude Code: ${dir:-session}" -s "$subtitle" "${prompt:-no prompt}" > /dev/null 2>&1 || true
