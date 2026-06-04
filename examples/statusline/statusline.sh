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
    (.context_window.remaining_percentage // 100)
  ' 2>/dev/null || printf "idle\n0\n\nfalse\n\n\nfalse\nfalse\n0\n0\n0\n\n\n80\n\n\n\n0\n0\n0\n0\n100\n"
)"

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

# ─── State Indicator (No background colors) ──────────────────────────────────
case "$STATE" in
  idle)     S="${FG_BRIGHT_GREEN}${B}● READY${R}" ;;
  thinking) S="${FG_BRIGHT_YELLOW}${B}◆ THINKING${R}" ;;
  working)  S="${FG_BRIGHT_CYAN}${B}⚙ WORKING${R}" ;;
  tool_use) S="${FG_BRIGHT_MAGENTA}${B}🔧 TOOL${R}" ;;
  *)        S="${FG_WHITE}${B}⏳ $(echo "$STATE" | tr '[:lower:]' '[:upper:]')${R}" ;;
esac

# ─── VCS Branch & Type ───────────────────────────────────────────────────────
# Fallback to local git query if VCS_BRANCH is not provided in the JSON payload
if [ -z "$VCS_BRANCH" ]; then
  GIT_DIR="${CWD:-.}"
  if git -C "$GIT_DIR" rev-parse --is-inside-work-tree &>/dev/null; then
    VCS_BRANCH=$(git -C "$GIT_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
    VCS_TYPE="git"
    if [ -n "$VCS_BRANCH" ]; then
      if git -C "$GIT_DIR" status --porcelain 2>/dev/null | grep -q .; then
        VCS_DIRTY="true"
      else
        VCS_DIRTY="false"
      fi
    fi
  fi
fi

V=""
if [ -n "$VCS_BRANCH" ]; then
  VCS_LABEL="${VCS_TYPE:-git}"
  if [ "$VCS_DIRTY" = "true" ]; then
    V="${FG_GRAY} ╱ ${FG_GRAY}${VCS_LABEL}:${FG_BRIGHT_RED}${VCS_BRANCH}${FG_BRIGHT_YELLOW}*${R}"
  else
    V="${FG_GRAY} ╱ ${FG_GRAY}${VCS_LABEL}:${FG_BRIGHT_BLUE}${VCS_BRANCH}${R}"
  fi
fi

# ─── Model ───────────────────────────────────────────────────────────────────
# Fallback to model ID if display name is empty
MODEL_DISP="${MODEL_NAME:-$MODEL_ID}"
M=""
if [ -n "$MODEL_DISP" ]; then
  M="${FG_GRAY} ╱ ${FG_BRIGHT_MAGENTA}${I}${MODEL_DISP}${R}"
fi

# ─── Sandbox Badge ───────────────────────────────────────────────────────────
if [ "$SANDBOX" = "true" ]; then
  if [ "$SANDBOX_NET" = "true" ]; then
    SB="${FG_GRAY}🛡️ sandbox ${FG_BRIGHT_GREEN}${B}ON (net)${R}"
  else
    SB="${FG_GRAY}🛡️ sandbox ${FG_BRIGHT_GREEN}${B}ON (no-net)${R}"
  fi
else
  SB="${FG_GRAY}🛡️ sandbox off${R}"
fi

# ─── Context Bar (15 segments, fine-grain Unicode) ────────────────────────────
BAR_LEN=15
FILLED=$((PCT_INT * BAR_LEN / 100))
REMAINDER=$(( (PCT_INT * BAR_LEN) % 100 ))

if [ "$PCT_INT" -ge 90 ]; then
  BAR_COLOR="$FG_BRIGHT_RED"
elif [ "$PCT_INT" -ge 60 ]; then
  BAR_COLOR="$FG_BRIGHT_YELLOW"
else
  BAR_COLOR="$FG_BRIGHT_WHITE"
fi

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

# ─── Stats & Metadata formatting ─────────────────────────────────────────────
CTX_BAR="${FG_GRAY}ctx ${BAR_COLOR}${BAR} ${NUM_COLOR}${PCT_FMT}%${R}"
ART_FMT="${FG_GRAY}📦 ${NUM_COLOR}${ARTIFACTS}${R}"
SUB_FMT="${FG_GRAY}🤖 ${NUM_COLOR}${SUBAGENTS}${R}"
BG_FMT="${FG_GRAY}⏳ ${NUM_COLOR}${BG_TASKS}${R}"

# ─── New elements (CWD, Conversation ID, Token counts) ──────────────────────
DIR_FMT=""
if [ -n "$CWD_SHORT" ]; then
  DIR_FMT="${FG_GRAY} ╱ 📂 ${CWD_SHORT}${R}"
fi

CONV_FMT=""
if [ -n "$CONV_ID" ]; then
  CONV_FMT="${FG_GRAY} ╱ id:${CONV_ID:0:8}${R}"
fi

# Token stats detailed vs simple
TOK_DETAILS=""
if [ "$CTX_USED" -gt 0 ] 2>/dev/null; then
  TOK_DETAILS=" (${CTX_USED_FMT}/${CTX_LIMIT_FMT})"
fi

# ─── Separators ──────────────────────────────────────────────────────────────
DOT="${FG_GRAY} · ${R}"

# ─── Output Assembly ──────────────────────────────────────────────────────────
if [ "$COLS" -ge 120 ]; then
  # Wide Layout: One line containing state, model, vcs, directory, conversation id
  # and bottom bar metrics inline.
  LINE1="${S}${M}${V}${DIR_FMT}${CONV_FMT}"
  
  # Detailed tokens in wide layout: (used/limit · in/out)
  if [ "$CTX_USED" -gt 0 ] 2>/dev/null; then
    TOK_DETAILS=" (${CTX_USED_FMT}/${CTX_LIMIT_FMT} · ${INPUT_TOK_FMT} in/${OUTPUT_TOK_FMT} out)"
  fi
  
  LINE2=" ${CTX_BAR}${TOK_DETAILS}${DOT}${ART_FMT}${DOT}${SUB_FMT}${DOT}${BG_FMT}${DOT}${SB}"
  echo -e "${LINE1}${FG_GRAY}  │  ${R}${LINE2}"

elif [ "$COLS" -ge 80 ]; then
  # Medium Layout: Two-line layout with border
  LINE1="${S}${M}${V}${DIR_FMT}"
  LINE2=" ${CTX_BAR}${TOK_DETAILS}${DOT}${ART_FMT}${DOT}${SUB_FMT}${DOT}${BG_FMT}${DOT}${SB}"
  
  echo -e "${FG_GRAY}╭─${R} ${LINE1}"
  echo -e "${FG_GRAY}╰─${R}${LINE2}"

else
  # Narrow Layout: Compact two-line, minimal layout
  # Shorten model display for narrow screens
  M_SHORT=""
  if [ -n "$MODEL_DISP" ]; then
    M_SHORT="${FG_GRAY} ╱ ${FG_BRIGHT_MAGENTA}${MODEL_DISP:0:12}${R}"
  fi
  
  echo -e "${S}${M_SHORT}"
  echo -e "${CTX_BAR}${DOT}${BG_FMT}"
fi
