#!/usr/bin/fish

# Read JSON payload from stdin
set -l DATA (cat)

if not type -q jq
    echo "idle | unknown"
    exit 0
end

set -l STATE (echo $DATA | jq -r '.agent_state // "idle"')
set -l CWD (echo $DATA | jq -r '.workspace.current_dir // .cwd // ""')

set -l WORKSPACE "unknown"
if test -n "$CWD"
    if string match -r '/google/src/cloud/[^/]+/([^/]+)' $CWD >/dev/null
        set WORKSPACE (string replace -r '.*/google/src/cloud/[^/]+/([^/]+).*' '$1' $CWD)
    else
        set WORKSPACE (basename $CWD)
    end
end

set -l EMOJI "🤖"
switch $STATE
    case initializing
        set EMOJI "🚀"
    case idle
        set EMOJI "😴"
    case thinking
        set EMOJI "🤔"
    case working
        set EMOJI "🏃"
    case tool_use
        set EMOJI "🛠️"
end

echo "$EMOJI $STATE | $WORKSPACE"
