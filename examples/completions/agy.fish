# Fish completion script for Antigravity CLI (agy)

complete -c agy -f

# Options
complete -c agy -s h -l help -d "Display help menu"
complete -c agy -s v -l version -d "Display version info"
complete -c agy -s p -l prompt -r -d "Run a one-shot prompt"
complete -c agy -s c -l continue -d "Continue previous session"
complete -c agy -l conversation -r -d "Load session by ID"
complete -c agy -l sandbox -d "Run inside isolated Docker container"
complete -c agy -l model -r -d "Specify model name override"
complete -c agy -s d -l dir -r -a "(__fish_complete_directories)" -d "Specify installation directory"

# Commands
complete -c agy -n "__fish_use_subcommand" -a install -d "Configure shell integration and environment"
complete -c agy -n "__fish_use_subcommand" -a update -d "Self-update the CLI to latest version"
complete -c agy -n "__fish_use_subcommand" -a plugin -d "Manage CLI plugins and MCP servers"
complete -c agy -n "__fish_use_subcommand" -a "/logout" -d "Sign out and clear session credentials"
complete -c agy -n "__fish_use_subcommand" -a "/statusline" -d "Configure terminal status line"
complete -c agy -n "__fish_use_subcommand" -a "/title" -d "Configure terminal window title"
complete -c agy -n "__fish_use_subcommand" -a "/settings" -d "Open settings menu"
complete -c agy -n "__fish_use_subcommand" -a "/help" -d "Show help and command manual"

# Subcommands for plugin
complete -c agy -n "__fish_seen_subcommand_from plugin" -a "list install remove"
