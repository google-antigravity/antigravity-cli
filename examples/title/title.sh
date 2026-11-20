#!/bin/bash
set -euo pipefail

# Read JSON payload from stdin with a timeout, so a pipe that is held open
# without being written to can't hang the script until the runner kills it.
DATA=""
IFS= read -r -d '' -t 2 DATA || true
exec 0</dev/null
[ -n "$DATA" ] || DATA='{}'

# Extract fields using jq
eval $(echo "$DATA" | jq -r '
  "STATE=\"\(.agent_state // "idle")\"
   CWD=\"\(.workspace.current_dir // "")\"
  "
' 2>/dev/null || echo 'STATE="idle" CWD=""')

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
