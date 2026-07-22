# Bash completion script for Antigravity CLI (agy)

_agy_completions() {
    local cur prev opts commands
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    commands="install update plugin /logout /statusline /title /settings /help"
    opts="-h --help -v --version -p --prompt -c --continue --conversation --sandbox --model --dir"

    case "$prev" in
        plugin)
            COMPREPLY=( $(compgen -W "list install remove enable disable" -- "$cur") )
            return 0
            ;;
        --dir)
            COMPREPLY=( $(compgen -d -- "$cur") )
            return 0
            ;;
        --conversation)
            return 0
            ;;
        -p|--prompt|--model)
            return 0
            ;;
    esac

    if [[ "$cur" == -* ]]; then
        COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
        return 0
    else
        COMPREPLY=( $(compgen -W "$commands $opts" -- "$cur") )
        return 0
    fi
}

complete -F _agy_completions agy
