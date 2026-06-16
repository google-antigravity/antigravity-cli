# Antigravity CLI Changelog

The terminal-first surface to interact with Antigravity agents. Stay in your flow without context switching.

## 1.0.8

- Added support for capturing slash command history, allowing users to use the up arrow to replay previously entered slash commands.
- Redesigned the "Models & Quota" page (enabled by default, replacing the legacy usage page) to gracefully handle disabled quota buckets by displaying a dimmed "Disabled" status and omitting the progress bar.
- Added display of quota usage and execution mode in the status line.
- Improved `/btw` to be more token efficient and support streaming responses for a smoother user experience and fixed premature truncation.
- Fixed a bug where the `/hooks` command wrote configurations to `~/.gemini/antigravity-cli/hooks.json` instead of the shared `~/.gemini/config/hooks.json`, ensuring hooks remain synchronized between the TUI and the backend.
- Fixed a CPU compatibility issue (SIGILL on non-AES-NI CPUs), preventing immediate crashes on startup on older CPUs (like Intel Ivy Bridge) or VM environments that lack AES-NI support.
- Added a per-line guard against extremely long single-line pastes in the TUI prompt editor to prevent performance lag, replacing them with an expandable placeholder.
- Redesigned the `/resume` conversation picker to align the workspace column and added adaptive column dropping (workspace, time, steps) to support narrow terminals.
- Redesigned the `/tasks` list and detail views for better alignment and readability, placing start times on the left, right-aligning status, and capping the panel height.
- Fixed dynamic reloading of custom skills and system slash commands, ensuring they are instantly discovered in autocomplete upon conversation switch or `/add-dir`.
- Improved configuration saving by propagating write failures as transient error flashes on the statusline.
- Improved settings inheritance by ensuring the CLI inherits the `use_ai_credits` setting from global user settings on startup.
- Fixed a TUI hang in the artifact view during long sessions by optimizing the rendering complexity of large step histories.
- Fixed an autocomplete bug where a command that is an exact prefix of another (e.g., `/conv` vs `/conv-switch`) would aggressively auto-complete and hide the suggestions menu.
- Fixed a race condition where sending a message immediately after denying a permission request would fail due to incomplete backend cleanup.
- Fixed potential OOM risks when reading large clipboard files by verifying file size before reading.
- Fixed Windows and Wayland-only Linux distributions clipboard image and file reading.

## 1.0.7

- Added a configurable timeout for launching MCP servers, allowing users to specify a custom timeout or set it to `-1` to disable the timeout completely.
- Revamped the artifact viewer gutter numbering and line mapping to accurately align terminal viewport lines with actual 1-based source file line numbers, including support for wrapped lines and collapsed Mermaid diagrams.
- Fixed a bug where the CLI could get stuck in a pending state (showing a transient spinner) after sending a message due to stale status updates.
- Fixed a bug where the wrong workspace directory was displayed in the header and `/help` menu when multiple workspaces were active.
- Fixed a desync bug in the agent state management where stale callbacks from previous runs could be used upon cache hits in new agent state.
- Fixed Windows-specific sandbox network proxy issues, resolving a hang during connection hijacking and correcting tunnel response protocols.
- Fixed a bug where the archival status timestamp was not correctly saved when archiving conversations.
- Fixed a potential stack overflow crash by introducing a non-recursive warning output mechanism for pre-conversation errors.
- Increased the maximum tool calls limit to 512 for Gemini models, allowing agents to perform significantly more complex, multi-step tasks in a single turn.
- Added support for installing plugins directly from GitHub subpaths (with branch resolution).
- Fixed variable resolution in plugins, ensuring gemini cli variables like `${extensionPath}` correctly resolves to the final installation directory.
- Added native Wayland clipboard support (wl-paste) on Linux, falling back to `xclip` for X11 environments, and prioritized copied files (from file managers) over raw image data.
- Preserved unknown fields in `settings.json` during read, write, and merge operations, preventing settings from being silently wiped out when switching between different CLI versions or builds.
- Fixed layout boundary overflow, scrolling visibility, and out-of-bounds scrolling bugs in the artifact detail view when inline comments are present.

## 1.0.6

- Added shell-style path auto-completion for `/open` and `/add-dir`.
- Added optimistic rendering for user chat prompt submissions, injecting messages immediately into the viewport to eliminate perceived input lag.
- Added fuzzy and partial substring matching across slash commands. E.g. `/el` -> shows `/help` and `/model` while previous no suggested completions.
- Fixed a bug when suggestion was not triggered when `@` is typed after `(`. Enabled unconditional typeahead suggestions whenever `@` is typed without preceding whitespace, streamlining mention workflows.
- Skipped subagent conversations from `/resume`, keeping the standalone conversation picker focused purely on direct user initiated conversations.
- Added a `stack_with_default` flag to the `statusLine` configuration to render both the default Antigravity status line and custom status line output vertically stacked.
- Fixed a bug where entering a prompt immediately after pressing `Esc` (to interrupt an active agent stream) caused the newly typed input to be swallowed or rejected.
- Fixed `--sandbox` flag propagation in headless print mode (`-p` / `--print`), ensuring sandbox isolation is correctly enforced during non-interactive execution.

## 1.0.5

- Added `--model` to set model when launching CLI. Also a new `models` subcommand to list available models.
- Added `/permissions` command which allows to add/edit/remove permissions rules for each of the three configs above directly inside the CLI.
- Allowed opening the Artifact Review panel (shortcut `ctrl+r`) while answering pending questions or tool permission confirmations, preserving your current progress when toggling back.
- Fixed a bug that metadata was written in the current directory as opposed to `~/.gemini/antigravity-cli/cache` when running using `-p`.
- Improved statusline layout by merging active tip and artifact status on a single line and truncating with ellipsis on narrow terminals to prevent collisions.
- Improved customization support by allowing directories in the customization manager to be passed as workspace directories, enabling correct trajectory metadata population and `/add-dir` support.
- Added support for `url` in `mcp_config.json` to configure MCP servers directly via a URL.
- Improved `/resume` performance: optimized lazy loading of conversation details, filtered out empty conversations, and added support for scanning SQLite database files (`.db` and `.db-wal`).
- Improved autocomplete: tab completion for slash commands now resolves to the matched alias instead of the primary command name (e.g., `/se` autocompletes to `/settings` instead of `/config`).
- Integrated the permissioning system with the rest of Antigravity. CLI permissions now merges project level permissions, permissions from user settings shared with Antigravity, and permissions from the CLI `settings.json`.

## 1.0.4

- Added SQLite (.db) conversation support and will be CLI’s conversation format. Fixed a bug when importing SQLite conversation from Antigravity 2.0 to CLI.
- Added LaTeX math rendering, enabling the CLI to display beautiful mathematical formulas directly in the terminal viewport. Set `AGY_CLI_DISABLE_LATEX` environment variable to turn off LaTeX rendering globally if desired.
- Decoupled project discovery from local `.antigravitycli` workspace directories. The CLI now stores workspace-to-project mappings in a centralized `~/.gemini/antigravity-cli/cache/projects.json` file, eliminating repository clutter and speeding up project discovery to a single-map lookup.
- Resolved sporadic and permanent UI hangs caused by a stateful callback streamer race condition during network drops or extremely fast agent steps.
- Collapses all newlines and consecutive whitespaces in conversation previews and titles before rendering list items, preventing visual UI layout breaks in the picker rows.
- Styled the separator space between the line number column and diff content to match the text blocks, ensuring background highlights stretch seamlessly across the viewport width in tool outputs and `/diff` details.
- Resolved inconsistent behavior where selecting skill-derived slash commands from autocompletion suggestions cleared the input without executing. Autocompleted skill commands are now correctly submitted to the backend.
- Aligned the interactive `/changelog` and `agy changelog` cache paths to both use `antigravity-cli`, and made the caching process synchronous to resolve a race condition where immediate process exit terminated the cache write.
- Moved VCS detection out of the synchronous CLI startup path to prevent slow initialization.
- Resolved an issue where exclusion rules and allowlists configured in rules.json were silently ignored, causing the discovery engine to load every .md rule file unconditionally at boot.
- Parallelized the MCP server initialization sequence, preventing slow or hanging custom MCP servers from blocking independent, fast-starting servers (like local plugins) from loading on startup or configuration reloads.

## 1.0.3

- Added support for G1 credits in the Antigravity CLI. Users can now utilize G1 credits when their standard quota runs out. This includes a new `UseG1Credits` setting to enable automatic credit usage and a real-time display of remaining credits in the status bar.
- Added a new `/credits` panel that provides an in-CLI interface with a direct link to purchase additional G1 credits.
- Fixed an infinite loop in the prompt input. Navigating left (`wordLeft`) when encountering spaces at the very beginning of the input no longer causes an infinite hang.
- Fixed custom MCP server disabling via the TUI. Resolved a directory path mismatch where pressing the `[Disable]` button wrote to the legacy `mcp_config.json` path instead of the migrated `config/mcp_config.json` path, ensuring custom MCP servers can now be successfully disabled and unloaded.
- Redesign CLI logo on Apple Terminal.
- Improved color scheme preview in settings and onboarding: added warnings and thought process examples to the preview, and corrected link styling to only underline the URL.
- Fixed `$EDITOR` environment variable parsing: resolved issues where arguments containing `=` (e.g., `--alternate-editor=vi`) were incorrectly split, causing editor launch failures.
- Fixed `/diff` detail view truncation: implemented dynamic line wrapping based on terminal viewport width and added automatic tab-to-space expansion to prevent layout overflow.
- Fixed project discovery robustness: updated the CLI to skip invalid or broken symlinks in `.antigravitycli/` rather than failing immediately, allowing discovery of valid projects.
- Fixed `AskQuestion` state management: memorizes selected options, write-in values, and UI states when navigating back and forth (`KeyLeft`) between questions in multi-question dialogs.

## 1.0.2

- Added `AGY_CLI_HIDE_ACCOUNT_INFO` environment variable to hide email and plan tier from the header.
- Fixed timeout overrides: restricted the default 60-second interaction timeout specifically to subagents, preventing the main agent from being unconditionally capped.
- Fixed a nil-pointer panic in Sandbox Mode: resolved a typed nil interface comparison when fetching URL content.
- Fixed fallback skill discovery in Standalone mode: ensures custom/fallback skills are successfully loaded even if the standard configuration directory is missing, and added automatic path deduplication to prevent duplicates.
- Fixed command rendering in message history: prefixed slash commands with a caret (`>`) in response block headers to clearly distinguish user-typed commands from agent outputs.
- Fixed plugin installation path mismatch: updated the `plugin` subcommand to install downloaded plugins directly to the shared configuration directory (`~/.gemini/config/`) rather than the private application data folder, making them instantly discoverable.
- Fixed Git short-hash support in diff selection: updated the commit hash recognition pattern in the  /diff  commit selection tree to match Git's standard 7-character short hashes (and up to 40-character full hashes).
- Fixed statusline subcommand handling and recursive loops: added case-insensitive subcommand parsing (help, delete, reset, enable/on, disable/off) to the /statusline command, providing direct control to toggle or revert custom statuslines and blocking recursive shell hangs during help queries.
- Improved `/help` shortcuts tab by sorting shortcuts by keybinding key, adding missing keybindings (like `ctrl+r`, `ctrl+o`, `alt+j`, `ctrl+k`), and generalizing scrolling (PageUp/PageDown/GoToTop/GoToBottom) for both Commands and Shortcuts tabs.

## 1.0.1

- Fixed OAuth token persistence and authentication hangs.
- Fixed Windows log redirection and resizing issues. Resolved a critical bug where logs were not redirected correctly on Windows, which previously caused the terminal to swallow window resize events and shut down slowly.
- Added `proceed-in-sandbox` tool permission mode. Auto-approves terminal commands that run inside the secure sandbox, requesting manual approval only when a command attempts to bypass the sandbox.
- Integrates consumer/free-tier onboarding directly into the CLI.
- Added plugin discovery for skills and agents. Automatically scans installed plugin directories to make custom skills and specialized agents available for execution in the CLI.
- Fixed pasted text line counting. Corrected line counting for user inputs to ensure extremely long inputs are correctly folded into a `[Pasted text #X +Y lines]` placeholder to keep the viewport clean.
- Fixed onboarding stability. Resolved a race condition where a concurrent terminal resize event during onboarding could revert the UI to a blank onboarding screen.
- Moves the **terminal** color scheme to the top of the selection list, making it the default choice during onboarding and in `/settings`.
- Improved `/usage` and `/quota` commands. Forces a real-time reload of model configuration and remaining quotas, allowing you to see updated real-time consumption statistics immediately.
- Improved step rendering layout. Calculates available terminal width dynamically and uses middle-truncation (`/foo/.../bar`) for file path tools to prevent layout shifting on narrow screens.
- Improved session deletion keybinding in `/resume`. Changed the shortcut from `ctrl+d` to `ctrl+delete` to resolve conflicts with the global exit keybinding (`ctrl+d` `ctrl+d`) and preserve Emacs-style forward-delete in search input fields.
- Restored automatic table wrapping, preventing long cells inside markdown tables from being truncated.
- Resolved an issue where deleted files (represented by `+++ /dev/null`) had their deletion lines incorrectly merged into the previous file's diff.

## 1.0.0

- Initial release of the Antigravity CLI.
