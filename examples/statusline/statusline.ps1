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
    # -ErrorAction Stop is needed so catch block is triggered on invalid JSON
    $data = ConvertFrom-Json $inputJson -ErrorAction Stop
} catch {
    # Output the JSON parsing error in red to make debugging copy-pasted blocks easy
    Write-Output "$([char]0x1b)[31m● ERROR: Invalid JSON input to statusline.ps1 ($($_.Exception.Message))$([char]0x1b)[0m"
    exit
}

if ($null -eq $data) {
    $data = [PSCustomObject]@{}
}

# ─── ANSI Helpers (Standard 16-color palette only) ───────────────────────────
$R = "$([char]0x1b)[0m"         # Reset
$B = "$([char]0x1b)[1m"         # Bold
$D = "$([char]0x1b)[2m"         # Dim
$I = "$([char]0x1b)[3m"         # Italic

# Foreground accents (Standard 16 colors)
$FG_BLACK = "$([char]0x1b)[30m"
$FG_RED = "$([char]0x1b)[31m"
$FG_GREEN = "$([char]0x1b)[32m"
$FG_YELLOW = "$([char]0x1b)[33m"
$FG_BLUE = "$([char]0x1b)[34m"
$FG_MAGENTA = "$([char]0x1b)[35m"
$FG_CYAN = "$([char]0x1b)[36m"
$FG_WHITE = "$([char]0x1b)[37m"

$FG_GRAY = "$([char]0x1b)[90m"
$FG_BRIGHT_RED = "$([char]0x1b)[91m"
$FG_BRIGHT_GREEN = "$([char]0x1b)[92m"
$FG_BRIGHT_YELLOW = "$([char]0x1b)[93m"
$FG_BRIGHT_BLUE = "$([char]0x1b)[94m"
$FG_BRIGHT_MAGENTA = "$([char]0x1b)[95m"
$FG_BRIGHT_CYAN = "$([char]0x1b)[96m"
$FG_BRIGHT_WHITE = "$([char]0x1b)[97m"

$NUM_COLOR = "${FG_BRIGHT_WHITE}${B}"

# ─── Extract fields with fallback ────────────────────────────────────────────
$state = if ($data.agent_state) { $data.agent_state } else { "idle" }
$usedPct = if ($data.context_window -and $null -ne $data.context_window.used_percentage) { [double]$data.context_window.used_percentage } else { 0.0 }
$vcsBranch = if ($data.vcs -and $data.vcs.branch) { $data.vcs.branch } else { "" }
$vcsDirty = if ($data.vcs -and $null -ne $data.vcs.dirty) { $data.vcs.dirty } else { $false }
$vcsType = if ($data.vcs -and $data.vcs.type) { $data.vcs.type } else { "" }
$sandboxEnabled = if ($data.sandbox -and $null -ne $data.sandbox.enabled) { $data.sandbox.enabled } else { $false }
$sandboxNet = if ($data.sandbox -and $null -ne $data.sandbox.allow_network) { $data.sandbox.allow_network } else { $false }
$artifactCount = if ($data.artifact_count) { $data.artifact_count } else { 0 }
$subagentsCount = if ($data.subagents) { @($data.subagents).Count } else { 0 }
$taskCount = if ($data.task_count) { $data.task_count } else { 0 }
$modelId = if ($data.model -and $data.model.id) { $data.model.id } else { "" }
$modelName = if ($data.model -and $data.model.display_name) { $data.model.display_name } else { "" }
$cols = if ($data.terminal_width) { [int]$data.terminal_width } else { 80 }
$cwd = if ($data.cwd) { $data.cwd } else { "" }
$convId = if ($data.conversation_id) { $data.conversation_id } else { "" }
$inputTokens = if ($data.context_window -and $null -ne $data.context_window.total_input_tokens) { $data.context_window.total_input_tokens } else { 0 }
$outputTokens = if ($data.context_window -and $null -ne $data.context_window.total_output_tokens) { $data.context_window.total_output_tokens } else { 0 }
$ctxLimit = if ($data.context_window -and $null -ne $data.context_window.context_window_size) { $data.context_window.context_window_size } else { 0 }
$ctxUsed = $inputTokens + $outputTokens

# ─── Helper Functions ────────────────────────────────────────────────────────
function Get-HumanFormat {
    param ($num)
    if ($null -eq $num -or $num -eq 0) { return "0" }
    if ($num -ge 1000000) {
        $main = [Math]::Floor($num / 1000000)
        $dec = [Math]::Floor(($num % 1000000) / 100000)
        return "${main}.${dec}M"
    }
    if ($num -ge 1000) {
        $main = [Math]::Floor($num / 1000)
        $dec = [Math]::Floor(($num % 1000) / 100)
        return "${main}.${dec}K"
    }
    return "$num"
}

function Get-ShortenPath {
    param ($path)
    if ([string]::IsNullOrEmpty($path)) { return "" }
    $homePath = $env:USERPROFILE
    if (-not $homePath) {
        $homePath = $env:HOME
    }
    if ($homePath -and $path.StartsWith($homePath)) {
        $path = "~" + $path.Substring($homePath.Length)
    }
    if ($path.Length -gt 25) {
        $leaf = Split-Path $path -Leaf
        return "...$leaf"
    }
    return $path
}

$cwdShort = Get-ShortenPath $cwd

# ─── State Indicator ──────────────────────────────────────────────────────────
switch ($state) {
    "idle"     { $S = "${FG_BRIGHT_GREEN}${B}● READY${R}" }
    "thinking" { $S = "${FG_BRIGHT_YELLOW}${B}◆ THINKING${R}" }
    "working"  { $S = "${FG_BRIGHT_CYAN}${B}⚙ WORKING${R}" }
    "tool_use" { $S = "${FG_BRIGHT_MAGENTA}${B}🔧 TOOL${R}" }
    Default    { $S = "${FG_WHITE}${B}⏳ $($state.ToUpper())${R}" }
}

# ─── VCS Branch & Type ───────────────────────────────────────────────────────
# Fallback to local git query if VCS_BRANCH is not provided in the JSON payload
if ([string]::IsNullOrEmpty($vcsBranch)) {
    $gitDir = if (-not [string]::IsNullOrEmpty($cwd)) { $cwd } else { "." }
    # Run git commands and capture output safely
    $isWorkTree = git -C $gitDir rev-parse --is-inside-work-tree 2>$null
    if ($isWorkTree -eq "true") {
        $branch = (git -C $gitDir rev-parse --abbrev-ref HEAD 2>$null).Trim()
        if (-not [string]::IsNullOrEmpty($branch)) {
            $vcsBranch = $branch
            $vcsType = "git"
            $status = (git -C $gitDir status --porcelain 2>$null).Trim()
            $vcsDirty = if (-not [string]::IsNullOrEmpty($status)) { "true" } else { "false" }
        }
    }
}

$V = ""
if (-not [string]::IsNullOrEmpty($vcsBranch)) {
    $vcsLabel = if (-not [string]::IsNullOrEmpty($vcsType)) { $vcsType } else { "git" }
    if ($vcsDirty -eq $true -or $vcsDirty -eq "true") {
        $V = "${FG_GRAY} ╱ ${FG_GRAY}${vcsLabel}:${FG_BRIGHT_RED}${vcsBranch}${FG_BRIGHT_YELLOW}*${R}"
    } else {
        $V = "${FG_GRAY} ╱ ${FG_GRAY}${vcsLabel}:${FG_BRIGHT_BLUE}${vcsBranch}${R}"
    }
}

# ─── Model ───────────────────────────────────────────────────────────────────
$modelDisp = if (-not [string]::IsNullOrEmpty($modelName)) { $modelName } else { $modelId }
$M = ""
if (-not [string]::IsNullOrEmpty($modelDisp)) {
    $M = "${FG_GRAY} ╱ ${FG_BRIGHT_MAGENTA}${I}${modelDisp}${R}"
}

# ─── Sandbox Badge ───────────────────────────────────────────────────────────
if ($sandboxEnabled -eq $true -or $sandboxEnabled -eq "true") {
    if ($sandboxNet -eq $true -or $sandboxNet -eq "true") {
        $SB = "${FG_GRAY}🛡️ sandbox ${FG_BRIGHT_GREEN}${B}ON (net)${R}"
    } else {
        $SB = "${FG_GRAY}🛡️ sandbox ${FG_BRIGHT_GREEN}${B}ON (no-net)${R}"
    }
} else {
    $SB = "${FG_GRAY}🛡️ sandbox off${R}"
}

# ─── Context Bar ─────────────────────────────────────────────────────────────
$BAR_LEN = 15
$pctInt = [int][Math]::Floor($usedPct)
$filled = [int][Math]::Floor($pctInt * $BAR_LEN / 100)
$remainder = ($pctInt * $BAR_LEN) % 100

$barColor = $FG_BRIGHT_WHITE
if ($pctInt -ge 90) {
    $barColor = $FG_BRIGHT_RED
} elseif ($pctInt -ge 60) {
    $barColor = $FG_BRIGHT_YELLOW
}

$BAR = ""
for ($i = 0; $i -lt $BAR_LEN; $i++) {
    if ($i -lt $filled) {
        $BAR += "█"
    } elseif ($i -eq $filled) {
        if ($remainder -ge 75) {
            $BAR += "▓"
        } elseif ($remainder -ge 50) {
            $BAR += "▒"
        } elseif ($remainder -ge 25) {
            $BAR += "░"
        } else {
            $BAR += "·"
        }
    } else {
        $BAR += "·"
    }
}

# ─── Stats Formatting ────────────────────────────────────────────────────────
$pctFmt = $usedPct.ToString("0.0", [System.Globalization.CultureInfo]::InvariantCulture)
$CTX_BAR = "${FG_GRAY}ctx ${barColor}${BAR} ${NUM_COLOR}${pctFmt}%${R}"
$ART_FMT = "${FG_GRAY}📦 ${NUM_COLOR}${artifactCount}${R}"
$SUB_FMT = "${FG_GRAY}🤖 ${NUM_COLOR}${subagentsCount}${R}"
$BG_FMT = "${FG_GRAY}⏳ ${NUM_COLOR}${taskCount}${R}"

$DIR_FMT = ""
if (-not [string]::IsNullOrEmpty($cwdShort)) {
    $DIR_FMT = "${FG_GRAY} ╱ 📂 ${cwdShort}${R}"
}

$CONV_FMT = ""
if (-not [string]::IsNullOrEmpty($convId)) {
    $subConvId = if ($convId.Length -gt 8) { $convId.Substring(0, 8) } else { $convId }
    $CONV_FMT = "${FG_GRAY} ╱ id:${subConvId}${R}"
}

$tokDetails = ""
if ($ctxUsed -gt 0) {
    $ctxUsedFmt = Get-HumanFormat $ctxUsed
    $ctxLimitFmt = Get-HumanFormat $ctxLimit
    $tokDetails = " (${ctxUsedFmt}/${ctxLimitFmt})"
}

$DOT = "${FG_GRAY} · ${R}"

# ─── Output Assembly ──────────────────────────────────────────────────────────
if ($cols -ge 120) {
    $line1 = "${S}${M}${V}${DIR_FMT}${CONV_FMT}"
    if ($ctxUsed -gt 0) {
        $ctxUsedFmt = Get-HumanFormat $ctxUsed
        $ctxLimitFmt = Get-HumanFormat $ctxLimit
        $inputTokFmt = Get-HumanFormat $inputTokens
        $outputTokFmt = Get-HumanFormat $outputTokens
        $tokDetails = " (${ctxUsedFmt}/${ctxLimitFmt} · ${inputTokFmt} in/${outputTokFmt} out)"
    }
    $line2 = " ${CTX_BAR}${tokDetails}${DOT}${ART_FMT}${DOT}${SUB_FMT}${DOT}${BG_FMT}${DOT}${SB}"
    Write-Output "${line1}${FG_GRAY}  │  ${R}${line2}"
} elseif ($cols -ge 80) {
    $line1 = "${S}${M}${V}${DIR_FMT}"
    $line2 = " ${CTX_BAR}${tokDetails}${DOT}${ART_FMT}${DOT}${SUB_FMT}${DOT}${BG_FMT}${DOT}${SB}"
    Write-Output "${FG_GRAY}╭─${R} ${line1}"
    Write-Output "${FG_GRAY}╰─${R}${line2}"
} else {
    $mShort = ""
    if (-not [string]::IsNullOrEmpty($modelDisp)) {
        $subModelDisp = if ($modelDisp.Length -gt 12) { $modelDisp.Substring(0, 12) } else { $modelDisp }
        $mShort = "${FG_GRAY} ╱ ${FG_BRIGHT_MAGENTA}${subModelDisp}${R}"
    }
    Write-Output "${S}${mShort}"
    Write-Output "${CTX_BAR}${DOT}${BG_FMT}"
}
