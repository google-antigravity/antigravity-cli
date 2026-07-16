# Antigravity CLI Changelog

The terminal-first surface to interact with Antigravity agents. Stay in your flow without context switching.

## 1.1.3

- Added a `/codesearch` command (aliases `/cs` and `/search`) to interactively search code across your workspace, interpreting queries as regex by default with `-F`/`--literal` for exact matching and `f:`/`file:` globs to include or exclude paths.
- Added copy-on-select in no-flickering mode so dragging highlights text and releasing the mouse copies the ANSI-stripped selection to the clipboard, and hides the virtual scrollbar so it no longer interferes with copying multi-line output.
- Added an indicator at each context-compaction boundary so you can see where earlier compaction happened.
- Improved interactive startup latency by loading skills asynchronously so the CLI no longer blocks on a synchronous, filesystem-heavy skill-discovery pass during bring-up.
- Improved eligibility error handling by showing errors with a verification URL inline in the input loop instead of stacking them above the screen.
- Improved customization loading latency for skills, rules, agents, and hooks by consolidating directory walks and caching filesystem lookups to cut redundant I/O during discovery.
- Removed the padding spaces around inline code for tighter rendering.
- Fixed code-block corruption where `$..$` math expansion desynced from the Markdown parser and mangled fenced shell snippets such as `git fetch "$GIT_REMOTE"` by detecting fenced code blocks line-by-line.
- Fixed headless (`-p`) runs hanging or silently auto-approving tools that require a permission confirmation, so the CLI now soft-denies such tools and prints a stderr notice naming the allow-rule needed to permit them.
- Fixed outside-of-workspace file writes being incorrectly auto-approved in always-proceed mode.
- Fixed high CPU and unbounded render cost on large conversations in no-flickering mode by making index rebuilds idempotent so the conversation index converges instead of growing on every rebuild.
- Fixed lingering artifact comments after dismissing the artifact detail view and corrected no-flickering-mode row math so the status line renders correctly within the viewport.
- Fixed repeated sign-in prompts on Linux caused by the OS keyring: the CLI now bypasses the keyring when no D-Bus session bus is present (headless hosts and containers), skips it for an hour after a timeout, and uses longer keyring timeouts so a slow-but-successful credential read is no longer cut short and forced into a fresh login.
- Fixed MCP servers hanging the agent indefinitely when a server never responds by bounding connection, tool-listing, and per-tool-call attempts with timeouts.
- Fixed conversations breaking after certain tool calls, which previously corrupted the conversation history and blocked all further responses.
- Fixed customization rules being loaded twice when a rules directory is reachable through a symlink.

## 1.1.2

- Added an `f` (full diff) shortcut to the create-file tool review screen so new-file confirmations can open a full-screen diff view, matching the existing file-edit experience.
- Added support for pasting the OAuth authorization code in print mode (-p) via the controlling terminal (/dev/tty on POSIX and CONIN$ on Windows) when stdin is consumed by a piped prompt, and made truly headless runs fail fast with an actionable message instead of blocking.
- Improved responsiveness on large conversations (5000+ steps) in no flickering mode by switching hot-path line-count methods to pointer receivers, cutting the per-frame prefix-sum cost and eliminating sustained 99% CPU and keystroke lag.
- Fixed print mode silently downgrading to the default model when --model cannot be resolved by hard-failing with a non-zero exit and listing the available models, while interactive sessions keep the fallback-with-warning behavior.
- Fixed permission checks not respecting the allowlist for nested command substitutions, so a command like echo "$(dirname $(git rev-parse --show-toplevel))" now runs without prompting when echo and git are allowlisted, instead of double-counting the nested command and prompting for review.
- Fixed the CLI keybindings file staying out of sync with /keybindings when new default bindings are introduced by persisting the injected defaults while preserving user overrides.
- Fixed garbled builtin tool headers such as CodeSearch(4 files found...) by mapping generic tool steps back to clean summaries like Read(/path) and CodeSearch(query).
- Fixed mcp manager failing to resolve tool schema paths in standalone mode and leaking MCP server subprocesses after shutdown, which previously caused panics and cleanup failures for custom agents loading MCP tools.
- Fixed a data race and copy-on-write violation when updating subagent states by cloning their stats before in-place mutation, preventing corrupted step counts and status for parallel subagents.

## 1.1.1

- Added the `--agent` flag and `agent/agents` subcommand, allowing users to select a custom agent at launch and list available agents.
- Added in-file keyword search (`/`) and jump navigation (`n/N`) to the artifact detail viewer, allowing users to find and cycle through matches without disrupting terminal escape sequences or image grids.
- Fixed print mode (`--print` / `-p`) silently exiting with a success code and empty output when a request failed server-side, now writing the error to stderr and returning a non-zero exit code.
- Fixed `agy -p` hanging when run inside a shell script or subprocess by no longer reading stdin when a prompt is provided via a flag.
- Fixed a data race on the `/btw` cancellation function.
- Added support for displaying nested subagents (grandchild and deeper) and handling tool confirmation requests across all subagent depths by recursively relaying nested subtrajectory updates to the root conversation.
- Changed the default mode to respect write_file permissions allowlisted in `settings.json` under `permission.allow`, so pre-approved file writes no longer prompt for review.
- Changed the default name for the newly initialized project to `CLI Project` for clearer workspace identification.
- Improved the session exit output by placing the resume command on its own line, making it easier to copy and paste in terminals and tools like tmux.
- Fixed interactive `/diff` viewer defects in Jujutsu (jj) workspaces by correctly prioritizing `.jj` over `.git` in colocated repos, fixing commit hash regex boundaries, and correctly highlighting active `@` graph nodes.
- Fixed workspace-local hooks defined in `<workspace>/.agents/hooks.json` not loading after trusting a folder by reloading hooks whenever workspaces change.
- Fixed misaligned markdown tables containing file links in chat output.

## 1.1.0

- Agent execution mode cycling is now publicly available: `default` -> `accept-edits` -> `plan`)
- Added `request-review` (default) mode as the default execution behavior: automatically pauses before file write operations to display an interactive, line-level diff preview (`f` shortcut) where users can review, accept, or reject individual code modifications before they are saved to disk.
- Added an `Agent Mode` option to the `/settings` panel so users can set and persist a default execution mode (`default`, `accept-edits`, `plan`) without manually editing `settings.json` or passing `--mode` on startup, with real-time synchronization so changes take effect immediately.
- Added a dedicated `"Create file"` confirmation preview for new file creations (`write_to_file` without overwrite): renders new content as an addition-only diff preview.
- Added `/plan` mode to replace legacy `/planning`, and removed `/fast` slash commands: consolidated and simplified execution mode switching around `shift+tab` mode cycling and the `/plan` mode prefix
- Improved file-edit diff preview rendering: computed accurate line-level diffs with context lines (`3` lines) and hunk separators, capped inline preview height with truncation hints, and added a comment confirmation prompt when exiting the diff view with unsent comments.
- Improved UI footer keybinding hints across all panels (such as `/tasks`, `/agents`, `/permissions`, and `/mcp`) by replacing hardcoded hint strings with centralized layout helpers that dynamically respect customized global and local keybinding configurations (`keybindings.json`).
- Improved the multiline conversation rename view in the `/resume` picker by dynamically adjusting input box width and padding, and right-aligning metadata columns (`workspace`, `steps`, `time`) on the top line to prevent horizontal scrolling or layout shifts during active renaming.
- Fixed the tool confirmation dialog to accurately check normalized file URIs against active workspace directories, resolving an issue where valid in-workspace file creations and reads were incorrectly flagged with an `"Reason: outside workspace"` warning.
- Fixed workspace initialization failures when launching the CLI inside dot-prefixed directories (such as  .parent_dir/project ) by scoping path exclusion filters strictly to relative paths inside the workspace rather than rejecting dot-prefixed ancestor directories.
- Fixed the `/agents` view header displaying `agent.json` instead of `agent.md` when creating new subagents.
- Fixed the `/agents` panel's `"Create New Agents"` section displaying the wrong global configuration directory (`~/.gemini/antigravity-cli/` instead of `~/.gemini/config/`), ensuring users create global subagents in the location actively scanned during startup discovery.
- Fixed statusline shortcut hints (`? for shortcuts`) and redundant escape hints (`Esc to cancel`) erroneously appearing inside full-screen overlay panels (such as `/changelog`, `/artifact`, and `/settings`) by correctly tracking overlay panel states.
- Fixed inconsistent timestamp formatting in the `/tasks` panel and task detail views by converting agent-initiated background task timestamps (`time.Time`) from UTC to the local timezone.

## 1.0.16

- Improved the `/tasks` detail panel to automatically scroll to the bottom as new background task logs stream in, and default to the latest output when opened while preserving scroll position if scrolled up manually.
- Improved model generation resilience by adding automatic client-side retries when encountering transient errors.
- Fixed dynamically defined subagents by transitioning definitions from JSON to Markdown format, fixing an issue where dynamically created subagents failed to invoke.
- Fixed a crash occurring when executing background tasks or terminal commands that produce empty outputs (such as `sleep`).
- Fixed shutdown resource leaks by integrating the shared SQLite summary store for background synchronization and resolving goroutine and database connection leaks on CLI exit.
- Fixed a permission manager hook error by safely handling empty decision strings returned by pre-tool hooks instead of failing with an "unknown pre-tool hook decision" error.

## 1.0.15

- Introduced a new interactive status indicator below the input box that displays active subagents and background tasks in real-time, making it easy to monitor and navigate parallel workflows at a glance.
- Added `ctrl+g` on the artifact view to open $EDITOR. Also added a warning confirmation prompt before opening the editor in the artifact detail view if there are unsent comments, and ensured these comments are preserved upon reload if the artifact content was not modified.
- Added `alt+v` as an alternative paste shortcut on Windows to resolve issues where ctrl+v is intercepted by the terminal emulator, enabling reliable image pasting.
- Improved the `/permissions` panel to dynamically reload configurations from disk and prevent accidental overwrites.
- Increased the MCP connection timeout to 60 seconds to improve reliability for slow-starting custom MCP servers.
- Fixed a bug on Windows where print mode and other non-TUI command outputs were silently discarded when run in non-TTY environments (such as pipes or subprocesses).
- Fixed Windows editor fallback to use "edit" or "notepad" when the editor setting is "auto" and no editor is configured, instead of attempting to use "vim".
- Fixed the subagent approval TUI to dynamically render user-defined custom keybindings (such as alternative approval keys) instead of showing hardcoded defaults.
- Fixed alignment and wrapping issues in the comment editor for multiline comments, ensuring all lines are indented consistently.

## 1.0.14

- Allowed image pasting from the clipboard in local tmux sessions.
- Removed the max limit for the `/goal` command, allowing goals to run indefinitely until completed or cancelled.
- Enabled "always proceeds" mode for subagents to auto approve artifacts, preventing them from hanging when the parent is blocked.
- Fixed plugin import logic to copy the entire plugin directory, preventing it from stripping non-skill directories (like `shared/`).
- Fixed an MCP configuration path mismatch in the CLI and permission manager to ensure reliable custom MCP server loading.
- Fixed a TUI layout race condition caused by stale input state in the conversation model.
- Fixed a bug where the inline viewport was not properly reset after a conversation rewind.

## 1.0.13

- Fixed a bug where the CLI would temporarily render skill commands without their slash prefix during optimistic updates by deferring prefix stripping to the serialization boundary, ensuring the UI always displays exactly what the user typed.
- Fixed a redundant CLI exit message by removing the "Resume in the same project" hint line, leaving only the standard resume command to simplify exit output.
- Resolved bugs during UI transitions (such as opening subagent details or logging out) by introducing a unified synchronization mechanism that prevents key lockups and ensures overlay panels like the /help view are properly reset.
- Improved command permission security by making "Always Approve" rule matching strict (non-regex) by default, while allowing users to explicitly opt-in to regex matching by prepending rules with `regex:`.
- Improved command permission usability by relaxing redirection checks, allowing safe commands with output redirection (e.g., `tool > file`) to match without requiring strict full-command approval.
- Fixed a bug in the CLI prompt editor where undo and redo history stacks could become desynchronized during rapid mutations by decoupling the history state into a unified, pointer-backed structure.
- Fixed a bug where browser-related prompt sections were missing from the agent's prompt registry, ensuring browser-based tasks execute reliably.

## 1.0.12

- Added support for `--project` and `--new-project` launch flags to allow users to explicitly set or create projects, and updated the project resolution logic to default regardless of the active workspace.
- Added a confirmation prompt when pressing `Esc` in comment mode with unsaved modifications to prevent users from accidentally discarding their work in review views.
- Added dynamic OSC8 terminal hyperlink support to render clickable links in supporting terminals, with automatic fallback stripping for backward compatibility.
- Introduced reverse diff cycling navigation mapped to `shift+n` in unified diff review mode to allow users to easily cycle backwards through diff blocks.
- Improved permission config merging priorities by ensuring project-specific configurations (located in `~/.gemini/config/projects/`) take precedence over global settings in `~/.gemini/antigravity-cli/settings.json`.
- Fixed a regression where `ctrl+o` scrollback clearing failed by restoring the use of cached fields rather than shared pointer comparisons for trajectory toggle detection.
- Fixed a rendering bug where Makefile syntax (like `$(call ...)`) inside code blocks was mistakenly parsed and mangled by LaTeX math expansion, by introducing a state machine that restricts expansion to prose segments.
- Fixed an enterprise network connectivity issue by restoring AES-NI compile-time optimizations, which prevents Deep Packet Inspection (DPI) firewalls from incorrectly flagging and resetting TLS connections.
- Fixed incorrect key strings by removing the unsupported backtab default binding and correcting invalid `pgdn` references to `pgdown` to align with Bubble Tea v2 canonical names.

## 1.0.11

- Added `ctrl+c` as an exit and interrupt key: the first press cancels active agent operations (like streaming responses), and a double-press triggers the exit flow. Also added a dynamic exit hint in the status line.
- Fixed `ctrl+d` behavior to act as a forward-delete when the input prompt contains text, only triggering the exit flow when the prompt is empty.
- Improved `/resume` loading performance by implementing a persistent metadata cache and parallel loader, eliminating severe latency with large conversation histories and preventing background loading log spam.
- Added an expanded AltScreen view for tool confirmations (accessible via `ctrl+g`), allowing users to view and edit the full command and associated permissions in a dedicated full-screen view, replacing the inline edit (`e`) key.
- Added the `AGY_CLI_CMD_OUTPUT_PERCENTAGE` environment variable, allowing users to customize the maximum height of command outputs in the TUI as a percentage of the terminal height.
- Added strict key name validation to the keybindings system to reject invalid key names (like typos) and suggest canonical alternatives, preventing "dead keys" from being registered.
- Added a validation warning when `ctrl+c` is mapped to a non-default action, clarifying that the system always intercepts `ctrl+c` to interrupt active operations or exit, and providing instructions on how to resolve the warning.
- Improved command output rendering by making the output height dynamic, improving the readability of commands like `/keybindings`.
- Improved text rendering with ANSI-aware word wrapping at word boundaries and prevented URLs containing hyphens from being incorrectly split across lines.
- Improved the `/resume` experience: added support for pasting clipboard text into the search filter and rename fields, upgraded the rename input to a multiline editor to prevent long titles from being hidden, and fixed a bug where the navigation cursor could disappear.
- Improved keybinding validation warning messages to use user-facing names (e.g., `cli.escape`) instead of internal representation names.
- Improved startup behavior by only creating the `keybindings.json` configuration file when the user explicitly runs the `/keybindings` customization command, rather than automatically generating it on every startup.
- Improved keybinding error presentation by replacing the persistent error footer with transient error alerts, freeing up valuable terminal space.
- Fixed the `ctrl+c` exit safety valve to ensure it always works as an interrupt or exit key, regardless of how it is mapped in the user's custom keybindings configuration.
- Fixed VCS commit tree rendering to reserve the `@` marker exclusively for the actual current commit in the VCS history rather than the synthetic "Working Copy" entry, helping users easily identify the working copy parent.
- Fixed authentication error handling to gracefully handle unsigned-in states by returning an empty configuration and suppressing noisy error logs.

## 1.0.10

- Improved compatibility with a broader set of ARM64 devices (e.g. raspberry pi 4b).
- Added `antigravity_guide` builtin skill to provide instant, in-context reference guides for the Antigravity 2.0, CLI, IDE, and SDK.
- Improved commit history navigation: scrolling now immediately loads and displays changed files and diffs.
- Improved Git integration by enabling ASCII node graphs (`git log --graph`) for visual parity with hg/jj.
- Improved commit hash matching to seamlessly resolve short (6-char) to long (64-char) hashes via prefix comparison.
- Added alert message type for system errors/warnings, separating them from standard command output.
- Added the CLI log file path to the `/help` menu for easy troubleshooting.
- Improved markdown rendering by upgrading `glamour` to v2.0.1 for cleaner headings and block padding.
- Improved authentication to automatically launch browser sign-in via `rundll32`.
- Fixed a bug where "ask" permissions were dropped during settings updates, ensuring `settings.json` preservation.
- Fixed permission engine matching bugs by escaping regex metacharacters (like `$` or `.`) in saved rules, preventing infinite prompt loops.
- Fixed environment flag parsing to prevent ignored disablement flags.
- Fixed bash mode argument escaping (preventing swallowed stdout) and defaulted shell resolution to PowerShell.

## 1.0.9

- Added submodule support for plugins installation. External plugin installation now automatically resolves and initializes Git submodules.
- Optimized customizations permissions: Automatically grants read-only access to the builtin customizations directory, eliminating redundant permission prompts on startup.
- Improved glamour parser error handling (like nested checkboxes inside list emphasis) and preventing it from crashing the TUI, falling back to raw text with a warning banner.
- Updated bubbletea to v2.0.7: Resolves a potential TUI panic when terminal input is unavailable, fixes a data race in mouse handling within the Cursed Renderer, and corrects mouse release behavior under the Kitty Keyboard protocol.
- Hardened command execution permission checks by enforcing strict exact-match verification for PowerShell scripts, complex shell redirections ( `>` , `2>&1` ), and unparseable strings to prevent sandbox escapes.
- Hardened sandbox execution by adding `.git` to the core list of dangerous paths, preventing unauthorized or destructive repository modifications.
- Fixed a bug where allowlisted terminal commands with quoted arguments (e.g., `python -c "print(1)"`) would silently fail to match at runtime due to flawed whitespace tokenization.
- Fixed a bug in headless print mode resumption (`--conversation`/`-c` `-p ...`) where the CLI would dump the entire historical conversation transcript instead of only printing the newly generated response.
- Fixed a CPU compatibility issue on ARM64 devices without AES hardware support.

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
