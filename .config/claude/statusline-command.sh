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

BRANCH_ICON='' # U+F126 (nf-fa-code-branch)
DIR_HOME_ICON=''     # U+F015 (nf-fa-home)
DIR_HOME_SUB_ICON='' # U+F07C (nf-fa-folder_open)
DIR_FOLDER_ICON=''   # U+F115 (nf-fa-folder_open_o)
THIN=''        # thin divider for line 2

# foreground helpers
fg() { printf '\033[38;5;%sm' "$1"; }
bg() { printf '\033[48;5;%sm' "$1"; }

GREY=$(fg 244)
WHITE=$(fg 255)
GREEN=$(fg 71)
YELLOW=$(fg 179)
RED=$(fg 167)
BLUE=$(fg 39)
CYAN=$(fg 80)
MAGENTA=$(fg 176)
ORANGE=$(fg 215)

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
# Line 1: p10k lean style  dir  git  pr
# ---------------------------------------------------------------------------
LINE1=""

# directory: leading dir icon (p10k nerdfont-complete), then
# dim blue ancestor path + bold bright-blue last component
DIR_DIM=$(fg 31)    # steel blue (ancestors, matches p10k DIR_FOREGROUND)
DIR_BRIGHT=$(fg 39) # dodger blue (last component, matches p10k DIR_ANCHOR_FOREGROUND)
# pick dir icon the way p10k does: home / home-subdir / other
if [ "$SHORT_CWD" = "~" ]; then
  dir_icon="$DIR_HOME_ICON"
elif [ "${SHORT_CWD#\~/}" != "$SHORT_CWD" ]; then
  dir_icon="$DIR_HOME_SUB_ICON"
else
  dir_icon="$DIR_FOLDER_ICON"
fi
LINE1+="${DIR_DIM}${dir_icon} ${RESET}"
dir_parent="${SHORT_CWD%/*}"
dir_last="${SHORT_CWD##*/}"
if [ "$dir_parent" = "$SHORT_CWD" ] || [ -z "$dir_parent" ]; then
  LINE1+="${BOLD}${DIR_BRIGHT}${SHORT_CWD}${RESET}"
else
  LINE1+="${DIR_DIM}${dir_parent}/${RESET}${BOLD}${DIR_BRIGHT}${dir_last}${RESET}"
fi

# git branch + remote tracking
GIT_CLEAN=$(fg 76)   # medium green (clean branch)
GIT_DIRTY=$(fg 178)  # amber (dirty branch)
GIT_STATUS=$(fg 178) # amber (status counts)
if [ -n "$BRANCH" ]; then
  LINE1+="  ${GIT_CLEAN}${BRANCH_ICON} ${BRANCH}${RESET}"
  # order mirrors .p10k.zsh my_git_formatter: behind, ahead, staged, unstaged, untracked
  [ "${BEHIND:-0}"    -gt 0 ] && LINE1+=" ${GIT_CLEAN}⇣${BEHIND}${RESET}"
  [ "${AHEAD:-0}"     -gt 0 ] && LINE1+=" ${GIT_CLEAN}⇡${AHEAD}${RESET}"
  [ "${STAGED:-0}"    -gt 0 ] && LINE1+=" ${GIT_STATUS}+${STAGED}${RESET}"
  [ "${MODIFIED:-0}"  -gt 0 ] && LINE1+=" ${GIT_STATUS}!${MODIFIED}${RESET}"
  [ "${UNTRACKED:-0}" -gt 0 ] && LINE1+=" ${BLUE}?${UNTRACKED}${RESET}"
elif [ -n "$REPO" ]; then
  LINE1+="  ${GIT_CLEAN}${BRANCH_ICON} ${REPO}${RESET}"
fi

# pull request
if [ -n "$PR_NUM" ]; then
  case "$PR_STATE" in
    approved)          prc="$GREEN" ;;
    changes_requested) prc="$RED" ;;
    draft)             prc="$GREY" ;;
    *)                 prc="$CYAN" ;;
  esac
  LINE1+="  ${prc} #${PR_NUM}${PR_STATE:+ ${PR_STATE}}${RESET}"
fi

# ---------------------------------------------------------------------------
# Line 2: model · context bar · cost · time · lines · effort · limits
# ---------------------------------------------------------------------------
divider=" ${GREY}${THIN}${RESET} "
parts=()

# model + effort
EFFORT=$(json '.effort.level // empty')
if [ -n "$EFFORT" ]; then
  parts+=("${CYAN}${BOLD}${MODEL}${RESET} ${MAGENTA}⚙ ${EFFORT}${RESET}")
else
  parts+=("${CYAN}${BOLD}${MODEL}${RESET}")
fi

# helper: render a percentage bar (width=8 by default)
make_bar() {
  local pct="$1" color="$2" width="${3:-8}"
  pct=${pct%.*}; pct=${pct:-0}
  local filled=$(( pct * width / 100 ))
  [ "$filled" -gt "$width" ] && filled=$width
  local empty=$(( width - filled ))
  local bar=""
  [ "$filled" -gt 0 ] && printf -v _f "%${filled}s" && bar="${_f// /█}"
  [ "$empty"  -gt 0 ] && printf -v _e "%${empty}s"  && bar+="${GREY}${_e// /░}${RESET}"
  printf '%s' "${color}${bar}${RESET} ${color}${pct}%${RESET}"
}

# context window (number only)
PCT=$(json '.context_window.used_percentage // empty')
if [ -n "$PCT" ]; then
  PCT=${PCT%.*}; PCT=${PCT:-0}
  if   [ "$PCT" -ge 90 ]; then bc="$RED"
  elif [ "$PCT" -ge 70 ]; then bc="$YELLOW"
  else bc="$GREEN"; fi
  parts+=("${GREY}ctx${RESET} ${bc}${PCT}%${RESET}")
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


# rate limits (Pro/Max only)
# convert ISO 8601 resets_at to relative/absolute label: "Xm" or "H:MM"
reset_label() {
  local iso="$1"
  [ -z "$iso" ] && return
  local epoch now diff
  epoch=$(date -j -f '%Y-%m-%dT%H:%M:%S' "${iso%%.*}" '+%s' 2>/dev/null \
       || date -d "$iso" '+%s' 2>/dev/null) || return
  now=$(date +%s)
  diff=$(( epoch - now ))
  if [ "$diff" -le 0 ]; then
    printf 'now'
  elif [ "$diff" -lt 3600 ]; then
    printf '%dm' $(( diff / 60 ))
  else
    date -j -f '%s' "$epoch" '+%-H:%M' 2>/dev/null \
    || date -d "@$epoch" '+%-H:%M' 2>/dev/null
  fi
}

FIVE_H=$(json '.rate_limits.five_hour.used_percentage // empty')
FIVE_H_RESET=$(json '.rate_limits.five_hour.resets_at // empty')
WEEK=$(json '.rate_limits.seven_day.used_percentage // empty')
if [ -n "$FIVE_H" ]; then
  fh_int=${FIVE_H%.*}; fh_int=${fh_int:-0}
  if   [ "$fh_int" -ge 90 ]; then fhc="$RED"
  elif [ "$fh_int" -ge 70 ]; then fhc="$YELLOW"
  else fhc="$ORANGE"; fi
  fh_label="${GREY}5h${RESET} $(make_bar "$FIVE_H" "$fhc")"
  fh_reset=$(reset_label "$FIVE_H_RESET")
  [ -n "$fh_reset" ] && fh_label+=" ${GREY}↺${fh_reset}${RESET}"
  parts+=("$fh_label")
fi
if [ -n "$WEEK" ]; then
  wk_int=${WEEK%.*}; wk_int=${wk_int:-0}
  if   [ "$wk_int" -ge 90 ]; then wkc="$RED"
  elif [ "$wk_int" -ge 70 ]; then wkc="$YELLOW"
  else wkc="$ORANGE"; fi
  parts+=("${GREY}7d${RESET} $(make_bar "$WEEK" "$wkc")")
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
