#!/bin/bash
# Stop hook: when a turn ends on "Individual quota reached ... Resets in 2h11m50s",
# wait until the quota window resets, then tell the agent to continue.
# Any other stop (normal finish, other errors, resets longer than the max wait)
# is allowed through immediately.
set -euo pipefail

MAX_WAIT=${AGY_AUTO_CONTINUE_MAX_WAIT:-18000} # seconds; default covers the 5-hour window
BUFFER=30                                     # seconds past the reported reset

allow_stop() {
  printf '{"decision":"stop"}\n'
  exit 0
}

input=$(cat)
reason=$(printf '%s' "$input" | jq -r '.terminationReason // ""')
error=$(printf '%s' "$input" | jq -r '.error // ""')

case "$reason" in ERROR | error) ;; *) allow_stop ;; esac
case "$error" in *"quota reached"*) ;; *) allow_stop ;; esac

# Go duration as printed by the CLI: 2h11m50s, 11m50s, 50s, 1h0m0.5s
re='Resets in (([0-9]+)h)?(([0-9]+)m)?(([0-9]+)(\.[0-9]+)?s)?'
[[ $error =~ $re ]] || allow_stop
secs=$((10#${BASH_REMATCH[2]:-0} * 3600 + 10#${BASH_REMATCH[4]:-0} * 60 + 10#${BASH_REMATCH[6]:-0}))
((secs > 0 && secs <= MAX_WAIT)) || allow_stop

# Poll the wall clock instead of one long sleep, so a laptop sleeping
# through the reset still resumes on time.
deadline=$(($(date +%s) + secs + BUFFER))
echo "auto-continue: quota reached, resuming at $(date -r "$deadline" +%H:%M 2>/dev/null || date -d "@$deadline" +%H:%M)" >&2
while (($(date +%s) < deadline)); do sleep 15; done

printf '{"decision":"continue","reason":"Your usage quota has reset. Continue the task you were working on from where you left off."}\n'
