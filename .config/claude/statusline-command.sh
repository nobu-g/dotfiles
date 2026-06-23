#!/usr/bin/env bash
# Claude Code statusLine command
# Powerlevel10k-inspired, two-line rich layout.
#   Line 1: powerline segments  -> dir | git | pr
#   Line 2: meta/usage          -> model · context bar · time · lines · effort · limits
#
# Test with mock input:
#   echo '{"model":{"display_name":"Opus"},"workspace":{"current_dir":"'"$HOME"'/p","repo":{"owner":"o","name":"n"}},"context_window":{"used_percentage":42},"cost":{"total_cost_usd":1.23,"total_duration_ms":185000,"total_lines_added":156,"total_lines_removed":23},"effort":{"level":"high"},"session_id":"test"}' | bash statusline-command.sh

input=$(cat)
json() { printf '%s' "$input" | jq -r "$1" 2>/dev/null; }

# ---------------------------------------------------------------------------
# Palette (256-color) and glyphs
# ---------------------------------------------------------------------------
RESET=$'\033[0m'
DIM=$'\033[2m'
BOLD=$'\033[1m'

SEP=''        # powerline right separator (U+E0B0, needs a Nerd/Powerline font)
BRANCH_ICON='' # U+E0A0
THIN=''        # thin divider for line 2

# foreground helpers
fg() { printf '\033[38;5;%sm' "$1"; }
bg() { printf '\033[48;5;%sm' "$1"; }

GREY=$(fg 244)
GREEN=$(fg 71)
YELLOW=$(fg 179)
RED=$(fg 167)
BLUE=$(fg 75)
CYAN=$(fg 80)
MAGENTA=$(fg 176)
ORANGE=$(fg 215)

# ---------------------------------------------------------------------------
# Powerline segment builder (line 1)
# ---------------------------------------------------------------------------
LINE1=""
LAST_BG=""
seg() { # bg fg text
  local b="$1" f="$2" t="$3"
  [ -z "$t" ] && return
  if [ -n "$LAST_BG" ]; then
    LINE1+="$(fg "$LAST_BG")$(bg "$b")${SEP}"
  fi
  LINE1+="$(bg "$b")$(fg "$f") ${t} "
  LAST_BG="$b"
}
seg_close() {
  [ -n "$LAST_BG" ] && LINE1+="${RESET}$(fg "$LAST_BG")${SEP}${RESET}"
}

# ---------------------------------------------------------------------------
# Data extraction
# ---------------------------------------------------------------------------
MODEL=$(json '.model.display_name // "?"')
CWD=$(json '.workspace.current_dir // .cwd // empty')
[ -z "$CWD" ] && CWD=$(pwd)
SHORT_CWD=${CWD/#$HOME/\~}

REPO=$(json '.workspace.repo | if . then .owner + "/" + .name else empty end')
PR_NUM=$(json '.pr.number // empty')
PR_STATE=$(json '.pr.review_state // empty')

# ---------------------------------------------------------------------------
# Git info (cached per session to keep the status line snappy)
# ---------------------------------------------------------------------------
SESSION_ID=$(json '.session_id // "nosession"')
CACHE_FILE="${TMPDIR:-/tmp}/claude-statusline-git-${SESSION_ID}"
CACHE_MAX_AGE=3

cache_mtime() { stat -f %m "$1" 2>/dev/null || stat -c %Y "$1" 2>/dev/null || echo 0; }
cache_stale() {
  [ ! -f "$CACHE_FILE" ] && return 0
  [ $(( $(date +%s) - $(cache_mtime "$CACHE_FILE") )) -gt "$CACHE_MAX_AGE" ]
}

git_collect() {
  cd "$CWD" 2>/dev/null || { printf '\t\t\t\t\t'; return; }
  git rev-parse --git-dir >/dev/null 2>&1 || { printf '\t\t\t\t\t'; return; }
  local g='git --no-optional-locks'
  local branch staged modified untracked ahead behind counts
  branch=$($g symbolic-ref --short HEAD 2>/dev/null || $g rev-parse --short HEAD 2>/dev/null)
  staged=$($g diff --cached --numstat 2>/dev/null | grep -c '')
  modified=$($g diff --numstat 2>/dev/null | grep -c '')
  untracked=$($g ls-files --others --exclude-standard 2>/dev/null | grep -c '')
  counts=$($g rev-list --left-right --count '@{upstream}...HEAD' 2>/dev/null)
  behind=$(printf '%s' "$counts" | awk '{print $1+0}')
  ahead=$(printf '%s' "$counts" | awk '{print $2+0}')
  printf '%s\t%s\t%s\t%s\t%s\t%s' "$branch" "$staged" "$modified" "$untracked" "$ahead" "$behind"
}

if cache_stale; then
  git_collect > "$CACHE_FILE" 2>/dev/null
fi
IFS=$'\t' read -r BRANCH STAGED MODIFIED UNTRACKED AHEAD BEHIND < "$CACHE_FILE" 2>/dev/null

# ---------------------------------------------------------------------------
# Line 1: powerline segments
# ---------------------------------------------------------------------------
# dir
seg 31 235 " ${SHORT_CWD}"
# git
if [ -n "$BRANCH" ]; then
  status=""
  [ "${STAGED:-0}" -gt 0 ]    && status+=" +${STAGED}"
  [ "${MODIFIED:-0}" -gt 0 ]  && status+=" !${MODIFIED}"
  [ "${UNTRACKED:-0}" -gt 0 ] && status+=" ?${UNTRACKED}"
  [ "${AHEAD:-0}" -gt 0 ]     && status+=" ⇡${AHEAD}"
  [ "${BEHIND:-0}" -gt 0 ]    && status+=" ⇣${BEHIND}"
  if [ -n "$status" ]; then
    seg 178 235 "${BRANCH_ICON} ${BRANCH}${status}"   # amber: dirty
  else
    seg 70 235 "${BRANCH_ICON} ${BRANCH}"             # green: clean
  fi
elif [ -n "$REPO" ]; then
  seg 70 235 "${BRANCH_ICON} ${REPO}"
fi
# pull request
if [ -n "$PR_NUM" ]; then
  case "$PR_STATE" in
    approved)          prc=70 ;;
    changes_requested) prc=167 ;;
    draft)             prc=244 ;;
    *)                 prc=68 ;;
  esac
  seg "$prc" 235 " #${PR_NUM}${PR_STATE:+ ${PR_STATE}}"
fi
seg_close

# ---------------------------------------------------------------------------
# Line 2: model · context bar · cost · time · lines · effort · limits
# ---------------------------------------------------------------------------
divider=" ${GREY}${THIN}${RESET} "
parts=()

# model
parts+=("${CYAN}${BOLD}${MODEL}${RESET}")

# context window bar
PCT=$(json '.context_window.used_percentage // empty')
if [ -n "$PCT" ]; then
  PCT=${PCT%.*}; PCT=${PCT:-0}
  if   [ "$PCT" -ge 90 ]; then bc="$RED"
  elif [ "$PCT" -ge 70 ]; then bc="$YELLOW"
  else bc="$GREEN"; fi
  width=10
  filled=$(( PCT * width / 100 ))
  [ "$filled" -gt "$width" ] && filled=$width
  empty=$(( width - filled ))
  bar=""
  [ "$filled" -gt 0 ] && printf -v f "%${filled}s" && bar="${f// /█}"
  [ "$empty" -gt 0 ]  && printf -v e "%${empty}s"  && bar+="${GREY}${e// /░}${RESET}"
  parts+=("${GREY}ctx${RESET} ${bc}${bar}${RESET} ${bc}${PCT}%${RESET}")
fi

# duration
DUR_MS=$(json '.cost.total_duration_ms // empty')
if [ -n "$DUR_MS" ]; then
  sec=$(( DUR_MS / 1000 )); h=$(( sec / 3600 )); m=$(( (sec % 3600) / 60 )); s=$(( sec % 60 ))
  if   [ "$h" -gt 0 ]; then dur="${h}h ${m}m"
  elif [ "$m" -gt 0 ]; then dur="${m}m ${s}s"
  else dur="${s}s"; fi
  parts+=("${GREY}⏱ ${dur}${RESET}")
fi

# lines changed
ADD=$(json '.cost.total_lines_added // 0')
DEL=$(json '.cost.total_lines_removed // 0')
if [ "${ADD:-0}" -gt 0 ] || [ "${DEL:-0}" -gt 0 ]; then
  parts+=("${GREEN}+${ADD}${RESET} ${RED}-${DEL}${RESET}")
fi

# reasoning effort
EFFORT=$(json '.effort.level // empty')
[ -n "$EFFORT" ] && parts+=("${MAGENTA}⚙ ${EFFORT}${RESET}")

# rate limits (Pro/Max only)
FIVE_H=$(json '.rate_limits.five_hour.used_percentage // empty')
WEEK=$(json '.rate_limits.seven_day.used_percentage // empty')
if [ -n "$FIVE_H" ] || [ -n "$WEEK" ]; then
  rl=""
  [ -n "$FIVE_H" ] && rl+="5h $(printf '%.0f' "$FIVE_H")%"
  [ -n "$WEEK" ]   && rl+="${rl:+ }7d $(printf '%.0f' "$WEEK")%"
  parts+=("${ORANGE}${rl}${RESET}")
fi

# join line 2 parts with the thin divider
LINE2=""
for i in "${!parts[@]}"; do
  [ "$i" -gt 0 ] && LINE2+="$divider"
  LINE2+="${parts[$i]}"
done

# ---------------------------------------------------------------------------
# Output
# ---------------------------------------------------------------------------
printf '%b\n' "$LINE1"
printf '%b\n' "$LINE2"
