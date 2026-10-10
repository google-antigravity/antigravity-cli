#!/bin/bash
set -euo pipefail

# Read JSON payload from stdin
DATA=$(cat)

# Extract fields using jq
eval $(echo "$DATA" | jq -r '
  "STATE=\"\(.agent_state // "idle")\"
   CWD=\"\(.workspace.current_dir // "")\"
   CONV_TITLE=\"\(.conversation_title // .conversation_name // "")\"
  "
' 2>/dev/null || echo 'STATE="idle" CWD="" CONV_TITLE=""')

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

if [ -n "$CONV_TITLE" ]; then
  TITLE="$EMOJI $STATE | $WORKSPACE ($CONV_TITLE)"
else
  TITLE="$EMOJI $STATE | $WORKSPACE"
fi

echo "$TITLE"
