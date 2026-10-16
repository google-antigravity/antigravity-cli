# PowerShell status line script for Antigravity CLI
# Replicates the official statusline.sh example in PowerShell

# Ensure standard output encoding is UTF-8 so Unicode characters display correctly
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# --- ANSI Helpers (Standard 16-color palette only) ---
$esc = [char]27
$R = "$esc[0m"         # Reset
$B = "$esc[1m"         # Bold
$D = "$esc[2m"         # Dim
$I = "$esc[3m"         # Italic

# Foreground accents
$FG_BLACK = "$esc[30m"
$FG_RED = "$esc[31m"
$FG_GREEN = "$esc[32m"
$FG_YELLOW = "$esc[33m"
$FG_BLUE = "$esc[34m"
$FG_MAGENTA = "$esc[35m"
$FG_CYAN = "$esc[36m"
$FG_WHITE = "$esc[37m"

$FG_GRAY = "$esc[90m"
$FG_BRIGHT_RED = "$esc[91m"
$FG_BRIGHT_GREEN = "$esc[92m"
$FG_BRIGHT_YELLOW = "$esc[93m"
$FG_BRIGHT_BLUE = "$esc[94m"
$FG_BRIGHT_MAGENTA = "$esc[95m"
$FG_BRIGHT_CYAN = "$esc[96m"
$FG_BRIGHT_WHITE = "$esc[97m"

$NUM_COLOR = "${FG_BRIGHT_WHITE}${B}"

# --- Unicode Icons and Symbols ---
$readyIcon = [char]::ConvertFromUtf32(0x25cf)     # ●
$thinkingIcon = [char]::ConvertFromUtf32(0x23f3)  # ⏳
$workingIcon = [char]::ConvertFromUtf32(0x2699)   # ⚙
$toolIcon = [char]::ConvertFromUtf32(0x1f527)     # 🔧
$diamondIcon = [char]::ConvertFromUtf32(0x25c6)  # ◆
$fullBlock = [char]::ConvertFromUtf32(0x2588)    # █
$darkShade = [char]::ConvertFromUtf32(0x2593)    # ▓
$medShade = [char]::ConvertFromUtf32(0x2592)     # ▒
$lightShade = [char]::ConvertFromUtf32(0x2591)    # ░
$middleDot = [char]::ConvertFromUtf32(0xb7)       # ·
$boxH = [char]::ConvertFromUtf32(0x2500)          # ─
$boxV = [char]::ConvertFromUtf32(0x2502)          # │
$boxTR = [char]::ConvertFromUtf32(0x256d)         # ╭
$boxBR = [char]::ConvertFromUtf32(0x2570)         # ╰

# Default values
$state = "idle"
$usedPct = 0.0
$vcsBranch = ""
$vcsDirty = $false
$sandbox = $false
$artifacts = 0
$subagentsCount = 0
$bgTasks = 0
$model = ""
$cols = 80

# --- Parse JSON from stdin ---
try {
    $jsonString = [System.Console]::In.ReadToEnd()
    if ($jsonString) {
        $data = ConvertFrom-Json $jsonString
        if ($data) {
            if ($data.agent_state) { $state = $data.agent_state }
            if ($data.context_window -and $data.context_window.used_percentage -ne $null) {
                $usedPct = [double]$data.context_window.used_percentage
            }
            if ($data.vcs) {
                if ($data.vcs.branch) { $vcsBranch = $data.vcs.branch }
                if ($data.vcs.dirty -ne $null) { $vcsDirty = [bool]$data.vcs.dirty }
            }
            if ($data.sandbox -and $data.sandbox.enabled -ne $null) { $sandbox = [bool]$data.sandbox.enabled }
            if ($data.artifact_count -ne $null) { $artifacts = [int]$data.artifact_count }
            if ($data.subagents) {
                if ($data.subagents -is [array]) {
                    $subagentsCount = $data.subagents.Length
                } else {
                    $subagentsCount = 1
                }
            }
            if ($data.task_count -ne $null) { $bgTasks = [int]$data.task_count }
            if ($data.model -and $data.model.display_name) { $model = $data.model.display_name }
            if ($data.terminal_width -ne $null) { $cols = [int]$data.terminal_width }
        }
    }
} catch {
    # Fallback to defaults if parsing fails
}

# --- State Indicator ---
switch ($state) {
    "idle"     { $S = "${FG_BRIGHT_GREEN}${B}${readyIcon} READY${R}" }
    "thinking" { $S = "${FG_BRIGHT_YELLOW}${B}${thinkingIcon} THINKING${R}" }
    "working"  { $S = "${FG_BRIGHT_CYAN}${B}${workingIcon} WORKING${R}" }
    "tool_use" { $S = "${FG_BRIGHT_MAGENTA}${B}${toolIcon} TOOL${R}" }
    default    { $S = "${FG_WHITE}${B}${readyIcon} $($state.ToUpper())${R}" }
}

# --- VCS Branch ---
$V = ""
if ($vcsBranch) {
    if ($vcsDirty) {
        $V = "${FG_GRAY} ${diamondIcon} ${FG_BRIGHT_RED}${vcsBranch}${FG_BRIGHT_YELLOW}*${R}"
    } else {
        $V = "${FG_GRAY} ${diamondIcon} ${FG_BRIGHT_BLUE}${vcsBranch}${R}"
    }
}

# --- Model ---
$M = ""
if ($model) {
    $M = "${FG_GRAY} ${diamondIcon} ${FG_BRIGHT_MAGENTA}${I}${model}${R}"
}

# --- Sandbox Badge ---
if ($sandbox) {
    $SB = "${FG_GRAY}sandbox ${FG_BRIGHT_GREEN}${B}ON${R}"
} else {
    $SB = "${FG_GRAY}sandbox off${R}"
}

# --- Context Bar ---
$pctFmt = $usedPct.ToString("F1", [System.Globalization.CultureInfo]::InvariantCulture)
$pctInt = [int][Math]::Floor($usedPct)

$barLen = 15
$filled = [int][Math]::Floor($pctInt * $barLen / 100)
$remainder = ($pctInt * $barLen) % 100

if ($pctInt -ge 90) {
    $barColor = $FG_BRIGHT_RED
} elseif ($pctInt -ge 60) {
    $barColor = $FG_BRIGHT_YELLOW
} else {
    $barColor = $FG_BRIGHT_WHITE
}

$BAR = ""
for ($i = 0; $i -lt $barLen; $i++) {
    if ($i -lt $filled) {
        $BAR += $fullBlock
    } elseif ($i -eq $filled) {
        if ($remainder -ge 75) {
            $BAR += $darkShade
        } elseif ($remainder -ge 50) {
            $BAR += $medShade
        } elseif ($remainder -ge 25) {
            $BAR += $lightShade
        } else {
            $BAR += $middleDot
        }
    } else {
        $BAR += $middleDot
    }
}

# --- Stats ---
$CTX = "${FG_GRAY}ctx ${barColor}${BAR} ${NUM_COLOR}${pctFmt}%${R}"
$ART_FMT = "${FG_GRAY}artifacts ${NUM_COLOR}${artifacts}${R}"
$SUB_FMT = "${FG_GRAY}subagents ${NUM_COLOR}${subagentsCount}${R}"
$BG_FMT = "${FG_GRAY}tasks ${NUM_COLOR}${bgTasks}${R}"

# Separator
$DOT = "${FG_GRAY} ${middleDot} ${R}"

# --- Output ---
$LINE1 = "${S}${M}${V}"
$LINE2 = " ${CTX}${DOT}${ART_FMT}${DOT}${SUB_FMT}${DOT}${BG_FMT}${DOT}${SB}"

if ($cols -ge 120) {
    # Wide: single line
    Write-Output "${LINE1}${FG_GRAY}  ${boxV}  ${R}${LINE2}"
} elseif ($cols -ge 80) {
    # Medium: two-line layout with border
    Write-Output "${FG_GRAY}${boxTR}${boxH}${R} ${LINE1}"
    Write-Output "${FG_GRAY}${boxBR}${boxH}${R}${LINE2}"
} else {
    # Narrow: compact two-line, minimal chrome
    Write-Output "${S}${M}"
    Write-Output "${CTX}${DOT}${BG_FMT}"
}
