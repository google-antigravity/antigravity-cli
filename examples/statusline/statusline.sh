#!/bin/bash
set -euo pipefail

# ─── ANSI Helpers (Standard 16-color palette only) ───────────────────────────
R="\033[0m"         # Reset
B="\033[1m"         # Bold
D="\033[2m"         # Dim
I="\033[3m"         # Italic

# Foreground accents (Standard 16 colors)
FG_BLACK="\033[30m"
FG_RED="\033[31m"
FG_GREEN="\033[32m"
FG_YELLOW="\033[33m"
FG_BLUE="\033[34m"
FG_MAGENTA="\033[35m"
FG_CYAN="\033[36m"
FG_WHITE="\033[37m"

FG_GRAY="\033[90m"
FG_BRIGHT_RED="\033[91m"
FG_BRIGHT_GREEN="\033[92m"
FG_BRIGHT_YELLOW="\033[93m"
FG_BRIGHT_BLUE="\033[94m"
FG_BRIGHT_MAGENTA="\033[95m"
FG_BRIGHT_CYAN="\033[96m"
FG_BRIGHT_WHITE="\033[97m"

# Number Highlight Color
NUM_COLOR="${FG_BRIGHT_WHITE}${B}"

# ─── Parse JSON from stdin (Single jq pass for performance) ──────────────────
# Extract all fields in one pass to prevent spawning jq 8 times.
# Defaults are pre-set so a short/truncated read (e.g. jq prints nothing for
# empty input but still exits 0) degrades gracefully instead of tripping
# `set -e`/`set -u` on a failed `read`.
STATE="idle"
USED_PCT=0
VCS_BRANCH=""
VCS_DIRTY="false"
SANDBOX="false"
ARTIFACTS=0
SUBAGENTS=0
BG_TASKS=0
MODEL=""
COLS=80
{
  read -r STATE || true
  read -r USED_PCT || true
  read -r VCS_BRANCH || true
  read -r VCS_DIRTY || true
  read -r SANDBOX || true
  read -r ARTIFACTS || true
  read -r SUBAGENTS || true
  read -r BG_TASKS || true
  read -r MODEL || true
  read -r COLS || true
} <<< "$(
  jq -r '
    (.agent_state // "idle"),
    (.context_window.used_percentage // 0),
    (.vcs.branch // ""),
    (.vcs.dirty // false),
    (.sandbox.enabled // false),
    (.artifact_count // 0),
    (if .subagents | type == "array" then (.subagents | length) else 0 end),
    (.task_count // 0),
    (.model.display_name // ""),
    (.terminal_width // 80)
  ' 2>/dev/null || printf "idle\n0\n\nfalse\nfalse\n0\n0\n0\n\n80\n"
)"

# ─── Normalize fields (Windows portability) ──────────────────────────────────
# Native Windows jq outputs CRLF, which leaves a trailing carriage return in
# every field. That breaks numeric formatting (`printf: 12.5\r: invalid
# number`), string comparisons (`case "$STATE"` never matches `idle\r`), and
# integer tests (`[ "$COLS" -ge 120 ]`). Strip it with pure bash (no fork).
STATE=${STATE%$'\r'}
USED_PCT=${USED_PCT%$'\r'}
VCS_BRANCH=${VCS_BRANCH%$'\r'}
VCS_DIRTY=${VCS_DIRTY%$'\r'}
SANDBOX=${SANDBOX%$'\r'}
ARTIFACTS=${ARTIFACTS%$'\r'}
SUBAGENTS=${SUBAGENTS%$'\r'}
BG_TASKS=${BG_TASKS%$'\r'}
MODEL=${MODEL%$'\r'}
COLS=${COLS%$'\r'}
# An empty state (e.g. jq saw only whitespace and printed nothing) means
# "no payload". Check after CR-stripping so a lone "\r" also falls back.
if [ -z "$STATE" ]; then
  STATE="idle"
fi

# Validate numerics so a malformed payload degrades gracefully instead of
# exiting non-zero under `set -e` (which blanks the statusline entirely).
if [[ ! "$USED_PCT" =~ ^-?([0-9]+(\.[0-9]*)?|\.[0-9]+)$ ]]; then
  USED_PCT=0
fi
# Clamp negatives: context usage can never be below zero.
case "$USED_PCT" in
  -*) USED_PCT=0 ;;
esac
case "$COLS" in
  ''|*[!0-9]*) COLS=80 ;;
esac
if [ "$COLS" -eq 0 ]; then
  COLS=80
fi
case "$ARTIFACTS" in
  ''|*[!0-9]*) ARTIFACTS=0 ;;
esac
case "$SUBAGENTS" in
  ''|*[!0-9]*) SUBAGENTS=0 ;;
esac
case "$BG_TASKS" in
  ''|*[!0-9]*) BG_TASKS=0 ;;
esac

# ─── Computed Values ─────────────────────────────────────────────────────────
# Use LC_NUMERIC=C to prevent bash printf errors in locales that use commas for decimals
PCT_FMT=$(LC_NUMERIC=C printf "%.1f" "$USED_PCT")
PCT_INT=${PCT_FMT%.*}; PCT_INT=${PCT_INT:-0}
# Clamp usage above 100% (e.g. rounding or a malformed payload) so the bar
# never overflows its 15 segments and the label stays truthful.
if [ "$PCT_INT" -gt 100 ]; then
  PCT_FMT="100.0"
  PCT_INT=100
elif [ "$PCT_INT" -eq 100 ]; then
  case "$PCT_FMT" in
    100.0) ;;
    100.*) PCT_FMT="100.0" ;;
  esac
fi

# ─── State Indicator (No background colors) ──────────────────────────────────
case "$STATE" in
  idle)     S="${FG_BRIGHT_GREEN}${B}● READY${R}" ;;
  thinking) S="${FG_BRIGHT_YELLOW}${B}◆ THINKING${R}" ;;
  working)  S="${FG_BRIGHT_CYAN}${B}⚙ WORKING${R}" ;;
  tool_use) S="${FG_BRIGHT_MAGENTA}${B}🔧 TOOL${R}" ;;
  *)        S="${FG_WHITE}${B}⏳ $(echo "$STATE" | tr '[:lower:]' '[:upper:]')${R}" ;;
esac

# ─── VCS Branch ──────────────────────────────────────────────────────────────
V=""
if [ -n "$VCS_BRANCH" ]; then
  if [ "$VCS_DIRTY" = "true" ]; then
    V="${FG_GRAY} ╱ ${FG_BRIGHT_RED}${VCS_BRANCH}${FG_BRIGHT_YELLOW}*${R}"
  else
    V="${FG_GRAY} ╱ ${FG_BRIGHT_BLUE}${VCS_BRANCH}${R}"
  fi
fi

# ─── Model ───────────────────────────────────────────────────────────────────
M=""
if [ -n "$MODEL" ]; then
  M="${FG_GRAY} ╱ ${FG_BRIGHT_MAGENTA}${I}${MODEL}${R}"
fi

# ─── Sandbox Badge ───────────────────────────────────────────────────────────
if [ "$SANDBOX" = "true" ]; then
  SB="${FG_GRAY}sandbox ${FG_BRIGHT_GREEN}${B}ON${R}"
else
  SB="${FG_GRAY}sandbox off${R}"
fi

# ─── Context Bar (15 segments, fine-grain Unicode) ────────────────────────────
BAR_LEN=15
FILLED=$((PCT_INT * BAR_LEN / 100))
REMAINDER=$(( (PCT_INT * BAR_LEN) % 100 ))

# Pick color based on percentage
if [ "$PCT_INT" -ge 90 ]; then
  BAR_COLOR="$FG_BRIGHT_RED"
elif [ "$PCT_INT" -ge 60 ]; then
  BAR_COLOR="$FG_BRIGHT_YELLOW"
else
  BAR_COLOR="$FG_BRIGHT_WHITE"
fi

# Build bar with partial-fill last block
BAR=""
for ((i = 0; i < BAR_LEN; i++)); do
  if [ "$i" -lt "$FILLED" ]; then
    BAR="${BAR}█"
  elif [ "$i" -eq "$FILLED" ]; then
    if [ "$REMAINDER" -ge 75 ]; then
      BAR="${BAR}▓"
    elif [ "$REMAINDER" -ge 50 ]; then
      BAR="${BAR}▒"
    elif [ "$REMAINDER" -ge 25 ]; then
      BAR="${BAR}░"
    else
      BAR="${BAR}·"
    fi
  else
    BAR="${BAR}·"
  fi
done

# ─── Stats ───────────────────────────────────────────────────────────────────
CTX="${FG_GRAY}ctx ${BAR_COLOR}${BAR} ${NUM_COLOR}${PCT_FMT}%${R}"
ART_FMT="${FG_GRAY}artifacts ${NUM_COLOR}${ARTIFACTS}${R}"
SUB_FMT="${FG_GRAY}subagents ${NUM_COLOR}${SUBAGENTS}${R}"
BG_FMT="${FG_GRAY}tasks ${NUM_COLOR}${BG_TASKS}${R}"

# ─── Separators ──────────────────────────────────────────────────────────────
DOT="${FG_GRAY} · ${R}"

# ─── Output ──────────────────────────────────────────────────────────────────
LINE1="${S}${M}${V}"
LINE2=" ${CTX}${DOT}${ART_FMT}${DOT}${SUB_FMT}${DOT}${BG_FMT}${DOT}${SB}"

if [ "$COLS" -ge 120 ]; then
  # Wide: single line
  echo -e "${LINE1}${FG_GRAY}  │  ${R}${LINE2}"
elif [ "$COLS" -ge 80 ]; then
  # Medium: two-line layout with border
  echo -e "${FG_GRAY}╭─${R} ${LINE1}"
  echo -e "${FG_GRAY}╰─${R}${LINE2}"
else
  # Narrow: compact two-line, minimal chrome
  echo -e "${S}${M}"
  echo -e "${CTX}${DOT}${BG_FMT}"
fi
