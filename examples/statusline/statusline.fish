#!/usr/bin/fish

# Read JSON payload from stdin
set -l DATA (cat)

# Extract fields using jq. Since Fish is on Unix, jq will be available.
if not type -q jq
    echo "READY"
    echo "ctx · 0%"
    exit 0
end

set -l STATE (echo $DATA | jq -r '.agent_state // "idle"')
set -l USED_PCT (echo $DATA | jq -r '.context_window.used_percentage // 0')
set -l VCS_BRANCH (echo $DATA | jq -r '.vcs.branch // ""')
set -l VCS_DIRTY (echo $DATA | jq -r '.vcs.dirty // false')
set -l VCS_TYPE (echo $DATA | jq -r '.vcs.type // ""')
set -l SANDBOX (echo $DATA | jq -r '.sandbox.enabled // false')
set -l SANDBOX_NET (echo $DATA | jq -r '.sandbox.allow_network // false')
set -l ARTIFACTS (echo $DATA | jq -r '.artifact_count // 0')
set -l SUBAGENTS (echo $DATA | jq -r 'if .subagents | type == "array" then (.subagents | length) else 0 end')
set -l BG_TASKS (echo $DATA | jq -r '.task_count // 0')
set -l MODEL_ID (echo $DATA | jq -r '.model.id // ""')
set -l MODEL_NAME (echo $DATA | jq -r '.model.display_name // ""')
set -l COLS (echo $DATA | jq -r '.terminal_width // 80')
set -l CWD (echo $DATA | jq -r '.cwd // ""')
set -l CONV_ID (echo $DATA | jq -r '.conversation_id // ""')
set -l INPUT_TOKENS (echo $DATA | jq -r '.context_window.total_input_tokens // 0')
set -l OUTPUT_TOKENS (echo $DATA | jq -r '.context_window.total_output_tokens // 0')
set -l CTX_LIMIT (echo $DATA | jq -r '.context_window.context_window_size // 0')
set -l CTX_USED (echo $DATA | jq -r '(.context_window.total_input_tokens // 0) + (.context_window.total_output_tokens // 0)')

# ANSI Helpers
set -l R (set_color normal)
set -l B (set_color -o)
set -l I (set_color -i)

set -l FG_RED (set_color red)
set -l FG_GREEN (set_color green)
set -l FG_YELLOW (set_color yellow)
set -l FG_BLUE (set_color blue)
set -l FG_MAGENTA (set_color magenta)
set -l FG_CYAN (set_color cyan)
set -l FG_WHITE (set_color white)
set -l FG_GRAY (set_color 909090)

set -l FG_BRIGHT_RED (set_color brred)
set -l FG_BRIGHT_GREEN (set_color brgreen)
set -l FG_BRIGHT_YELLOW (set_color bryellow)
set -l FG_BRIGHT_BLUE (set_color brblue)
set -l FG_BRIGHT_MAGENTA (set_color brmagenta)
set -l FG_BRIGHT_CYAN (set_color brcyan)
set -l FG_BRIGHT_WHITE (set_color brwhite)

set -l NUM_COLOR "$FG_BRIGHT_WHITE$B"

function human_format -a num
    if test -z "$num"; or test "$num" -eq 0
        echo "0"
        return
    end
    if test "$num" -ge 1000000
        set -l main (math -s0 "$num / 1000000")
        set -l dec (math -s0 "($num % 1000000) / 100000")
        echo "$main.$dec"M
    elif test "$num" -ge 1000
        set -l main (math -s0 "$num / 1000")
        set -l dec (math -s0 "($num % 1000) / 100")
        echo "$main.$dec"K
    else
        echo "$num"
    end
end

set -l INPUT_TOK_FMT (human_format $INPUT_TOKENS)
set -l OUTPUT_TOK_FMT (human_format $OUTPUT_TOKENS)
set -l CTX_LIMIT_FMT (human_format $CTX_LIMIT)
set -l CTX_USED_FMT (human_format $CTX_USED)

function shorten_path -a path
    if test -z "$path"
        echo ""
        return
    end
    set -l shortened (string replace -r "^$HOME" "~" $path)
    if test (string length $shortened) -gt 25
        set -l base_name (basename $shortened)
        echo "...$base_name"
    else
        echo $shortened
    end
end
set -l CWD_SHORT (shorten_path $CWD)

# State Indicator
set -l S ""
switch $STATE
    case idle
        set S "$FG_BRIGHT_GREEN$B● READY$R"
    case thinking
        set S "$FG_BRIGHT_YELLOW$B◆ THINKING$R"
    case working
        set S "$FG_BRIGHT_CYAN$B⚙ WORKING$R"
    case tool_use
        set S "$FG_BRIGHT_MAGENTA$B🔧 TOOL$R"
    case '*'
        set -l upper_state (string upper $STATE)
        set S "$FG_WHITE$B⏳ $upper_state$R"
end

# VCS Branch & Type
# Fallback to local git query if VCS_BRANCH is not provided in the JSON payload
if test -z "$VCS_BRANCH"
    set -l git_dir "."
    if test -n "$CWD"
        set git_dir $CWD
    end
    if git -C "$git_dir" rev-parse --is-inside-work-tree >/dev/null 2>&1
        set VCS_BRANCH (git -C "$git_dir" rev-parse --abbrev-ref HEAD 2>/dev/null)
        set VCS_TYPE "git"
        if test -n "$VCS_BRANCH"
            if git -C "$git_dir" status --porcelain 2>/dev/null | string match -q -r '.'
                set VCS_DIRTY "true"
            else
                set VCS_DIRTY "false"
            end
        end
    end
end

set -l V ""
if test -n "$VCS_BRANCH"
    set -l vcs_label "git"
    if test -n "$VCS_TYPE"
        set vcs_label $VCS_TYPE
    end
    if test "$VCS_DIRTY" = "true"
        set V "$FG_GRAY ╱ $FG_GRAY$vcs_label:$FG_BRIGHT_RED$VCS_BRANCH$FG_BRIGHT_YELLOW*$R"
    else
        set V "$FG_GRAY ╱ $FG_GRAY$vcs_label:$FG_BRIGHT_BLUE$VCS_BRANCH$R"
    end
end

# Model
set -l MODEL_DISP $MODEL_NAME
if test -z "$MODEL_DISP"
    set MODEL_DISP $MODEL_ID
end
set -l M ""
if test -n "$MODEL_DISP"
    set M "$FG_GRAY ╱ $FG_BRIGHT_MAGENTA$I$MODEL_DISP$R"
end

# Sandbox Badge
set -l SB ""
if test "$SANDBOX" = "true"
    if test "$SANDBOX_NET" = "true"
        set SB "$FG_GRAY🛡️ sandbox $FG_BRIGHT_GREEN$B ON (net)$R"
    else
        set SB "$FG_GRAY🛡️ sandbox $FG_BRIGHT_GREEN$B ON (no-net)$R"
    end
else
    set SB "$FG_GRAY🛡️ sandbox off$R"
end

# Context Bar
set -l BAR_LEN 15
set -l PCT_INT (math -s0 "$USED_PCT")
set -l FILLED (math -s0 "$PCT_INT * $BAR_LEN / 100")
set -l REMAINDER (math -s0 "($PCT_INT * $BAR_LEN) % 100")

set -l BAR_COLOR $FG_BRIGHT_WHITE
if test "$PCT_INT" -ge 90
    set BAR_COLOR $FG_BRIGHT_RED
elif test "$PCT_INT" -ge 60
    set BAR_COLOR $FG_BRIGHT_YELLOW
end

set -l BAR ""
for i in (seq 0 (math "$BAR_LEN - 1"))
    if test "$i" -lt "$FILLED"
        set BAR "$BAR"█
    elif test "$i" -eq "$FILLED"
        if test "$REMAINDER" -ge 75
            set BAR "$BAR"▓
        elif test "$REMAINDER" -ge 50
            set BAR "$BAR"▒
        elif test "$REMAINDER" -ge 25
            set BAR "$BAR"░
        else
            set BAR "$BAR"·
        end
    else
        set BAR "$BAR"·
    end
end

# Stats & Metadata
set -l PCT_FMT (printf "%.1f" $USED_PCT)
set -l CTX_BAR "$FG_GRAY ctx $BAR_COLOR$BAR $NUM_COLOR$PCT_FMT%$R"
set -l ART_FMT "$FG_GRAY 📦 $NUM_COLOR$ARTIFACTS$R"
set -l SUB_FMT "$FG_GRAY 🤖 $NUM_COLOR$SUBAGENTS$R"
set -l BG_FMT "$FG_GRAY ⏳ $NUM_COLOR$BG_TASKS$R"

set -l DIR_FMT ""
if test -n "$CWD_SHORT"
    set DIR_FMT "$FG_GRAY ╱ 📂 $CWD_SHORT$R"
end

set -l CONV_FMT ""
if test -n "$CONV_ID"
    set -l sub_conv (string sub -l 8 $CONV_ID)
    set CONV_FMT "$FG_GRAY ╱ id:$sub_conv$R"
end

set -l TOK_DETAILS ""
if test "$CTX_USED" -gt 0
    set TOK_DETAILS " ($CTX_USED_FMT/$CTX_LIMIT_FMT)"
end

set -l DOT "$FG_GRAY · $R"

# Output Assembly
if test "$COLS" -ge 120
    set -l line1 "$S$M$V$DIR_FMT$CONV_FMT"
    if test "$CTX_USED" -gt 0
        set TOK_DETAILS " ($CTX_USED_FMT/$CTX_LIMIT_FMT · $INPUT_TOK_FMT in/$OUTPUT_TOK_FMT out)"
    end
    set -l line2 " $CTX_BAR$TOK_DETAILS$DOT$ART_FMT$DOT$SUB_FMT$DOT$BG_FMT$DOT$SB"
    echo -e "$line1$FG_GRAY  │  $R$line2"
elif test "$COLS" -ge 80
    set -l line1 "$S$M$V$DIR_FMT"
    set -l line2 " $CTX_BAR$TOK_DETAILS$DOT$ART_FMT$DOT$SUB_FMT$DOT$BG_FMT$DOT$SB"
    echo -e "$FG_GRAY╭─$R $line1"
    echo -e "$FG_GRAY╰─$R$line2"
else
    set -l M_SHORT ""
    if test -n "$MODEL_DISP"
        set -l sub_model (string sub -l 12 $MODEL_DISP)
        set M_SHORT "$FG_GRAY ╱ $FG_BRIGHT_MAGENTA$sub_model$R"
    end
    echo -e "$S$M_SHORT"
    echo -e "$CTX_BAR$DOT$BG_FMT"
end
