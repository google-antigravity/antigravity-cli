# ─── Read JSON from stdin ────────────────────────────────────────────────────
param(
    [Parameter(ValueFromPipeline)]
    [string]$inputJson
)

if ([string]::IsNullOrWhiteSpace($inputJson)) {
    # Try reading from Console stdin (for redirected stdin from Go/agy.exe)
    $inputJson = [Console]::In.ReadToEnd()
}

if ([string]::IsNullOrWhiteSpace($inputJson)) {
    $inputJson = '{}'
}

try {
    $data = ConvertFrom-Json $inputJson -ErrorAction Stop
} catch {
    Write-Output "🤖 ERROR: Invalid JSON ($($_.Exception.Message))"
    exit
}

if ($null -eq $data) {
    $data = [PSCustomObject]@{}
}

$state = if ($data.agent_state) { $data.agent_state } else { "idle" }
$cwd = if ($data.workspace -and $data.workspace.current_dir) { $data.workspace.current_dir } elseif ($data.cwd) { $data.cwd } else { "" }

$workspace = "unknown"
if (-not [string]::IsNullOrEmpty($cwd)) {
    if ($cwd -match '/google/src/cloud/[^/]+/([^/]+)') {
        $workspace = $Matches[1]
    } else {
        $workspace = Split-Path $cwd -Leaf
    }
}

# Map state to emoji
switch ($state) {
    "initializing" { $emoji = "🚀" }
    "idle"         { $emoji = "😴" }
    "thinking"     { $emoji = "🤔" }
    "working"      { $emoji = "🏃" }
    "tool_use"     { $emoji = "🛠️" }
    Default        { $emoji = "🤖" }
}

Write-Output "${emoji} ${state} | ${workspace}"
