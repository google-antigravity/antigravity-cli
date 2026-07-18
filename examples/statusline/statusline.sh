#!/bin/bash
set -euo pipefail

# Detect color scheme from user settings to adapt foreground colors
THEME=$(jq -r '.colorScheme // "terminal"' ~/.gemini/antigravity-cli/settings.json 2>/dev/null || echo "terminal")

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

# Adapt to terminal colors and opacity using native ANSI attributes instead of hardcoded grays/whites
FG_GRAY="${D}"       # Dim matches terminal text opacity and color
FG_BRIGHT_RED="\033[91m"
FG_BRIGHT_GREEN="\033[92m"
FG_BRIGHT_YELLOW="\033[93m"
FG_BRIGHT_BLUE="\033[94m"
FG_BRIGHT_MAGENTA="\033[95m"
FG_BRIGHT_CYAN="\033[96m"
FG_BRIGHT_WHITE="${B}" # Bold matches terminal text opacity and color

# Number Highlight Color
NUM_COLOR="${B}"     # Natively inherits terminal foreground color (with opacity) and makes it bold

# ─── Theme Adaptations ───────────────────────────────────────────────────────
case "$THEME" in
  *light* | *Light*)
    # Map bright accents to their standard darker counterparts for contrast on light backgrounds
    FG_BRIGHT_RED="\033[31m"      # Standard Red
    FG_BRIGHT_GREEN="\033[32m"    # Standard Green
    FG_BRIGHT_YELLOW="\033[33m"   # Standard Yellow/Brown
    FG_BRIGHT_BLUE="\033[34m"     # Standard Blue
    FG_BRIGHT_MAGENTA="\033[35m"  # Standard Magenta
    FG_BRIGHT_CYAN="\033[36m"     # Standard Cyan
    ;;
esac

# ─── Token Formatter Helper ──────────────────────────────────────────────────
# Fast, pure Bash number formatter to prevent subprocess spawning overhead.
format_tokens() {
  local val=$1
  if [ "$val" -lt 1000 ]; then
    echo "${val}"
  elif [ "$val" -lt 1000000 ]; then
    local k=$((val / 1000))
    local r=$(((val % 1000) / 100))
    echo "${k}.${r}k"
  else
    local m=$((val / 1000000))
    local r=$(((val % 1000000) / 100000))
    echo "${m}.${r}M"
  fi
}

# ─── Read Stdin Safely ───────────────────────────────────────────────────────
# Read entire stdin to check if it's empty, avoiding EOF errors on subsequent reads.
INPUT=$(cat)

# ─── Parse JSON from stdin (Single jq pass for performance) ──────────────────
# Extract all fields in one pass to prevent spawning jq multiple times.
# Uses a dummy "__END__" line to prevent Bash command substitution from stripping trailing newlines.
{
  read -r STATE
  read -r USED_PCT
  read -r VCS_BRANCH
  read -r VCS_DIRTY
  read -r SANDBOX
  read -r ARTIFACTS
  read -r SUBAGENTS
  read -r BG_TASKS
  read -r MODEL
  read -r COLS
  read -r TOTAL_IN_TOKENS
  read -r TOTAL_OUT_TOKENS
  read -r LIMIT_TOKENS
  read -r QUOTA_INFO
  read -r _ # Dummy read for "__END__"
} <<< "$(
  printf "%s\n" "${INPUT:-{}}" | jq -r '
    (.agent_state // "idle"),
    (.context_window.used_percentage // 0),
    (.vcs.branch // ""),
    (.vcs.dirty // false),
    (.sandbox.enabled // false),
    (.artifact_count // 0),
    (if .subagents | type == "array" then (.subagents | length) else 0 end),
    (.task_count // 0),
    (.model.display_name // ""),
    (.terminal_width // 80),
    (.context_window.total_input_tokens // 0),
    (.context_window.total_output_tokens // 0),
    (.context_window.context_window_size // 0),
    (if .quota then (if .model.display_name | ascii_downcase | contains("gemini") then "gemini:\(.quota["gemini-5h"].remaining_fraction // "null"):\(.quota["gemini-5h"].reset_in_seconds // "null"):\(.quota["gemini-weekly"].remaining_fraction // "null"):\(.quota["gemini-weekly"].reset_in_seconds // "null")" else "3p:\(.quota["3p-5h"].remaining_fraction // "null"):\(.quota["3p-5h"].reset_in_seconds // "null"):\(.quota["3p-weekly"].remaining_fraction // "null"):\(.quota["3p-weekly"].reset_in_seconds // "null")" end) else "" end),
    "__END__"
  ' 2>/dev/null || printf "idle\n0\n\nfalse\nfalse\n0\n0\n0\n\n80\n0\n0\n0\n\n__END__\n"
)"

# ─── Computed Values ─────────────────────────────────────────────────────────
# Use LC_NUMERIC=C to prevent bash printf errors in locales that use commas for decimals
PCT_FMT=$(LC_NUMERIC=C printf "%.1f" "$USED_PCT")
PCT_INT=${USED_PCT%.*}; PCT_INT=${PCT_INT:-0}

# Total token count calculation
TOTAL_TOKENS=$((TOTAL_IN_TOKENS + TOTAL_OUT_TOKENS))
TOKENS_FMT=$(format_tokens "$TOTAL_TOKENS")
LIMIT_FMT=$(format_tokens "$LIMIT_TOKENS")

# Quota processing
QUOTA_NAME=""
QUOTA_PCT=""
QUOTA_FMT=""
QUOTA_FMT_COMPACT=""

if [ -n "$QUOTA_INFO" ] && [ "$QUOTA_INFO" != "null" ]; then
  # Split by colon: PREFIX:5H_FRAC:5H_RESET:WK_FRAC:WK_RESET
  QUOTA_PREFIX="${QUOTA_INFO%%:*}"
  rest="${QUOTA_INFO#*:}"
  
  QUOTA_5H_FRAC="${rest%%:*}"
  rest2="${rest#*:}"
  
  QUOTA_5H_RESET="${rest2%%:*}"
  rest3="${rest2#*:}"
  
  QUOTA_WK_FRAC="${rest3%%:*}"
  QUOTA_WK_RESET="${rest3#*:}"
  
  frac_to_pct() {
    local frac=$1
    if [ -z "$frac" ] || [ "$frac" = "null" ]; then
      echo ""
      return
    fi
    if [ "$frac" = "1" ] || [ "$frac" = "1.0" ]; then
      echo "100"
      return
    fi
    local clean="${frac#0.}"
    if [ -z "$clean" ] || [ "$clean" = "0" ]; then
      echo "0"
      return
    fi
    while [ ${#clean} -lt 2 ]; do
      clean="${clean}0"
    done
    local pct="${clean:0:2}"
    pct="${pct#0}"
    echo "${pct:-0}"
  }
  
  format_duration() {
    local sec=$1
    if [ -z "$sec" ] || [ "$sec" = "null" ] || [ "$sec" -le 0 ]; then
      echo ""
      return
    fi
    if [ "$sec" -lt 60 ]; then
      echo "${sec}s"
    elif [ "$sec" -lt 3600 ]; then
      local m=$((sec / 60))
      echo "${m}m"
    elif [ "$sec" -lt 86400 ]; then
      local h=$((sec / 3600))
      local m=$(((sec % 3600) / 60))
      echo "${h}h ${m}m"
    else
      local d=$((sec / 86400))
      local h=$(((sec % 86400) / 3600))
      echo "${d}d ${h}h"
    fi
  }
  
  QUOTA_5H_PCT=$(frac_to_pct "$QUOTA_5H_FRAC")
  QUOTA_WK_PCT=$(frac_to_pct "$QUOTA_WK_FRAC")
  
  QUOTA_5H_RESET_FMT=$(format_duration "$QUOTA_5H_RESET")
  QUOTA_WK_RESET_FMT=$(format_duration "$QUOTA_WK_RESET")
  
  if [ -n "$QUOTA_5H_PCT" ] || [ -n "$QUOTA_WK_PCT" ]; then
    label="gemini"
    [ "$QUOTA_PREFIX" = "3p" ] && label="3p"
    
    # 5h formatting
    f5h=""
    if [ -n "$QUOTA_5H_PCT" ]; then
      if [ "$QUOTA_5H_PCT" -lt 20 ]; then
        f5h="${FG_BRIGHT_RED}${B}${QUOTA_5H_PCT}%${R}"
      elif [ "$QUOTA_5H_PCT" -lt 50 ]; then
        f5h="${FG_BRIGHT_YELLOW}${QUOTA_5H_PCT}%${R}"
      else
        f5h="${NUM_COLOR}${QUOTA_5H_PCT}%${R}"
      fi
      if [ -n "$QUOTA_5H_RESET_FMT" ]; then
        f5h="${f5h} ${FG_GRAY}(${QUOTA_5H_RESET_FMT})${R}"
      fi
    else
      f5h="--"
    fi
    
    # Weekly formatting
    fwk=""
    if [ -n "$QUOTA_WK_PCT" ]; then
      if [ "$QUOTA_WK_PCT" -lt 20 ]; then
        fwk="${FG_BRIGHT_RED}${B}${QUOTA_WK_PCT}%${R}"
      elif [ "$QUOTA_WK_PCT" -lt 50 ]; then
        fwk="${FG_BRIGHT_YELLOW}${QUOTA_WK_PCT}%${R}"
      else
        fwk="${NUM_COLOR}${QUOTA_WK_PCT}%${R}"
      fi
      if [ -n "$QUOTA_WK_RESET_FMT" ]; then
        fwk="${fwk} ${FG_GRAY}(${QUOTA_WK_RESET_FMT})${R}"
      fi
    else
      fwk="--"
    fi
    
    # Determine icon color from minimum active quota
    min_pct=100
    if [ -n "$QUOTA_5H_PCT" ] && [ "$QUOTA_5H_PCT" -lt "$min_pct" ]; then
      min_pct="$QUOTA_5H_PCT"
    fi
    if [ -n "$QUOTA_WK_PCT" ] && [ "$QUOTA_WK_PCT" -lt "$min_pct" ]; then
      min_pct="$QUOTA_WK_PCT"
    fi
    
    icon_color="$FG_GRAY"
    if [ "$min_pct" -lt 20 ]; then
      icon_color="${FG_BRIGHT_RED}${B}"
    elif [ "$min_pct" -lt 50 ]; then
      icon_color="${FG_BRIGHT_YELLOW}"
    fi
    
    # Standard format: ⚡ 5h: 53% (3h 45m) ╱ w: 23% (1d 17h)
    QUOTA_FMT="${icon_color}⚡ ${R}${FG_GRAY}5h: ${R}${f5h}${FG_GRAY} ╱ w: ${R}${fwk}"
    # Compact format: ⚡ 53%/23%
    QUOTA_FMT_COMPACT="${icon_color}⚡ ${R}${NUM_COLOR}${QUOTA_5H_PCT:-0}%${R}${FG_GRAY}/${R}${NUM_COLOR}${QUOTA_WK_PCT:-0}%${R}"
  fi
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
    V="${FG_GRAY} ╱ ${FG_BRIGHT_RED}🌱 ${VCS_BRANCH}${FG_BRIGHT_YELLOW}*${R}"
  else
    V="${FG_GRAY} ╱ ${FG_BRIGHT_BLUE}🌱 ${VCS_BRANCH}${R}"
  fi
fi

# ─── Model ───────────────────────────────────────────────────────────────────
M=""
if [ -n "$MODEL" ]; then
  M="${FG_GRAY} ╱ ${FG_BRIGHT_MAGENTA}${I}${MODEL}${R}"
fi

# ─── Sandbox Badge ───────────────────────────────────────────────────────────
if [ "$SANDBOX" = "true" ]; then
  SB="${FG_BRIGHT_GREEN}${B}🛡️  ON${R}"
else
  SB="${FG_GRAY}🛡️  off${R}"
fi

# ─── Context Bar (10 segments, fine-grain Unicode) ────────────────────────────
BAR_LEN=10
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
CTX="${FG_GRAY}ctx ${BAR_COLOR}${BAR}${R} ${NUM_COLOR}${TOKENS_FMT}/${LIMIT_FMT}${R} ${FG_GRAY}(${PCT_FMT}%)${R}"
ART_FMT="${FG_GRAY}📦 ${NUM_COLOR}${ARTIFACTS}${R}"
SUB_FMT="${FG_GRAY}👥 ${NUM_COLOR}${SUBAGENTS}${R}"
BG_FMT="${FG_GRAY}⚙️ ${NUM_COLOR}${BG_TASKS}${R}"

# ─── Separators ──────────────────────────────────────────────────────────────
DOT="${FG_GRAY} · ${R}"

# ─── Output ──────────────────────────────────────────────────────────────────
LINE1="${S}${M}${V}"

# Construct Line 2 dynamically
LINE2=" ${CTX}${DOT}${ART_FMT}${DOT}${SUB_FMT}${DOT}${BG_FMT}"
if [ -n "$QUOTA_FMT" ]; then
  LINE2="${LINE2}${DOT}${QUOTA_FMT}"
fi
LINE2="${LINE2}${DOT}${SB}"

if [ "$COLS" -ge 120 ]; then
  # Wide: single line
  echo -e "${LINE1}${FG_GRAY}  │ ${R}${LINE2}"
elif [ "$COLS" -ge 80 ]; then
  # Medium: two-line layout with border
  echo -e "${FG_GRAY}╭─${R} ${LINE1}"
  echo -e "${FG_GRAY}╰─${R}${LINE2}"
else
  # Narrow: compact two-line, minimal chrome
  # Line 1: State + Branch
  if [ -n "$VCS_BRANCH" ]; then
    if [ "$VCS_DIRTY" = "true" ]; then
      V_COMPACT="${FG_GRAY} ╱ ${FG_BRIGHT_RED}🌱 ${VCS_BRANCH}${FG_BRIGHT_YELLOW}*${R}"
    else
      V_COMPACT="${FG_GRAY} ╱ ${FG_BRIGHT_BLUE}🌱 ${VCS_BRANCH}${R}"
    fi
  else
    V_COMPACT=""
  fi
  echo -e "${S}${V_COMPACT}"
  
  # Line 2: Context pct + compact resource indicators
  COMPACT_STATS="${FG_GRAY}ctx ${NUM_COLOR}${PCT_FMT}%${R}${DOT}${ART_FMT}${DOT}${BG_FMT}"
  if [ -n "$QUOTA_FMT_COMPACT" ]; then
    COMPACT_STATS="${COMPACT_STATS}${DOT}${QUOTA_FMT_COMPACT}"
  fi
  echo -e "${COMPACT_STATS}"
fi
