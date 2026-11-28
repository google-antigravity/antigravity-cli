#!/bin/bash
set -euo pipefail

# Read JSON payload from stdin
DATA=$(cat)

# Extract fields without evaluating JSON-derived shell code. Workspace paths can
# contain shell metacharacters, so they must remain plain data.
STATE=$(jq -r '(.agent_state | strings) // "idle"' <<< "$DATA" 2>/dev/null) || STATE="idle"
CWD=$(jq -r '(.workspace.current_dir | strings) // ""' <<< "$DATA" 2>/dev/null) || CWD=""

# Try to extract CitC workspace name from CWD
if [ -n "$CWD" ]; then
  if [[ "$CWD" =~ /google/src/cloud/[^/]+/([^/]+) ]]; then
    WORKSPACE="${BASH_REMATCH[1]}"
  else
    WORKSPACE=$(basename "$CWD")
  fi
else
  WORKSPACE="unknown"
fi

# Map state to emoji
case "$STATE" in
  initializing) EMOJI="🚀" ;;
  idle)         EMOJI="😴" ;;
  thinking)     EMOJI="🤔" ;;
  working)      EMOJI="🏃" ;;
  tool_use)     EMOJI="🛠️" ;;
  *)            EMOJI="🤖" ;;
esac

TITLE="$EMOJI $STATE | $WORKSPACE"

printf '%s\n' "$TITLE"
