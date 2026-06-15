#!/bin/bash
set -euo pipefail
INPUT_JSON=$(cat)


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
{
  read -r STATE
  read -r USED_PCT
  read -r VCS_BRANCH
  read -r VCS_DIRTY
  read -r VCS_TYPE
  read -r VCS_CLIENT
  read -r SANDBOX
  read -r SANDBOX_NET
  read -r ARTIFACTS
  read -r SUBAGENTS
  read -r BG_TASKS
  read -r MODEL_ID
  read -r MODEL_NAME
  read -r COLS
  read -r CWD
  read -r CONV_ID
  read -r PRODUCT
  read -r INPUT_TOKENS
  read -r OUTPUT_TOKENS
  read -r CTX_LIMIT
  read -r CTX_USED
  read -r REM_PCT
  read -r GEMINI_5H
  read -r GEMINI_WK
  read -r TP_5H
  read -r TP_WK
  read -r GEMINI_5H_RESET
  read -r GEMINI_WK_RESET
  read -r TP_5H_RESET
  read -r TP_WK_RESET
} <<< "$(
  echo "$INPUT_JSON" | jq -r '
    (.agent_state // "idle"),
    (.context_window.used_percentage // 0),
    (.vcs.branch // ""),
    (.vcs.dirty // false),
    (.vcs.type // ""),
    (.vcs.client // ""),
    (.sandbox.enabled // false),
    (.sandbox.allow_network // false),
    (.artifact_count // 0),
    (if .subagents | type == "array" then (.subagents | length) else 0 end),
    (.task_count // 0),
    (.model.id // ""),
    (.model.display_name // ""),
    (.terminal_width // 80),
    (.cwd // ""),
    (.conversation_id // ""),
    (.product // ""),
    (.context_window.total_input_tokens // 0),
    (.context_window.total_output_tokens // 0),
    (.context_window.context_window_size // 0),
    ((.context_window.total_input_tokens // 0) + (.context_window.total_output_tokens // 0)),
    (.context_window.remaining_percentage // 100),
    (if .quota["gemini-5h"].remaining_fraction != null then ((.quota["gemini-5h"].remaining_fraction * 1000 | round) / 10) else -1 end),
    (if .quota["gemini-weekly"].remaining_fraction != null then ((.quota["gemini-weekly"].remaining_fraction * 1000 | round) / 10) else -1 end),
    (if .quota["3p-5h"].remaining_fraction != null then ((.quota["3p-5h"].remaining_fraction * 1000 | round) / 10) else -1 end),
    (if .quota["3p-weekly"].remaining_fraction != null then ((.quota["3p-weekly"].remaining_fraction * 1000 | round) / 10) else -1 end),
    (.quota["gemini-5h"].reset_in_seconds // -1),
    (.quota["gemini-weekly"].reset_in_seconds // -1),
    (.quota["3p-5h"].reset_in_seconds // -1),
    (.quota["3p-weekly"].reset_in_seconds // -1)
  ' 2>/dev/null || printf "idle\n0\n\nfalse\n\n\nfalse\nfalse\n0\n0\n0\n\n\n80\n\n\n\n0\n0\n0\n0\n100\n-1\n-1\n-1\n-1\n-1\n-1\n-1\n-1\n"
)"


# ─── Separators ──────────────────────────────────────────────────────────────
DOT="${FG_GRAY} | ${R}"


# ─── VCS directly from git (bypasses JSON parsing entirely) ──────────────────
GIT_DIR="${CWD:-.}"
VCS_BRANCH=$(git -C "$GIT_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
if [ -n "$VCS_BRANCH" ]; then
  VCS_TYPE="git"
  if git -C "$GIT_DIR" status --porcelain 2>/dev/null | grep -q .; then
    VCS_DIRTY="true"
  else
    VCS_DIRTY="false"
  fi
else
  VCS_TYPE=""
  VCS_DIRTY="false"
fi

# ─── Computed & Formatted Values ─────────────────────────────────────────────
PCT_FMT=$(LC_NUMERIC=C printf "%.1f" "$USED_PCT")
PCT_INT=${USED_PCT%.*}; PCT_INT=${PCT_INT:-0}

human_format() {
  local num=$1
  if [ -z "$num" ] || [ "$num" -eq 0 ] 2>/dev/null; then
    echo "0"
    return
  fi
  if [ "$num" -ge 1000000 ] 2>/dev/null; then
    echo "$((num / 1000000)).$(((num % 1000000) / 100000))M"
  elif [ "$num" -ge 1000 ] 2>/dev/null; then
    echo "$((num / 1000)).$(((num % 1000) / 100))K"
  else
    echo "$num"
  fi
}

INPUT_TOK_FMT=$(human_format "$INPUT_TOKENS")
OUTPUT_TOK_FMT=$(human_format "$OUTPUT_TOKENS")
CTX_LIMIT_FMT=$(human_format "$CTX_LIMIT")
CTX_USED_FMT=$(human_format "$CTX_USED")

shorten_path() {
  local path=$1
  if [ -z "$path" ]; then
    echo ""
    return
  fi
  path="${path/#$HOME/\~}"
  if [ "${#path}" -gt 25 ]; then
    echo "...$(basename "$path")"
  else
    echo "$path"
  fi
}
CWD_SHORT=$(shorten_path "$CWD")

# ─── Strip ANSI escapes to measure visible length ────────────────────────────
visible_len() {
  # Strips ESC sequences and counts remaining bytes
  printf '%s' "$(echo -e "$1" | sed 's/\x1b\[[0-9;]*m//g')" | wc -m
}

# ─── State Indicator ─────────────────────────────────────────────────────────
case "$STATE" in
  idle)     S="${FG_BRIGHT_GREEN}${B}  READY${R}" ;;
  thinking) S="${FG_BRIGHT_YELLOW}${B} 󰟷 THINKING${R}" ;;
  working)  S="${FG_BRIGHT_CYAN}${B}  WORKING${R}" ;;
  tool_use) S="${FG_BRIGHT_MAGENTA}${B}  TOOL${R}" ;;
  *)        S="${FG_WHITE}${B}  $(echo "$STATE" | tr '[:lower:]' '[:upper:]')${R}" ;;
esac

# ─── VCS Branch & Type (fixed: color applied correctly in both branches) ─────
V=""
if [ -n "$VCS_BRANCH" ]; then
  VCS_LABEL="${VCS_TYPE:-git}"
  if [ "$VCS_DIRTY" = "true" ]; then
    V="${DOT}${R}${FG_BRIGHT_RED} ${VCS_BRANCH}${FG_BRIGHT_YELLOW}*${R}"
  else
    V="${DOT}${R}${FG_BRIGHT_BLUE} ${VCS_BRANCH}${R}"
  fi
fi

# ─── Model ───────────────────────────────────────────────────────────────────
MODEL_DISP=" ${R}${MODEL_NAME:-$MODEL_ID}"
M=""
if [ -n "$MODEL_DISP" ]; then
  M="${FG_GRAY}${DOT}${FG_BRIGHT_MAGENTA}${I}${MODEL_DISP}${R}"
fi

# ─── Sandbox Badge ───────────────────────────────────────────────────────────
if [ "$SANDBOX" = "true" ]; then
  if [ "$SANDBOX_NET" = "true" ]; then
    SB="${FG_GREEN}󰒙 ${FG_BRIGHT_GREEN}${B}ON (net)${R}"
  else
    SB="${FG_GREEN}󰴴 ${FG_BRIGHT_GREEN}${B}ON (no-net)${R}"
  fi
else
  SB="${FG_RED}󰦜 ${FG_BRIGHT_RED}${B}OFF${R}"
fi

# ─── Context Bar (20 segments) ───────────────────────────────────────────────
BAR_LEN=20
FILLED=$((PCT_INT * BAR_LEN / 100))
REMAINDER=$(( (PCT_INT * BAR_LEN) % 100 ))

if   [ "$PCT_INT" -ge 90 ]; then FILL_COLOR="$FG_BRIGHT_RED"
elif [ "$PCT_INT" -ge 60 ]; then FILL_COLOR="$FG_BRIGHT_YELLOW"
else                              FILL_COLOR="$FG_YELLOW"
fi

BAR=""
for ((i = 0; i < BAR_LEN; i++)); do
  if   [ "$i" -lt "$FILLED" ]; then
    BAR="${BAR}${FILL_COLOR}█${R}"
  elif [ "$i" -eq "$FILLED" ]; then
    if   [ "$REMAINDER" -ge 75 ]; then BAR="${BAR}${FILL_COLOR}▓${R}${FG_GRAY}"
    elif [ "$REMAINDER" -ge 50 ]; then BAR="${BAR}${FILL_COLOR}▒${R}${FG_GRAY}"
    else                               BAR="${BAR}${FILL_COLOR}░${R}${FG_GRAY}"
    fi
  else BAR="${BAR}${FG_GRAY}░${R}"
  fi
done

# ─── Stats & Metadata formatting ─────────────────────────────────────────────
CTX_BAR="${FG_YELLOW}󱍏  ${R}${BAR} ${NUM_COLOR}${PCT_FMT}%${R}"
ART_FMT="${FG_BLUE} ${NUM_COLOR}${ARTIFACTS}${R}"
SUB_FMT="${FG_CYAN}󱙺 ${NUM_COLOR}${SUBAGENTS}${R}"
BG_FMT="${FG_MAGENTA} ${NUM_COLOR}${BG_TASKS}${R}"

DIR_FMT=""
if [ -n "$CWD_SHORT" ]; then
  DIR_FMT="${FG_GRAY}${DOT}${FG_CYAN} ${R}${CWD_SHORT}${R}"
fi

CONV_FMT=""
if [ -n "$CONV_ID" ]; then
  CONV_FMT="${FG_GRAY}${DOT}${FG_GRAY}󰍪 ${CONV_ID:0:8}${R}"
fi

TOK_DETAILS=""
if [ "$CTX_USED" -gt 0 ] 2>/dev/null; then
  TOK_DETAILS=" (${CTX_USED_FMT}/${CTX_LIMIT_FMT})"
fi

# ─── Quota formatting ────────────────────────────────────────────────────────
format_reset_time() {
  local sec=$1
  if [ -z "$sec" ] || [ "$sec" -le 0 ]; then
    echo -n ""
    return
  fi

  local days=$((sec / 86400))
  local rem=$((sec % 86400))
  local hours=$((rem / 3600))
  rem=$((rem % 3600))
  local mins=$((rem / 60))

  if [ "$days" -gt 0 ]; then
    if [ "$hours" -gt 0 ]; then
      echo -n "${days}d ${hours}h"
    else
      echo -n "${days}d"
    fi
  elif [ "$hours" -gt 0 ]; then
    if [ "$mins" -gt 0 ]; then
      echo -n "${hours}h ${mins}m"
    else
      echo -n "${hours}h"
    fi
  elif [ "$mins" -gt 0 ]; then
    echo -n "${mins}m"
  else
    echo -n "<1m"
  fi
}

make_quota_bar() {
  local val=$1
  local label=$2
  local bar_color=$3
  local reset_sec=$4
  if [ -z "$val" ] || [[ "$val" == -* ]]; then
    local bar=""
    for ((i = 0; i < 20; i++)); do
      bar="${bar}░"
    done
    echo -n "${FG_GRAY}| ${R}${FG_BRIGHT_WHITE}${B}${label}${R} ${FG_GRAY}${bar} N/A${R}"
    return
  fi

  local val_int=${val%.*}
  val_int=${val_int:-0}
  
  local text_color="$FG_BRIGHT_GREEN"
  if [ "$val_int" -lt 20 ]; then
    text_color="$FG_BRIGHT_RED"
  elif [ "$val_int" -lt 50 ]; then
    text_color="$FG_BRIGHT_YELLOW"
  fi

  local bar_len=20
  local filled=$((val_int * bar_len / 100))
  local remainder=$(( (val_int * bar_len) % 100 ))
  
  local bar=""
  for ((i = 0; i < bar_len; i++)); do
    if [ "$i" -lt "$filled" ]; then
      bar="${bar}${bar_color}█${R}"
    elif [ "$i" -eq "$filled" ]; then
      if [ "$remainder" -ge 75 ]; then
        bar="${bar}${bar_color}▓${R}${FG_GRAY}"
      elif [ "$remainder" -ge 50 ]; then
        bar="${bar}${bar_color}▒${R}${FG_GRAY}"
      elif [ "$remainder" -ge 25 ]; then
        bar="${bar}${bar_color}░${R}${FG_GRAY}"
      else
        bar="${bar}${FG_GRAY}░${R}"
      fi
    else
      bar="${bar}${FG_GRAY}░${R}"
    fi
  done

  local reset_str=""
  if [ -n "$reset_sec" ] && [ "$reset_sec" -gt 0 ]; then
    reset_str=" ⌛️ $(format_reset_time "$reset_sec")"
  fi

  echo -n "${FG_GRAY}| ${R}${FG_BRIGHT_WHITE}${B}${label}${R} ${bar} ${text_color}${val}%${R}${reset_str}"
}

# Determine active quota
MODEL_LOWER=$(echo "${MODEL_NAME:-$MODEL_ID}" | tr '[:upper:]' '[:lower:]')
if [[ "$MODEL_LOWER" == *gemini* ]]; then
  Q_5H="$GEMINI_5H"
  Q_WK="$GEMINI_WK"
  Q_5H_R="$GEMINI_5H_RESET"
  Q_WK_R="$GEMINI_WK_RESET"
else
  Q_5H="$TP_5H"
  Q_WK="$TP_WK"
  Q_5H_R="$TP_5H_RESET"
  Q_WK_R="$TP_WK_RESET"
fi

QUOTA_FMT=""
if [ -n "$Q_5H" ] || [ -n "$Q_WK" ]; then
  QUOTA_FMT="$(make_quota_bar "$Q_5H" "5H" "$FG_BRIGHT_CYAN" "$Q_5H_R") $(make_quota_bar "$Q_WK" "7D" "$FG_BRIGHT_MAGENTA" "$Q_WK_R")"
fi

# ─── Right-align helper ──────────────────────────────────────────────────────
# Prints LINE1 left-aligned and LINE2 right-aligned on the same terminal row.
print_right_aligned() {
  local left="$1"
  local right="$2"
  local total_cols="$3"

  local left_vis right_vis pad
  left_vis=$(visible_len "$left")
  right_vis=$(visible_len "$right")

  # How many spaces needed between left and right
  pad=$(( total_cols - left_vis - right_vis ))
  [ "$pad" -lt 1 ] && pad=1

  printf "%b%*s%b\n" "$left" "$pad" "" "$right"
}

# ─── Output Assembly ─────────────────────────────────────────────────────────
if [ "$COLS" -ge 180 ]; then
  LINE1="${S}${M}${DIR_FMT}${V}${CONV_FMT}"

  if [ "$CTX_USED" -gt 0 ] 2>/dev/null; then
    TOK_DETAILS=" (${CTX_USED_FMT}/${CTX_LIMIT_FMT})${DOT}${FG_YELLOW} ${R} (${INPUT_TOK_FMT} in/${OUTPUT_TOK_FMT} out)"
  fi

  LINE2="${ART_FMT}${DOT}${SUB_FMT}${DOT}${BG_FMT}${DOT}${SB}${DOT}${CTX_BAR}${TOK_DETAILS}${DOT}${QUOTA_FMT}"
  print_right_aligned "$LINE1" "$LINE2" "$COLS"

elif [ "$COLS" -ge 90 ]; then
  # Medium Layout: Two-line layout with border
  LINE1="${S}${M}${DIR_FMT}${V}"
  LINE2=" ${CTX_BAR}${TOK_DETAILS}${DOT}${ART_FMT}${DOT}${SUB_FMT}${DOT}${BG_FMT}${DOT}${SB}${DOT}${QUOTA_FMT}"

  echo -e "${FG_GRAY}╭─${R}${LINE1}"
  echo -e "${FG_GRAY}╰─${R}${LINE2}"

else
  M_SHORT=""
  if [ -n "$MODEL_DISP" ]; then
    M_SHORT="${FG_GRAY} ╱ ${FG_BRIGHT_MAGENTA}${MODEL_DISP}${R}"
  fi

  echo -e "${S}${M_SHORT}"
  echo -e "${CTX_BAR}${DOT}${BG_FMT}${DOT}${QUOTA_FMT}"
fi
