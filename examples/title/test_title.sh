#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
TITLE_SCRIPT="$SCRIPT_DIR/title.sh"

if ! command -v jq >/dev/null 2>&1; then
  printf 'error: jq is required to run title.sh tests\n' >&2
  exit 1
fi

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

assert_equal() {
  local expected="$1"
  local actual="$2"
  local description="$3"

  if [[ "$actual" != "$expected" ]]; then
    printf 'not ok - %s\nexpected: %s\nactual:   %s\n' "$description" "$expected" "$actual" >&2
    exit 1
  fi

  printf 'ok - %s\n' "$description"
}

make_payload() {
  jq -cn --arg state "$1" --arg cwd "$2" \
    '{agent_state: $state, workspace: {current_dir: $cwd}}'
}

# Preserve the existing title format for ordinary input.
payload=$(make_payload "idle" "$TMP_DIR/workspace")
actual=$(printf '%s\n' "$payload" | bash "$TITLE_SCRIPT")
assert_equal "😴 idle | workspace" "$actual" "formats a normal workspace title"

# A workspace path is data, not shell code.
marker="$TMP_DIR/path-command-ran"
malicious_path='$(touch "'"$marker"'")'
payload=$(make_payload "idle" "$malicious_path")
actual=$(printf '%s\n' "$payload" | bash "$TITLE_SCRIPT")
expected="😴 idle | $(basename "$malicious_path")"
assert_equal "$expected" "$actual" "preserves shell metacharacters in workspace paths"
if [[ -e "$marker" ]]; then
  printf 'not ok - workspace path executed a shell command\n' >&2
  exit 1
fi
printf 'ok - workspace path cannot execute shell commands\n'

# The agent state field must also remain plain text.
state_marker="$TMP_DIR/state-command-ran"
malicious_state='$(touch "'"$state_marker"'")'
payload=$(make_payload "$malicious_state" "$TMP_DIR/workspace")
actual=$(printf '%s\n' "$payload" | bash "$TITLE_SCRIPT")
expected="🤖 $malicious_state | workspace"
assert_equal "$expected" "$actual" "preserves shell metacharacters in agent state"
if [[ -e "$state_marker" ]]; then
  printf 'not ok - agent state executed a shell command\n' >&2
  exit 1
fi
printf 'ok - agent state cannot execute shell commands\n'

# Invalid JSON keeps the script's documented fallback behavior.
actual=$(printf '%s\n' '{invalid json' | bash "$TITLE_SCRIPT")
assert_equal "😴 idle | unknown" "$actual" "falls back safely for invalid JSON"
