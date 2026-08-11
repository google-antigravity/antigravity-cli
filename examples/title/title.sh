#!/bin/bash
set -euo pipefail

# Read JSON payload from stdin
DATA=$(cat)

# Extract fields safely using jq without eval
{
  read -r STATE
  read -r CWD
} <<< "$(
  jq -r '
    (.agent_state // "idle"),
    (.workspace.current_dir // "")
  ' <<< "$DATA" 2>/dev/null || printf "idle\n\n"
)"

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

echo "$TITLE"
