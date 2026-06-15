#!/usr/bin/env fish

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

set -l GEMINI_5H (echo $DATA | jq -r 'if .quota["gemini-5h"].remaining_fraction != null then ((.quota["gemini-5h"].remaining_fraction * 1000 | round) / 10) else -1 end')
set -l GEMINI_WK (echo $DATA | jq -r 'if .quota["gemini-weekly"].remaining_fraction != null then ((.quota["gemini-weekly"].remaining_fraction * 1000 | round) / 10) else -1 end')
set -l TP_5H (echo $DATA | jq -r 'if .quota["3p-5h"].remaining_fraction != null then ((.quota["3p-5h"].remaining_fraction * 1000 | round) / 10) else -1 end')
set -l TP_WK (echo $DATA | jq -r 'if .quota["3p-weekly"].remaining_fraction != null then ((.quota["3p-weekly"].remaining_fraction * 1000 | round) / 10) else -1 end')

set -l GEMINI_5H_RESET (echo $DATA | jq -r '.quota["gemini-5h"].reset_in_seconds // -1')
set -l GEMINI_WK_RESET (echo $DATA | jq -r '.quota["gemini-weekly"].reset_in_seconds // -1')
set -l TP_5H_RESET (echo $DATA | jq -r '.quota["3p-5h"].reset_in_seconds // -1')
set -l TP_WK_RESET (echo $DATA | jq -r '.quota["3p-weekly"].reset_in_seconds // -1')

# ─── VCS directly from git (bypasses JSON parsing entirely for accuracy) ──────
set -l GIT_DIR $CWD
if test -z "$GIT_DIR"
    set GIT_DIR "."
end
set -l GIT_BRANCH (git -C "$GIT_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null)
if test -n "$GIT_BRANCH"
    set VCS_BRANCH $GIT_BRANCH
    set VCS_TYPE "git"
    if git -C "$GIT_DIR" status --porcelain 2>/dev/null | grep -q .
        set VCS_DIRTY "true"
    else
        set VCS_DIRTY "false"
    end
end

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
    if test -z "$num"; or test "$num" -eq 0 2>/dev/null
        echo "0"
        return
    end
    if test "$num" -ge 1000000 2>/dev/null
        set -l main (math -s0 "$num / 1000000")
        set -l dec (math -s0 "($num % 1000000) / 100000")
        echo "$main.$dec"M
    elif test "$num" -ge 1000 2>/dev/null
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

# Helper for visible length
function visible_len -a str
    set -l stripped (string replace -a -r '\x1b\[[0-9;]*m' '' $str)
    string length $stripped
end

# Right align helper
function print_right_aligned -a left right total_cols
    set -l left_vis (visible_len $left)
    set -l right_vis (visible_len $right)
    set -l pad (math "$total_cols - $left_vis - $right_vis")
    if test "$pad" -lt 1
        set pad 1
    end
    set -l spaces (string repeat -n $pad " ")
    echo -e "$left$spaces$right"
end

# State Indicator
set -l S ""
switch $STATE
    case idle
        set S "$FG_BRIGHT_GREEN$B  READY$R"
    case thinking
        set S "$FG_BRIGHT_YELLOW$B 󰟷 THINKING$R"
    case working
        set S "$FG_BRIGHT_CYAN$B  WORKING$R"
    case tool_use
        set S "$FG_BRIGHT_MAGENTA$B  TOOL$R"
    case '*'
        set -l upper_state (string upper $STATE)
        set S "$FG_WHITE$B  $upper_state$R"
end

# Separators
set -l DOT "$FG_GRAY | $R"

# VCS Branch & Type
set -l V ""
if test -n "$VCS_BRANCH"
    if test "$VCS_DIRTY" = "true"
        set V "$DOT$R$FG_BRIGHT_RED $VCS_BRANCH$FG_BRIGHT_YELLOW*$R"
    else
        set V "$DOT$R$FG_BRIGHT_BLUE $VCS_BRANCH$R"
    end
end

# Model
set -l MODEL_DISP $MODEL_NAME
if test -z "$MODEL_DISP"
    set MODEL_DISP $MODEL_ID
end
set -l M ""
if test -n "$MODEL_DISP"
    set M "$FG_GRAY$DOT$FG_BRIGHT_MAGENTA$I $R$MODEL_DISP$R"
end

# Sandbox Badge
set -l SB ""
if test "$SANDBOX" = "true"
    if test "$SANDBOX_NET" = "true"
        set SB "$FG_GREEN󰒙 $FG_BRIGHT_GREEN$B ON (net)$R"
    else
        set SB "$FG_GREEN󰴴 $FG_BRIGHT_GREEN$B ON (no-net)$R"
    end
else
    set SB "$FG_RED󰦜 $FG_BRIGHT_RED$B OFF$R"
end

# Context Bar (20 segments)
set -l BAR_LEN 20
set -l PCT_INT (math -s0 "$USED_PCT")
set -l FILLED (math -s0 "$PCT_INT * $BAR_LEN / 100")
set -l REMAINDER (math -s0 "($PCT_INT * $BAR_LEN) % 100")

set -l BAR_COLOR $FG_YELLOW
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
set -l CTX_BAR "$FG_YELLOW󱍏  $R$BAR_COLOR$BAR$R $NUM_COLOR$PCT_FMT%$R"
set -l ART_FMT "$FG_BLUE $NUM_COLOR$ARTIFACTS$R"
set -l SUB_FMT "$FG_CYAN󱙺 $NUM_COLOR$SUBAGENTS$R"
set -l BG_FMT "$FG_MAGENTA $NUM_COLOR$BG_TASKS$R"

set -l DIR_FMT ""
if test -n "$CWD_SHORT"
    set DIR_FMT "$FG_GRAY$DOT$FG_CYAN $R$CWD_SHORT$R"
end

set -l CONV_FMT ""
if test -n "$CONV_ID"
    set -l sub_conv (string sub -l 8 $CONV_ID)
    set CONV_FMT "$FG_GRAY$DOT$FG_GRAY󰍪 $sub_conv$R"
end

set -l TOK_DETAILS ""
if test "$CTX_USED" -gt 0 2>/dev/null
    set TOK_DETAILS " ($CTX_USED_FMT/$CTX_LIMIT_FMT)"
end

# ─── Quota formatting ────────────────────────────────────────────────────────
function format_reset_time -a sec
    if test -z "$sec"; or test "$sec" -le 0
        echo -n ""
        return
    end

    set -l days (math -s0 "$sec / 86400")
    set -l rem (math -s0 "$sec % 86400")
    set -l hours (math -s0 "$rem / 3600")
    set -l rem2 (math -s0 "$rem % 3600")
    set -l mins (math -s0 "$rem2 / 60")

    if test "$days" -gt 0
        if test "$hours" -gt 0
            echo -n "$days"d" "$hours"h"
        else
            echo -n "$days"d"
        fi
    elif test "$hours" -gt 0
        if test "$mins" -gt 0
            echo -n "$hours"h" "$mins"m"
        else
            echo -n "$hours"h"
        fi
    elif test "$mins" -gt 0
        echo -n "$mins"m"
    else
        echo -n "<1m"
    fi
end

function make_quota_bar -a val label bar_color reset_sec R FG_GRAY FG_BRIGHT_GREEN FG_BRIGHT_YELLOW FG_BRIGHT_RED
    if test -z "$val"; or string match -q "-*" -- "$val"
        set -l bar ""
        for i in (seq 1 20)
            set bar "$bar░"
        end
        echo -n "$FG_GRAY| $R$FG_BRIGHT_WHITE$B$label$R $FG_GRAY$bar N/A$R"
        return
    end

    set -l val_int (string split -m 1 "." $val)[1]
    if test -z "$val_int"
        set val_int 0
    end
    
    set -l fill_color $FG_BRIGHT_GREEN
    if test "$val_int" -lt 20
        set fill_color $FG_BRIGHT_RED
    elif test "$val_int" -lt 50
        set fill_color $FG_BRIGHT_YELLOW
    end

    set -l bar_len 20
    set -l filled (math -s0 "$val_int * $bar_len / 100")
    set -l remainder (math -s0 "($val_int * $bar_len) % 100")
    
    set -l bar ""
    for i in (seq 0 (math "$bar_len - 1"))
        if test "$i" -lt "$filled"
            set bar "$bar$bar_color"█"$R"
        elif test "$i" -eq "$filled"
            if test "$remainder" -ge 75
                set bar "$bar$bar_color"▓"$R$FG_GRAY"
            elif test "$remainder" -ge 50
                set bar "$bar$bar_color"▒"$R$FG_GRAY"
            elif test "$remainder" -ge 25
                set bar "$bar$bar_color"░"$R$FG_GRAY"
            else
                set bar "$bar$FG_GRAY"░"$R"
            end
        else
            set bar "$bar$FG_GRAY"░"$R"
        end
    end

    set -l reset_str ""
    if test -n "$reset_sec"; and test "$reset_sec" -gt 0
        set -l time_fmt (format_reset_time $reset_sec)
        set reset_str " ⌛️ $time_fmt"
    end
    echo -n "$FG_GRAY| $R$FG_BRIGHT_WHITE$B$label$R $bar $fill_color$val%$R$reset_str"
end

set -l MODEL_LOWER (string lower "$MODEL_DISP")
set -l Q_5H ""
set -l Q_WK ""
set -l Q_5H_R ""
set -l Q_WK_R ""
if string match -q -r 'gemini' "$MODEL_LOWER"
    set Q_5H $GEMINI_5H
    set Q_WK $GEMINI_WK
    set Q_5H_R $GEMINI_5H_RESET
    set Q_WK_R $GEMINI_WK_RESET
else
    set Q_5H $TP_5H
    set Q_WK $TP_WK
    set Q_5H_R $TP_5H_RESET
    set Q_WK_R $TP_WK_RESET
end

set -l QUOTA_FMT ""
if test -n "$Q_5H"; or test -n "$Q_WK"
    set -l fmt_5h (make_quota_bar $Q_5H "5H" "$FG_BRIGHT_CYAN" "$Q_5H_R" "$R" "$FG_GRAY" "$FG_BRIGHT_GREEN" "$FG_BRIGHT_YELLOW" "$FG_BRIGHT_RED")
    set -l fmt_wk (make_quota_bar $Q_WK "7D" "$FG_BRIGHT_MAGENTA" "$Q_WK_R" "$R" "$FG_GRAY" "$FG_BRIGHT_GREEN" "$FG_BRIGHT_YELLOW" "$FG_BRIGHT_RED")
    set QUOTA_FMT "$fmt_5h $fmt_wk"
end

# Output Assembly
if test "$COLS" -ge 180
    set -l line1 "$S$M$DIR_FMT$V$CONV_FMT"
    if test "$CTX_USED" -gt 0 2>/dev/null
        set TOK_DETAILS " ($CTX_USED_FMT/$CTX_LIMIT_FMT)$DOT$FG_YELLOW $R ($INPUT_TOK_FMT in/$OUTPUT_TOK_FMT out)"
    end
    set -l line2 "$ART_FMT$DOT$SUB_FMT$DOT$BG_FMT$DOT$SB$DOT$CTX_BAR$TOK_DETAILS$DOT$QUOTA_FMT"
    print_right_aligned $line1 $line2 $COLS
elif test "$COLS" -ge 90
    set -l line1 "$S$M$DIR_FMT$V"
    set -l line2 " $CTX_BAR$TOK_DETAILS$DOT$ART_FMT$DOT$SUB_FMT$DOT$BG_FMT$DOT$SB$DOT$QUOTA_FMT"
    echo -e "$FG_GRAY╭─$R$line1"
    echo -e "$FG_GRAY╰─$R$line2"
else
    set -l M_SHORT ""
    if test -n "$MODEL_DISP"
        set -l sub_model (string sub -l 12 $MODEL_DISP)
        set M_SHORT "$FG_GRAY ╱ $FG_BRIGHT_MAGENTA$sub_model$R"
    end
    echo -e "$S$M_SHORT"
    echo -e "$CTX_BAR$DOT$BG_FMT$DOT$QUOTA_FMT"
end
