#!/bin/bash
set -euo pipefail

# Read JSON payload from stdin
if [ -t 0 ]; then
  DATA="{}"
else
  DATA=$(cat)
fi

# Extract fields using jq
eval $(echo "$DATA" | jq -r '
  "STATE=\"\(.agent_state // "idle")\"
   CWD=\"\(.cwd // .workspace.current_dir // "")\"
  "
' 2>/dev/null || echo 'STATE="idle" CWD=""')

# Try to extract CitC workspace name or directory from CWD
if [ -z "$CWD" ]; then
  CWD="$(pwd)"
fi

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
