#compdef agy

# Zsh completion script for Antigravity CLI (agy)

_agy() {
    local -a commands options

    commands=(
        'install:Configure shell integration and environment'
        'update:Self-update the CLI to latest version'
        'plugin:Manage CLI plugins and MCP servers'
        '/logout:Sign out and clear session credentials'
        '/statusline:Configure terminal status line'
        '/title:Configure terminal window title'
        '/settings:Open settings menu'
        '/help:Show help and command manual'
    )

    options=(
        '(-h --help)'{-h,--help}'[Display help menu]'
        '(-v --version)'{-v,--version}'[Display version info]'
        '(-p --prompt)'{-p,--prompt}'[Run a one-shot prompt]:prompt string:'
        '(-c --continue)'{-c,--continue}'[Continue previous session]'
        '--conversation[Load session by ID]:conversation ID:'
        '--sandbox[Run inside isolated Docker container]'
        '--model[Specify model name override]:model:'
        '(-d --dir)'{-d,--dir}'[Specify target binary installation directory]:directory:_files -/'
    )

    _arguments -s \
        "$options[@]" \
        '1: :->command' \
        '*:: :->args'

    case "$state" in
        command)
            _describe -t commands 'agy command' commands
            ;;
        args)
            case $words[1] in
                plugin)
                    local -a plugin_cmds
                    plugin_cmds=(
                        'list:List installed plugins'
                        'install:Install a plugin'
                        'remove:Remove a plugin'
                    )
                    _describe -t plugin_cmds 'plugin command' plugin_cmds
                    ;;
            esac
            ;;
    esac
}

_agy "$@"
