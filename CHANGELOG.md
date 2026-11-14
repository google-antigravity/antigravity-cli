# Antigravity CLI Changelog

<!-- disableFinding(LINE_OVER_80) -->

The terminal-first surface to interact with Antigravity agents. Stay in your flow without context switching.

## 1.5.9

- Added the `run_workflow` tool for everyone: the agent can run a Python workflow script that fans work out to many subagents in parallel or in stages and then combines their results. It uses the Python bundled with the CLI, so you don't need Python installed.
- Added a `pluginControls` section to managed admin settings, so organizations that don't use Gemini Enterprise can control plugins too: `pluginsDisabled` stops all plugins from loading, including built-in ones, and blocks installing or enabling them, while `marketplaceDisabled` turns off the plugin marketplace but keeps installed plugins working. Gemini Enterprise users keep following their organization's Cloud Console policy.
- Improved Auto mode's review of commands that would leave the terminal sandbox, so it decides faster and times out less often: the reviewer can now search the conversation, list directories, and search files directly instead of starting a sandboxed command for each check.
- Improved `/resume`: the conversation picker no longer fetches the full history of every open conversation, so it no longer stalls on "Loading conversations..." in long sessions, and `/resume <id>` now accepts any prefix that matches exactly one conversation, such as the short ID shown in the status line, and reports `conversation <id> not found` for an unknown ID instead of silently opening the picker.
- Improved `/browser` subagent session recordings, which are now `.mp4` files made with Chrome's built-in screen recording instead of `.webm`; they are saved to the conversation artifacts as `recording.mp4` (plus `recording_2.mp4` and so on when the session switches tabs or sits idle for 30 seconds), and if your Chrome version doesn't support it, recording is skipped for that turn with a one-time notice.
- Fixed a security issue where custom headers configured for an HTTP MCP server, such as API keys, could be forwarded to a different host when the server responded with a redirect; they are now sent only to the configured server's own origin.
- Fixed the terminal UI accepting malformed or implausible window-size reports, such as negative or extremely large dimensions from stray escape sequences, which could make the CLI freeze or use excessive memory; these reports are now ignored.
- Fixed several `agy acp` issues: a session no longer fails with "Authentication required" after `agy acp --login` when `settings.json` names an auth method that has no credential (such as `gemini-api-key` without `GEMINI_API_KEY`), because the CLI now falls back to your saved login; prompts no longer fail when the ACP client passes an MCP server whose name contains spaces or other special characters; a failed turn now reports its specific error, such as a model or quota error, instead of "Agent execution terminated due to error."; and the diffs sent for completed edits no longer carry an extra trailing newline in `oldText` and `newText`.
- Fixed more cases of files saved with a UTF-8 byte order mark (BOM) being mishandled: `"modelProvider"` in `settings.json` is now honored on the first run, `agy acp` now loads your settings and authentication options instead of falling back to defaults, and `agy plugin validate` now runs all of its checks on such a `hooks.json` and reports the real syntax error and line instead of blaming the BOM.
- Fixed `-i`/`--prompt-interactive` together with `--remote-agent` and `--conversation` or `--continue`: the prompt is now sent to the resumed conversation after its history loads, instead of starting a new conversation, and it is handled like typed input, so it shows right away, waits behind a running turn, and reports a failed send.
- Fixed `!` shell commands on Windows: PowerShell no longer drops double quotes, so commands like `! git commit -m "two words"` run exactly as typed, and quitting the CLI or killing the task in the tasks panel now also ends the programs the command started instead of leaving them running and the task marked as running.
- Fixed `/copy` and other clipboard actions on Windows over SSH: the copy now reaches your local clipboard, and the copied text is no longer written to the CLI log file.
- Fixed scheduled automations on Windows receiving only the first line of a multi-line prompt; each scheduled or manually triggered run now gets the full prompt.
- Fixed the macOS "Keychain Not Found" dialog reappearing about once an hour: after a keychain write fails, the CLI now saves your sign-in token to its file-based storage for the rest of the session instead of retrying the keychain on every token refresh.
- Fixed a race where reloading MCP servers while several subagents were starting could launch duplicate MCP server processes, leaving some subagents with broken MCP tools or failed sign-ins.
- Fixed MCP server and plugin OAuth sign-in on machines without an IPv4 loopback address, such as IPv6-only VMs; the sign-in callback now falls back to `[::1]` when `127.0.0.1` is unavailable instead of failing silently.
- Fixed signing in to a plugin from `/plugin` sometimes reporting that the sign-in didn't finish when it had just succeeded.
- Fixed tool groups jumping around when expanded with `Ctrl+O`: the collapse hint now stays on the same line as the expand hint, and in low verbosity the token summary line no longer disappears from the expanded view.
- Fixed the reasoning effort picker describing "high" as the deepest level, even though higher levels exist above it.
- Fixed the model selector in the Remote Control browser view on phones, where the list could not be scrolled by touch past the first screen, so models near the end of the list could not be selected.

## 1.5.8

- Added Gemini 4 Hydrogen (Low, Medium, High, and XHigh) and Gemini 4 Carbon (Low, Medium, and High) to `/model` and `--model` when you connect with a `GEMINI_API_KEY`, added Gemini 4 Hydrogen (Low, Medium, High, and XHigh) when you sign in with Application Default Credentials (`AGY_ADC_AUTH`), and added support for Gemini 4 Hydrogen through an enterprise model gateway.
- Added click-to-expand in the `full screen (altscreen)` rendering mode: clicking a tool group, a thought, a prompt's attached images, or multi-line command output now expands or collapses just that item, so you no longer have to use `Ctrl+O`. The default `Rendering Mode` is unchanged.
- Added context window usage updates to `agy acp` sessions, so editors such as JetBrains AI Chat can show how much of the model's context window the conversation is using; the value is sent when a session starts or is reloaded, after each model call, and after a model or thinking level change.
- Added support for two admin settings: `gateway.routeWebFetch` stops the agent's web page reads from going around an enterprise model gateway by disabling URL reading unless a `proxy.address` is configured, and `featureControls.remoteControlEnabled` lets an organization turn off Remote Control. With an enterprise model gateway, web pages are now fetched directly from your machine (through `proxy.address` when set) instead of through Google's fetch service.
- Improved the first message of a conversation in `--remote-agent` sessions, which no longer waits for its remote environment to start or resume: the CLI now prepares a new conversation's environment as soon as the session knows its remote project, and again after `/new` or switching projects, and starts a resumed conversation's idle environment in the background as soon as it opens with `--continue` or `--conversation=<id>`.
- Fixed a security issue in the terminal sandbox's network proxy where a command could get around path-based network rules, such as those limiting where credentials are sent or which Git and API paths are allowed, by using percent-encoded slashes (`%2F`), backslashes, or `..` segments in a URL path; every way of reading the path is now checked against the rules, and the cleaned-up path is the one sent upstream.
- Fixed always-allow command rules on Windows so they can no longer be bypassed when the shell is `cmd`, `cmd.exe`, `powershell.exe`, `pwsh.exe`, or a full path to one of them. Commands run in PowerShell or Command Prompt now always need an exact match, because their quoting rules differ from POSIX shells. A command with hidden extra statements, such as `git status '&& del secret.txt'`, could otherwise be approved by a rule meant only for `git status`.
- Fixed permission rules for MCP tools, such as an `mcp(server/tool)` deny or ask rule, being ignored for MCP tools that are loaded up front (marked eager in `mcp_config.json`) and for the `/browser` subagent's Chrome DevTools tools; these tools now ask for approval or are blocked according to your rules, like other MCP tools.
- Fixed `/plugin`, `agy plugin`, and headless `-p` runs ignoring your organization's Gemini Enterprise admin controls for plugins: when an administrator disables plugins, installing, importing, or enabling one now fails with `plugins are disabled by your organization`, and when the plugin marketplace is disabled, marketplace catalogs are not fetched and marketplace installs fail; listing, disabling, and uninstalling plugins still work.
- Fixed hook commands on Windows that contain double quotes, such as `type "C:\my dir\deny.json"`, failing and being silently skipped, which let a `PreInvocation` or `PreToolUse` hook that should block the agent go unenforced; hook commands are now passed to `cmd.exe` exactly as written.
- Fixed files saved with a UTF-8 byte order mark (BOM), as Windows PowerShell, Visual Studio, and Notepad's "UTF-8 with BOM" option do, being silently ignored: `settings.json` and files passed to `--settings` are no longer rejected as malformed, a `hooks.json` no longer leaves `/hooks` empty with none of its hooks running, and custom agent and rule files no longer go missing from `/agents` and the agent picker or lose their frontmatter trigger.
- Fixed opening your external editor on Windows when `EDITOR` or the `Editor` setting is a normal Windows path such as `C:\Tools\ed.cmd` or `"C:\Program Files\Vim\vim.exe"`; backslashes were dropped, so `Ctrl+G`, `/open`, `/keybindings`, and artifact review failed with an `editor ... not found in PATH` error.
- Fixed `!` shell commands hanging forever with no output when the command wrote a lot to stderr, which was easy to hit on Windows with build tools that print progress or warnings to stderr; such commands now finish and show their stdout and stderr lines in the order they were written.
- Fixed agent turns failing when a network connection silently went stale or the network dropped a shared HTTP/2 connection, for example with `http2: client connection force closed via ClientConn.Close` or after a socket write error; model requests now retry on a fresh connection and, if retries run out, show the CLI's network error message. Slow model responses also no longer time out after 60 seconds when an organization's admin settings configure a proxy or custom CA certificate.
- Fixed the CLI sometimes never exiting after a session, and background requests such as generating a conversation title, worktree name, or commit message hanging, when the model answered one of those requests with an unexpectedly long reply.
- Fixed a single empty or corrupted queued message file, for example one left behind by an unclean shutdown, blocking every later message to the agent, so background task completions, timers, and subagent replies no longer silently stop reaching it; the unreadable file is set aside and the remaining messages are delivered.
- Fixed remote MCP servers that sign in with OAuth without a client secret signing you out as soon as the access token expired, typically after an hour; token refreshes now send the client ID the way the server requires, so you stay signed in, including with sign-ins saved by earlier versions.
- Fixed the agent telling you to click a Sign in button or use an Accounts tab, which the CLI doesn't have, when a plugin or plugin MCP server needs you to sign in; it now tells you to sign in with `/plugin` and then send a message to continue, and `/mcp` shows the same `/plugin` guidance for a server that is waiting on a sign-in.
- Fixed switching a conversation from a Gemini model to a custom or admin-managed non-Gemini model, such as Claude, failing with an `Invalid signature in thinking block` error.
- Fixed `/btw` and `/help` side questions failing with `stream timed out after 5m0s` while the side question was still working: they now run until they finish or you press `Esc`, which the `Thinking...` line and the "already in progress" message now mention, and a side question that needs an approval the card can't show stops right away and tells you to ask in the main conversation instead.
- Fixed `/learn` repeatedly appending to rule files such as `GEMINI.md` or `AGENTS.md` until they grew past the rule size limit, after which their endings were silently cut off on every turn. Before updating a rule, `/learn` now checks the documented size limits, and when an update would get close to or exceed them, it proposes condensing existing entries, splitting them into a scoped rule, or moving step-by-step guidance into a skill.
- Fixed follow-up turns in a `--json-schema` conversation resumed with `--conversation` ending on a plain-text reply with no structured result once an earlier turn had produced one; each new message now gets its own reminders to return the structured output, up to the usual limit per message.
- Fixed `/rewind` failing with a `step_index out of bounds` error when you pressed `Esc` while a turn was still starting and then rewound to remove that message.
- Fixed `/diff` showing a made-up change at the end of a turn's diff for files larger than 500 KB when an earlier edit changed the file's length; the two versions are now cut off at the same line, so the preview shows only real edits.
- Fixed `/` search in the artifact viewer missing text split across different styles, such as a sentence containing a number or inline code, and leaving the rest of a styled line unstyled after a highlighted match; the current match is also now easier to pick out from the other matches in every color scheme.
- Fixed status messages such as "Copied 3 lines (42 characters)" after selecting text, settings save errors, and permission reload notices never appearing when you use a custom status line; they now briefly replace your custom status line, which comes back once the message clears, without shifting the layout.
- Fixed the in-progress spinner line freezing until you restarted the CLI after you logged out while the agent was working and then signed back in; it now keeps animating.

## 1.5.7

- Changed the default `Agent Mode` from Default to Auto: sessions with no saved mode, including headless `-p` runs, now start in Auto wherever Auto mode is available and in Default elsewhere; to keep the previous behavior, choose Default for `Agent Mode` in `/config`, which saves `"agentMode": ""` to `settings.json`. A `Tool Permission` setting of `strict` now also takes precedence over Auto and accept-edits modes, so file edits still ask for approval under `strict`.
- Fixed multi-second UI freezes, which also stalled streaming and window resizing, when a command printed a very long line without spaces; line wrapping now takes time proportional to the line's length.
- Fixed agent replies stalling for 20 seconds or more while a group of tool calls with long output was still animating its token counts; streamed steps now keep appearing while the group re-renders.
- Fixed the agent not noticing that a command it moved to the background was waiting for input, such as a password or `y/n` prompt printed before the command went to the background; the agent is now notified once that output settles instead of waiting silently.
- Fixed browser sign-in on Windows sometimes failing to complete because the CLI's local sign-in callback listened on only IPv4 or IPv6 while the browser redirected over the other; the callback now listens on both.
- Fixed Gemini 4 Carbon requests through an enterprise model gateway failing with an HTTP 400 `Thinking budget is not supported for this model` error; the CLI now sends Gemini 4 Carbon a thinking level and no longer leaves the Low, Medium, or High suffix in the model ID it sends to the gateway.
- Fixed a `PreToolUse` hook returning `auto_approve`, or a wildcard `command(*)` allow rule, bypassing an organization's admin-enforced review: commands that would leave the terminal sandbox, commands the admin policy holds for review, and file reads or writes outside the workspace under an "always ask" file-access policy now always ask for your approval.
- Fixed saved command allow and deny rules being ignored, so that every command asked for approval, when an organization's admin policy requires commands to run in the terminal sandbox but the machine has no OS sandbox; your saved rules now apply and unlisted commands still ask before running.
- Fixed background task details from `manage_task` losing their formatting when the task's recent output, or input sent to the task, contained Markdown code blocks or runs of backticks.
- Fixed Remote Control showing a link that could not be opened at the end of some agent replies, such as the swarm coordinator's link to the swarm UI; Remote Control now leaves these links out.

## 1.5.6

- Added the swarm's queen bee to the `/swarm board` header and a 🐝 beside each live member in the `Roster`; in terminals with Kitty graphics, such as Kitty and Ghostty, each member gets its own colored bee card that flaps while that member is working, and other terminals, including tmux, show the queen as pixel art when the window is at least 60×35.
- Added a `continuation_active` field to the JSON input of Stop hooks, which is `true` while the agent is already working on a continuation an earlier Stop hook requested, so a hook such as "run the tests before finishing" can tell it has already asked and avoid looping.
- Added a `supportsThoughtCirculation` option to admin-managed model entries (`models.list[]` in admin settings), so organizations can let non-Gemini models behind an enterprise model gateway reuse their reasoning from earlier turns; when it is unset, the model's default applies.
- Improved Auto mode's review of commands that would leave the terminal sandbox so it asks less often on safe reads: GitHub API reads, fetches into an existing clone, and single-file downloads such as `raw.githubusercontent.com` URLs no longer get the repository popularity, age, and release checks that cloning a repository still gets, host names that start with a digit are no longer mistaken for IP addresses, and reading `~/.ssh/config`, `known_hosts`, `authorized_keys`, or public keys (`*.pub`) is no longer treated as reading secrets, while private keys still are and sending any `.ssh` file elsewhere is still blocked.
- Improved `agy plugin validate` to warn when a plugin hook command uses `${PLUGIN_ROOT}` or `$PLUGIN_ROOT`, which older CLI versions do not set, and to suggest a relative path instead, since hooks already run in the plugin's folder; the warning fails validation only with `--strict`.
- Changed pay-as-you-go Google Cloud accounts that sign in with Application Default Credentials (`AGY_ADC_AUTH`) to use the same permission settings as other pay-as-you-go accounts, which makes Auto mode available to them; Gemini Enterprise accounts keep following their organization's admin-controlled permission settings, including their `unsandboxed(...)` deny and ask rules, and are not offered Auto mode.
- Fixed undo and redo in the prompt, including `u` in Vim mode, moving the cursor to the end of the input; the cursor now returns to where the undone or redone edit was made.
- Fixed `agy plugin install` ignoring the skill folders that a Claude Code plugin lists in the `"skills"` field of its manifest; those skills are now installed and loaded, and the install summary warns about listed paths that are missing, contain no skill, or point outside the plugin.
- Fixed `agy plugin install` and `agy plugin import` leaving a half-copied plugin that still loaded as enabled when an install failed partway; installs are now swapped in all at once and the previous version is restored on failure, plugins containing symlinks that point outside the plugin, FIFOs, or device files are refused, and a command whose file name cannot be used as a skill folder name is skipped with a warning instead of failing the import.
- Fixed pressing `esc` in a swarm member's conversation opened from `/swarm board` with `o` dropping you back at the prompt; it now returns to the board with the same selection, filter, focused pane, and zoom.
- Fixed a swarm coordinator sometimes ending its turn with a one-line filler reply instead of its real answer after being sent back to re-read board posts it had already read, fixed a coordinator offering a `sidecar://` board link that the CLI cannot open instead of `/swarm board` on later turns of a swarm, and fixed `agy -p` runs that start a swarm pointing you to `/swarm board`, which headless runs cannot open.
- Fixed some models served through an enterprise model gateway being sent requests without native tool declarations, which kept the agent from calling tools reliably; every model in the gateway's catalog, including models listed in `AGY_LLM_GATEWAY_MODELS`, now gets native tool calls.
- Fixed custom Gemini models served through an enterprise model gateway or an admin model list, such as tuned models, cutting off long edits and file writes at 8,192 output tokens; they now default to the same 65,535-token output limit as built-in Gemini models, and an explicit admin `maxOutputTokens` value still takes precedence.
- Fixed duplicate approval prompts and sandbox errors for organizations that enforce sandbox mode on machines without an OS sandbox, such as some Windows hosts or Linux with user namespaces disabled; commands now ask for review once and then run.
- Fixed editing project rules with `/permissions` clearing the marker that records the project's permission rules as already migrated, which made the Antigravity app migrate them again and could drop `command(...)` allow rules when the sandbox is on.

## 1.5.5

- Added swarms as a preview: start one with `/swarm <task>` and the agent becomes a coordinator that adds worker agents, each in its own conversation, which work on the task in parallel and collaborate through a shared message board; workers can be forked from an existing member's conversation, run on any model in the `/model` picker, and pause instead of retrying when their model runs out of quota, and a monitor worker alerts the coordinator when the whole swarm stalls. `/swarm` is labeled `(Preview & Quota Heavy)` in the `/` menu because every worker is a separate agent that uses your quota.
- Added `/swarm board`, a full-screen live view of the current swarm that also opens with `alt+s` (rebindable as `swarm.board`), with a `Roster` of members showing each one's state and model, a `Posts` feed, and a `Message` pane that renders the selected post as Markdown; `tab` and `shift+tab` move between panes, `z` zooms the focused pane, `enter` shows or hides the message, `[` and `]` step through posts, `p` filters the feed to one member's posts and the posts that mention them, `o` opens a member's subagent details, `f` follows new posts, and `esc` backs out.
- Added a `● Swarm(<title>)` row to the active-items tray below the prompt while a swarm runs, showing the latest post and the post count and then `Done` when the swarm finishes; press `Enter` on the row to open `/swarm board`, or `alt+x` (`swarm.dismiss`) to dismiss it.
- Added the `ANTIGRAVITY_DISABLE_EMBEDDED_RIPGREP` environment variable, which you can set to `true` to stop the CLI from extracting and running its bundled `ripgrep`, for example when endpoint security software blocks it, so searches use a `ripgrep` on your `PATH` or the built-in search instead.
- Added Gemini 4 Carbon (Low, Medium, and High) to `/model` and `--model` when you sign in with Application Default Credentials (`AGY_ADC_AUTH`).
- Changed enterprise model gateway URLs to require `https://` unless the gateway runs on the same machine (`localhost`, `127.0.0.0/8`, or `::1`); a remote gateway configured with a plain `http://` URL is now rejected with an error instead of receiving your prompts unencrypted.
- Fixed `agy plugin import` turning Claude Code plugin commands into skills that did not load or were all named `SKILL`; each command now becomes a skill named after its folder, including commands with no frontmatter or with Claude Code-style values such as `argument-hint: [base branch] [focus]`, and `agy plugin validate` no longer warns about the leftover `commands/` folder.
- Fixed `agy plugin import` copying certain plugin's `hooks/hooks.json` unchanged, which caused the plugin's hooks to be skipped; `PreToolUse`, `PostToolUse`, `Stop`, and startup `SessionStart` hooks are now converted, with tool names in matchers mapped to built-in tools (for example `Bash` to `run_command`) and a default 60-second timeout, and hooks with no equivalent are listed as warnings in the import summary.
- Fixed `agy -p` headless runs sometimes never exiting after printing their result when a background task, such as conversation title generation, got stuck; the CLI now finishes shutting down within 30 seconds.
- Fixed `/teamwork` writing run state into `.agents/teamwork/` in your working directory, where two runs in the same workspace could overwrite each other; each run now keeps its state in its own folder under the CLI's app data directory.
- Fixed links to files in agent responses showing only the file name, which made the file's location impossible to tell in terminals that cannot open clickable links, such as Terminal.app, `screen`, or over SSH; labels now show the path relative to your working directory, relative to `~/`, or the absolute path.
- Fixed enterprise model gateways that validate the request format rejecting every request, because the CLI sent a non-standard `sessionId` field in Gemini-format requests.
- Fixed subagents and swarm workers that get their own copy of a Git repository starting from the last commit and losing your uncommitted work; their worktree now includes your staged, unstaged, and untracked changes, and agents outside version control can give a subagent or worker an isolated copy of the workspace folder, for folders up to 100,000 entries and 4 GiB.

## 1.5.4

- Added Auto mode to `agy acp` sessions, so editors can switch a session to `auto` wherever the CLI itself offers Auto mode; it approves edits inside the workspace and runs commands in the terminal sandbox, and still asks before commands that would leave the sandbox unless Auto mode's review clears them.
- Added `hookEventName`, `cwd`, and `toolCall.id` to the JSON input that hooks receive, so a single hook command can handle several events, knows the agent's working directory, and can match a `PostToolUse` call to its `PreToolUse` call.
- Improved Auto mode's review of commands that would leave the terminal sandbox so it decides faster and times out less often, by using a lighter-thinking Gemini Flash model for the review.
- Fixed `agy acp` sessions dropping back to the default mode when an editor reloaded or resumed an open session, so a session in `accept-edits` no longer starts asking for permission on file writes again.
- Fixed `agy acp` turns hanging when a tool call needed a second permission approval, such as a command that asks again after its first approval; the editor now receives a new permission request instead of the turn waiting forever.
- Fixed crashes and freezes with subagents: the CLI no longer crashes when a subagent's question or approval prompt is drawn in a very narrow terminal or before the terminal size is known, a subagent's question no longer closes by itself while you are answering it, and opening a subagent's view no longer occasionally freezes the CLI.
- Fixed `PgUp` and `PgDn` in the conversation skipping text: paging down could jump past an entire message when a page ended exactly on a message boundary, and in `full screen (altscreen)` rendering mode the lines hidden under the pinned prompt header were scrolled past without ever being shown.
- Fixed a thought that follows a tool's result line, such as `Read 22 lines`, being indented as if it were part of that tool call in the expanded view (`Ctrl+O`).
- Fixed the `remote-control` background service staying disconnected for good when it started before the network was up, such as right after a reboot, and stopped it from printing a sign-in link it could not complete when checking the saved sign-in only hit a network error.
- Fixed the selected Gemini Enterprise plan being lost, and requests failing with permission errors, when the stored sign-in grew too large for the Windows Credential Manager or macOS Keychain; sign-ins that were already affected are repaired automatically the next time they load.
- Fixed the `Sign-in update needed` warning, which asks you to run `/logout` and sign in again when your sign-in is missing a newly required permission, not appearing in `--remote-agent` sessions, where only a `cloud conversations are not enabled` error was shown.

## 1.5.3

- Added each subagent's model next to its name in the subagent rows above the prompt and in `/agents` (hidden on narrow terminals), with the full model and effort in a subagent's detail view, and a `model` field on each `subagents` entry in the status line JSON; `/agents` now shows a single `Tip: Press enter on a subagent to view details.` line instead of repeating `[view details]` on every row.
- Added the `PLUGIN_ROOT` and `PLUGIN_DATA` environment variables to hook commands that come from a plugin, pointing to the plugin's folder and its persistent data folder, so plugin hooks can use files bundled with the plugin and keep state between runs; `agy plugin validate` no longer warns that these variables are not set for hooks.
- Changed the error shown when Vertex AI reports that the selected model does not exist or that your Google Cloud project cannot use it, which now reads `The requested model was not found, or your project does not have access to it.` instead of the raw API error.
- Improved the plugin sign-in screen in `/plugin`, which now indents the sign-in link like the surrounding text and sets it apart with a blank line, no longer underlines trailing blank space in wrapped links, and uses the plugin's display name from `plugin.json`, such as `Canva` instead of `canva`.
- Improved `agy plugin validate` so the `category` field in `plugin.json` is accepted instead of reported as an unknown field, with a warning only when it is not a non-empty string.
- Improved auto-generated conversation titles, which now keep abbreviations and acronyms from your request as written instead of guessing what they stand for.
- Fixed `agy plugin uninstall`, `agy plugin enable`, `agy plugin disable`, and uninstalling from `/plugin` failing for plugins installed as symbolic links, such as plugins installed from Antigravity, or for plugins whose names contain spaces or symbols such as `c++-tools`, and `agy plugin list` shows symlinked plugins again.
- Fixed agent turns failing with `http2: timeout awaiting response headers` when the model took more than 60 seconds to start responding, which are now retried.
- Fixed every model request failing with a 404 error when an enterprise model gateway URL ended in `/v1beta`, even though the model list loaded; a trailing `/v1beta` in the gateway URL is now ignored.
- Fixed the agent's requests to sign in to a plugin being dropped from the conversation, so when a plugin needs a sign-in the CLI now shows a line such as `⚠ The <plugin> plugin needs you to sign in. Open /plugin to sign in.`
- Fixed the agent's file tools mishandling text that is not UTF-8, mostly on Windows: reading a UTF-16 or legacy code-page file now returns its text instead of treating it as binary, edits keep a file's UTF-8 byte order mark or UTF-16 encoding, and PowerShell scripts (`.ps1`, `.psm1`, `.psd1`) with non-ASCII text are written with a UTF-8 byte order mark so Windows PowerShell 5.1 reads them correctly.
- Fixed a message sent during a turn with the `Send Immediately` queued-messages mode briefly disappearing from the conversation and reappearing when it arrived just as the turn ended.
- Fixed hooks receiving a placeholder or empty model name when the session uses a custom model, so hooks now get the name of the model actually in use.
- Fixed files larger than the remote read limit being silently cut off in `--remote-agent` sessions, which now load in full up to 20 MiB and report an error above that instead of showing partial content.
- Fixed `agy acp` sessions exiting before the agent backend finished shutting down when the client closed the connection, which could interrupt saving conversation data.
- Fixed a security issue where a command run in the terminal sandbox could change environment state later loaded by persistent terminal commands run outside the sandbox, and hardened persistent terminal IDs against path traversal.
- Fixed garbled characters in tool-call summaries when the CLI shortens file paths that contain non-ASCII characters.
- Fixed paths that share a prefix with your home directory, such as `/home/alice` when your home is `/home/al`, showing with a mangled `~` prefix in the `/context` file list and the keybindings reset hint.

## 1.5.2

- Added skills from the cloud plugins you connected with `/plugin` to `--remote-agent` sessions, so they now appear in the `/` menu and can be typed at the start of a message, `/skills` lists them grouped by plugin under `Remote agent skills`, and `/skills reload` lists them again.
- Changed the default for macOS Option-key shortcuts such as `alt+m`, which now work out of the box without setting Option to act as Alt in your terminal, where previously pressing them did nothing or typed a character such as `µ`; set `AGY_CLI_MAC_OPTION_AS_ALT=0` to go back to the old behavior.
- Changed `--dangerously-skip-permissions` so commands on the system command denylist are blocked instead of approved automatically, while every other command still runs without asking.
- Changed `agy -p --dangerously-skip-permissions` so headless runs deny terminal commands or file access outside the workspace that your Gemini Enterprise administrator requires to be reviewed, instead of approving them automatically.
- Changed prompts for reading a file outside the workspace in `--remote-agent` sessions to offer always allowing or denying that path for the conversation or in remote settings, instead of toggling local non-workspace access.
- Improved `agy -p` runs so they no longer make a background model request to generate a conversation title that print mode never shows.
- Improved Remote Control connections, which now retry a brief network or server error while setting up a new connection instead of dropping it.
- Improved `agy plugin validate` so an unknown field under `extensions["com.google.antigravity"]` in `plugin.json` is reported as a warning that the field is ignored instead of an error, and the plugin's other extension settings are still checked.
- Improved protection against malicious plugins: `agy plugin` import, install, uninstall, enable, and disable now reject plugin names that are not safe file names with `invalid plugin name`, and refuse to write outside the plugins folder or through symbolic links, so an imported plugin can no longer overwrite other configuration files such as `mcp_config.json`.
- Improved protection against untrusted repositories: plugins and skills listed in a workspace's `.agents/plugins.json` or `.agents/skills.json` now load only from inside the workspace or its repository root, and entries that point elsewhere through absolute paths, `../`, or symbolic links are skipped.
- Fixed subagents stalling for about 60 seconds on file permissions under `--dangerously-skip-permissions`, so reads and writes outside the workspace now go through without a prompt, and headless `-p` runs with the flag no longer wait on any remaining interaction, while your explicit deny rules still apply.
- Fixed signing in to an MCP server that uses OAuth failing with `Invalid PKCE code_verifier` when the server reconnected during sign-in, such as when `/mcp` reloaded servers or a new turn started, so the sign-in link you already opened keeps working.
- Fixed MCP tools that declare their own `explanation`, `toolSummary`, `toolAction`, or `waitForPreviousTools` parameter receiving calls without that argument, so the value the model sends now reaches the tool.
- Fixed the agent re-running a failed turn in a rapid loop when messages were queued at the moment it hit an error, so queued messages now wait for your next message.
- Fixed the `/` menu listing the commands and skills of a default agent instead of those of the agent the session actually runs, so in `agy acp` sessions it now shows that session's agent, including a custom agent's commands.
- Fixed adding PDFs, other binary files, or files larger than about 8 MB to a remote project from `/projects` in `--remote-agent` sessions, which failed and now upload successfully.
- Fixed voice dictation in Chinese and Japanese showing a space between every character in the live draft before the final transcript arrived, and fullwidth Latin words losing the spaces between them.

## 1.5.1

- Changed `agy acp` to offer every model available to your account to every ACP client, where previously only a fixed list of editors were offered models other than Gemini.
- Changed the tabs in `/config` during `--remote-agent` sessions from `Local` and `Remote` to `TUI` and `Remote Agent`, so it is clear that one configures the terminal UI and the other the remote agent; the settings on each tab are unchanged.
- Improved how quickly the agent moves on after a terminal command exits while a background process it started still holds the command's output open, which now takes at most about 1 second instead of 5.
- Improved subagent rows above the prompt so a subagent that is blocked waiting on you names the tool it is waiting on, such as `Blocked · AskQuestion`, instead of `Blocked · Processing...`.
- Improved how plugin OAuth credentials are protected in the terminal sandbox: a plugin's real token now replaces its stand-in only in a request's `Authorization` header, so a command can no longer get a website to echo the real token back by sending the stand-in in another header or in the URL.
- Fixed several `agy acp` session bugs: closing, reloading, or resuming a session while a prompt runs now ends that prompt as `cancelled` instead of leaving it hanging, cancelling a prompt no longer also stops the next prompt sent right after it, `session/update` notifications no longer arrive after the `session/prompt` reply for that prompt, and permission requests and question forms now close when they are answered elsewhere or their prompt ends, instead of blocking later prompts or receiving their answers.
- Fixed file edits on Windows failing with `target content not found` in files that use CRLF line endings, so edits now match whichever line endings the file uses and the lines they insert keep the file's line endings.
- Fixed agent-run commands on Windows failing or returning garbled text when their output contains non-ASCII characters, by running Python in UTF-8 mode (`PYTHONUTF8=1`, unless you have set `PYTHONUTF8` yourself) and switching PowerShell's output encoding to UTF-8.
- Fixed stdio MCP servers on Windows leaving their child processes running after the server stops, which could lock plugin folders and make plugin upgrades fail because the files were in use.
- Fixed `agy plugin` commands being unavailable, with no plugin marketplaces listed, when you sign in with Application Default Credentials (`AGY_ADC_AUTH`) or through an enterprise model gateway.
- Fixed the built-in `browser` agent being listed among the agents you can start a conversation with, since it is meant to run only as a subagent, which it still does.
- Fixed copy-on-select and `/copy` inside GNU screen, so copied text now reaches your clipboard and long selections no longer leave stray characters in the terminal.

## 1.5.0

- Added `acp` to `agy --help`: `agy acp` runs the CLI as an Agent Client Protocol (ACP) server over stdio, so editors can use it as their agent, with images and embedded file context in prompts, steering a running turn by sending another prompt, `default`, `accept-edits`, and `plan` session modes, `session/resume` restoring a session without replaying its history, each session keeping its own model and thinking level, and Google sign-in from a terminal with `agy acp --login` for editors connected over SSH or without a browser.
- Added `--remote-agent` to `agy --help`, which runs the session's conversations on remote agents instead of this machine, where `--project` names a remote project by ID or name and otherwise conversations open in your default remote project; in these sessions `@`-mention completion now searches the remote agent's files, artifacts that can't be shown in the terminal get an `Open in browser` link, the header shows `remote workspace` instead of your local directory, the `/` menu no longer offers skills from this machine, and the Remote tab in `/config` shows the conversation's own permission preset when it has one.
- Added local projects to `/projects`, so in a local session you can list your projects with the current one marked, create one from a name and a set of folders given as absolute, `~`, or workspace-relative paths, rename a project or change its folders, and switch to a project, which adds its folders to the workspace and starts a new conversation.
- Added sign-in for a partner plugin's MCP servers when you install it from `/plugin`, with a `Connect <plugin>` screen for each server that opens its sign-in page (`Esc` skips), a `⚠ needs sign-in` marker and a `Sign-in:` row for the plugin in the Installed tab, and the third-party developer tools notice for partner plugins at the end of the Discover list, in a plugin's details, and after `agy plugin install` or `/plugin install`.
- Added a built-in `${HOME}` variable to plugin `sidecar.json` templates, so a sidecar can name paths under the user's home directory in `workspaceUris` and `accessGrants`, such as `file://${HOME}/worktrees`; a sidecar argument named `HOME` still takes precedence.
- Changed headless `-p` runs without `--print-timeout` to wait for background tasks to finish, where they previously stopped them after a hidden 30-minute limit and exited with success; when `--print-timeout` cuts a turn short, the run now exits with code `3`, prints an `AGY_ERROR` line naming the tasks it terminated, and writes a `[agy] print timeout after ...` line to stderr.
- Changed `/btw` side questions to be able to call tools, such as reading files or searching, showing each call live in the `/btw` card and a `Called N tools` summary once the answer is done, while any tool call that would ask for permission is denied automatically; this fixes side questions failing with an empty-response error when the model wanted to use a tool.
- Changed the `no flickering (altscreen)` option under `Rendering Mode` in `/config` to `full screen (altscreen)`; the saved setting is unchanged.
- Improved the error for a stdio MCP server whose command isn't installed, which now says, for example, `"uvx" is not installed or not on PATH, install it or set "command" to its full path` instead of a raw `executable file not found in $PATH` error.
- Improved Auto mode's review of commands that would leave the terminal sandbox so it times out and asks less often on safe commands, such as uploads that don't request a review, stopping a job the agent started, installing or removing packages from a registry, and removing files that can be restored from version control.
- Fixed `/diff` drawing an empty `↕ ···` fold divider at the top of new files and of edits starting at line 1, where nothing was folded away, and fixed undo in the prompt bringing back a message you had already sent, and undo in `!` shell or `:` search mode bringing back prompt text that `Enter` would then run as a command or search.
- Fixed conversations using a `GEMINI_API_KEY` re-sending a prompt forever when the API's safety filter blocks it, which now ends the turn with a content-filter message, and the `pro` and `flash` subagents on that connection running models two generations older instead of Gemini 4 Argon and Gemini 3.8 Flash.
- Fixed certain models failing a turn on rate-limit (`429`) and server (`5xx`) errors instead of retrying them, now honoring the server's `Retry-After` header, and fixed plugin auto-upgrades of a plugin installed under a different folder name, such as after a rename, writing to a new folder and retrying on every startup instead of updating the existing folder in place.

## 1.4.12

- Added `"optional": true` for API key providers in a plugin's `auth.json`, for services that work without a key but raise rate limits with one: when you haven't set the key, the plugin's commands now see the variable as unset and make unauthenticated requests at the free rate limit, instead of failing with `401` errors or asking you to sign in.
- Fixed Markdown tables in long streaming replies leaving misaligned borders and repeated text in your terminal scrollback: a table's rows now stay in the live view until the table is complete, so they reach scrollback with their final column widths.

## 1.4.11

- Added a billing model choice after you sign in with Google Cloud, so you can pick either a Gemini subscription or Pay As You Go.
- Added `terminationBehavior` to `PreInvocation` hooks: returning `"terminate"` stops the turn before the model is called, for example to block a prompt that contains sensitive data, and hooks can now inject an `errorMessage` whose `userMessage` is shown to you without being sent to the model, which also makes a `-p` run exit with a non-zero code.
- Added a `finished_reason` field to the result of `--output-format json` and `stream-json` runs that says why a turn ended early, `print_timeout` when `--print-timeout` expired and the response is partial, `interrupted` when the run was canceled such as with `Ctrl+C`, or `error` for any other failure, so scripts can tell a cut-off answer from a complete one; the field is omitted when the turn finishes normally.
- Improved the `/plugin` Discover tab for long shelves: each shelf now shows its first 6 plugins followed by a `⋯ N more — enter to show` row, `Ctrl+E` expands or collapses the shelf under the cursor, and `[` and `]` jump to the previous or next shelf.
- Fixed `agy plugin import claude` printing `No claude extensions found.` for plugins installed from a Claude Code marketplace: it now reads Claude Code's list of installed plugins, skipping plugins disabled in Claude Code's settings and plugins installed for a single project only, and imported plugins now keep their remote MCP servers (`"type": "http"` with `url` and `headers`) and servers from `.mcp.json` files without an `mcpServers` wrapper, expand `${CLAUDE_PLUGIN_ROOT}` to the installed plugin's directory, and list servers that can't be converted, such as ones using the legacy SSE transport, with a warning instead of reporting them as installed.

## 1.4.10

- Improved streaming of agent replies: lines that scroll off the top of the screen are now scrolled into your terminal's scrollback instead of repainting the whole screen, and text wrapping writes whole runs of text at a time, so streaming writes about 70% fewer bytes to the terminal and stays much smoother over slow SSH connections.
- Improved memory use shortly after startup: the CLI now returns about 100 MB of memory left over from startup to the operating system 15 seconds after the interactive UI opens; print and headless modes are unaffected.
- Improved the after-compaction size shown in the compaction marker and in `/context` to also count what the summary carries into the next prompt, such as your earlier requests and artifact, subagent, and running-task snapshots, so it is closer to the real size; the `(N summary)` label still shows the summary alone.
- Fixed subagents losing the task their parent agent gave them, and the parent's ID, after their context was compacted, including with `/compact`; a subagent's summary now keeps the parent agent's 10 most recent messages.
- Fixed conversations with many or large images, such as screenshots or pasted images, being rejected for exceeding the model's request size limit: images are now capped at 2000 pixels per side and large PNGs are sent as JPEGs when that is much smaller, and an image saved as JPEG but labeled PNG, such as a pasted image or browser screenshot, is no longer rejected for a mismatched type.
- Fixed the `/browser` subagent not receiving the current page's snapshot when the selected page belongs to an isolated browser context, such as a page opened with `isolatedContext` or attached from an Incognito window.

## 1.4.9

- Added image pasting through your terminal's own paste shortcut, such as `Cmd+V` or `Ctrl+Shift+V` with only an image copied, and by dragging image files into the prompt, which attaches them instead of inserting their paths; image paste now also works over SSH with X11 or Wayland forwarding, and the CLI's paste key now says `No image or video found in the clipboard` when there is nothing to attach and names the clipboard tool to install, such as `wl-clipboard` on Wayland, when one is missing.
- Improved the `/plugin` Discover tab to group marketplace plugins into the same sections as the Antigravity plugin marketplace instead of one flat list, listing a plugin under every section it belongs to.
- Improved `agy plugin validate` to warn when a plugin's `name` isn't lowercase kebab-case, such as `Neo4j` or `foo_bar`, which the marketplace can't publish, and to suggest a valid name, failing under `--strict`; it now also checks the plugin's `logo`, noting when `plugin.json` has none and warning when the logo path is blank, uses backslashes, is absolute or points outside the plugin, sits in a folder the marketplace bundle leaves out such as `.github/`, or is a URL that won't be shown, with the same checks for context provider `iconUri` values.
- Improved the position indicator under long `/diff` lists to say what it counts, such as `[1-44 of 195 files]` in `All Changes` and `[1-44 of 195 rows]` in `Per Turn`, where turn headers count as rows, so it no longer appears to disagree with the file count.
- Improved Auto mode's review of commands that would leave the terminal sandbox: the reviewer now knows whether the working directory is inside a Git or other repository, so it no longer spends its time budget running `git status` in folders that aren't repositories and times out less often.
- Changed `execute_url` permissions so approving a Google site such as `www.google.com` or `cloud.google.com` no longer also allows sensitive Google apps such as `mail.google.com`, `docs.google.com`, `drive.google.com`, `accounts.google.com`, or `console.cloud.google.com`; each of these now needs its own approval.
- Fixed always-allow rules for multi-line commands, such as a `python -c` or `node -e` script spanning several lines, never taking effect, which made the CLI ask again every time and pile up unusable entries in your settings; existing multi-line rules now apply.
- Fixed onboarding screens being cut off in small terminals and hiding their buttons: text and links now wrap to the terminal width, the color preview is cropped or hidden in very narrow terminals, the banner only shows when the whole step fits, and a step that is still too tall scrolls with `Shift+↑`/`Shift+↓` or `PgUp`/`PgDn` while the buttons stay visible.
- Fixed Vim mode's `r`, `f`, `F`, `t`, and `T` canceling when the target character is a space, so `r<space>`, `f<space>`, and `df<space>` now work, commands on an empty last line acting on the line above, and a half-typed operator such as `d` carrying over after you submit a prompt.
- Fixed invisible U+FFF9 and U+FFFA characters reaching the terminal around wrapped code in agent replies, which made some terminals and multiplexers draw boxes or leave stale characters on screen.
- Fixed conversations failing every later model request with `INVALID_MEDIA` after the agent viewed a corrupt image or one with text in front of its header, such as a screenshot captured with `adb exec-out screencap -p > screenshot.png` that also captured a warning; such images are now rejected with an error that says where the real image header starts, so the agent can fix the command.
- Fixed conversations getting stuck failing on every turn after a tool result was left without its matching tool call, such as after older history was trimmed; unmatched tool calls and results are now left out of the request.
- Fixed conversations with certain models on a Google Cloud project failing for the rest of the conversation once the system prompt, tools, or an earlier message changed after a thinking block; outdated thinking blocks are now dropped instead of rejected.
- Fixed the `/browser` subagent not receiving the current page's snapshot at the start of each turn with Chrome DevTools MCP 1.11 and later, because the snapshot request left out the now-required page ID and failed silently.

## 1.4.8

- Added `[` and `]` to the `Per Turn` tab in `/diff` to jump to the first file of the previous or next turn, wrapping around at either end, in both the file list and the file view; the `All Changes` and `Per Turn` key-hint footers now wrap onto a second row on narrow terminals instead of being cut off.
- Improved how quickly `/diff` opens in large repositories and long conversations: `All Changes` and `Commit Tree` appear as soon as tracked changes are ready, showing `checking for untracked files…` while untracked files load in the background, and `Per Turn` shows the newest turns first and loads older ones in the background with a `checking N older turn(s)…` indicator, caching finished turns so reopening `/diff` only recomputes the latest one.
- Improved `/diff` in checkouts with large untracked files: binary files and untracked files over 1 MB are listed with a note such as `binary file` or `7.3 MB, over the 1 MB limit` instead of being read into memory, untracked files containing lines that start with `++` followed by a space are no longer shown incorrectly, and a file deleted while `/diff` is loading no longer makes the whole file list fail.
- Improved Auto mode's review of commands that would leave the terminal sandbox: it now has more time to decide and stops any single slow check after 10 seconds, so it times out less often and asks you to approve safe commands less often.
- Improved `agy plugin install` output to name each installed skill, agent, rule, command, MCP server, and hook, to stop listing component types the plugin doesn't contain as skipped, and to print the folder the plugin was installed to, adding `(replaced existing installation)` when it overwrote an earlier copy.
- Improved `agy plugin validate` to check the `author`, `homepage`, and `repository` fields in `plugin.json`, warning when `author` is neither a name string nor a `{"name", "url"}` object or when a URL isn't a valid `https://` link, and plugin listings now show the author's name when `author` is written as an object instead of leaving it blank.
- Improved resuming a conversation to use about 10% less CPU by not rendering already finished tool calls a second time.
- Fixed failed tool calls, including calls to a tool that doesn't exist and canceled or interrupted calls, being passed back to the agent as ordinary results; the agent now sees them as errors and can recover on its next step.
- Fixed conversations forked from one with an active `/goal`, including `/btw` side questions and forked subagents, inheriting that goal and being unable to stop; the inherited goal is now canceled at the fork point.
- Fixed subagents failing to run when their custom agent's `name` contains a colon.
- Fixed deleting a conversation leaving its running subagents, their saved history, and their shared or branched workspaces behind; they are now stopped and cleaned up with it.
- Fixed a memory leak in long sessions with plugins that run sidecars, where every sidecar run left a background task running for the rest of the session.
- Fixed pasting images on Windows when they were copied from a browser, Snipping Tool, or another app that puts PNG or V5 bitmap data on the clipboard, and pasting now retries when another app briefly holds the clipboard.

## 1.4.7

- Added `lastUserInput` to the JSON that hook commands receive on stdin, so a hook can inspect the latest message you sent, for example to screen prompts before the agent acts on them.
- Added a temporary opt-in Halloween theme: turn on `Seasonal Themes` in `/config`, a row shown only while the theme is in season, for a Halloween startup banner, a moon-phase spinner, and a themed running light and prompt box borders.
- Improved Auto mode to ask for approval less often on routine commands, such as cleaning up temporary files, stopping a local process, or running a code formatter.
- Improved headless `-p` runs to use much less CPU, especially for long answers and when you have many saved conversations: they no longer build the conversation search index or render the transcript for display, and no longer start your custom status line and window title commands, none of which print mode shows.
- Improved rendering speed while a response streams, when a permission prompt appears, and when you resize the window.
- Improved MCP tools that are loaded on demand to return results of up to 10 KB directly to the agent; previously anything over 4 KB was saved to a file that the agent had to read in an extra step.
- Improved the `/help` shortcuts tab by leaving out basic navigation keys such as the arrow keys, so the more useful shortcuts are easier to find.
- Fixed skills, rules, custom agents, plugins, plugin MCP servers, and hooks not loading when you sign in with Application Default Credentials (`AGY_ADC_AUTH`).
- Fixed conversations compacting over and over when a single message, tool output, or attached document was too large to fit in the context.
- Fixed long links that wrap inside a Markdown table cell being linked only on their first line, to a truncated URL, so the whole link can now be clicked or copied. Tables in the default `Terminal` color scheme now use box-drawing borders instead of ASCII `|`, matching the other color schemes.
- Fixed copying a long command that wraps across rows in a code block or inline code, which now copies as a single line instead of with a line break at each wrap point; wrapped code-block lines also now break between words and keep the block's indentation.
- Fixed Vim mode's `r` replace, in Normal and Visual mode, leaving part of a collapsed `[Pasted text #N]` placeholder behind; the whole placeholder is now replaced.
- Fixed plugin and MCP server sign-ins not being saved on macOS and Windows when the token was too large for the system keychain; such tokens are now stored in the CLI's private secrets file.
- Fixed plugin MCP servers that sign in with OAuth being able to use a token saved by another user of the same computer account, or keeping the previous user's connection after you switch accounts or sign out. Their tokens now belong to the signed-in user and these servers reconnect when the user changes, so you may need to sign in to them again.

## 1.4.6

- Added a `Configure MCP servers...` row for installed plugins in `/plugin`, so you can set or change a plugin's MCP server variables at any time without disabling and re-enabling it; plugins with missing values show `⚠ needs setup`, each server shows `✓ configured` or the variables it still needs, and saving restarts an enabled plugin's servers so the new values take effect.
- Improved terminal sandbox defaults to protect more credentials: sandboxed commands can no longer read or modify `~/.docker`, `~/.kube`, or `~/_netrc` unless you grant access explicitly. Previously `~/.docker` and `~/.kube` were writable inside the sandbox, so sandboxed commands that use Docker registry or Kubernetes cluster credentials now need an explicit grant.
- Improved context compaction, including `/compact`, to keep images, PDFs, and other files you attached in the conversation summary, so the agent can still see them after older history is summarized.
- Improved permission prompts so that allowing an action for the conversation, in the main agent or in a subagent, applies across the main conversation and all of its subagents instead of asking again for the same action.
- Improved the in-progress status line to show what the agent is waiting on, such as initializing MCP servers or retrying an unavailable model (for example `Model unavailable (attempt 2/10), retrying in 12s` with a live countdown), instead of a generic working label.
- Improved `/diff` to highlight the exact words that changed within each modified line, in every color scheme.
- Improved `agy plugin validate`: it now has `--help`, checks a plugin's context providers (missing `label` or `command`, invalid or duplicate triggers, unknown fields, missing command files), warns about `skills` entries in `plugin.json` that don't exist or contain no `SKILL.md`, and reports every `SKILL.md` the plugin loader skips, including skills listed through `plugin.json` or `skills.json`.
- Fixed terminal commands occasionally failing to start with `argument list too long` when the model returned a very large reasoning signature with the tool call.
- Fixed text cursors drifting away from the insertion point after wide characters (CJK, emoji), tabs, other Unicode spaces, and on soft-wrapped lines, including `Up`/`Down` landing on the wrong row, in the prompt and in the settings, permission amend, plugin setup, feedback, hooks, and artifact search boxes.
- Fixed the `Esc disabled during file edits` warning naming the wrong reject key when the prompt shows an extra choice, such as for edits outside the workspace in accept-edits mode.
- Fixed sign-in not persisting across restarts on macOS and Windows for enterprise accounts, because the saved credential exceeded the system keychain's size limit.

## 1.4.5

- Improved how agent responses read: a blank line now separates the collapsed thought block from the response, and once the response starts, the collapsed thought shows only its `Thought for …` header instead of repeating a snippet of the thinking; expand it to see the full thinking.
- Improved `/` search in the `/diff` file view to count matches inside folded unchanged lines, such as `match 2/5 · +3 hidden` or `no matches · +1 hidden`, and the `f` hint now reads `show N hidden matches`.
- Improved `/diff`'s `Commit Tree` to mark the selected commit with the same `>` cursor and selection color as `All Changes` and `Per Turn` instead of a highlighted bar, and made `Per Turn` start with the cursor on the first file instead of its turn header.
- Improved recurring cron schedules created with the agent's `schedule` tool to fire at a consistent per-schedule offset instead of exactly on the cron boundary, to avoid traffic spikes: schedules that repeat within a day, such as every 30 minutes or hourly, now fire somewhere within their period, fixed-time schedules such as daily at 9:00 still fire within their scheduled minute, and the agent can request exact timing when a schedule needs it. `@every` schedules are unchanged.
- Improved idle CPU usage by pausing screen refreshes while nothing on screen changes, roughly halving the CLI's CPU use when it is idle.
- Improved CPU usage while a response streams by skipping redundant screen updates and refreshing the credit balance less often.
- Improved rendering speed for long conversations, and made long conversations load faster when you resume them.
- Improved startup CPU usage when the CLI refreshes its conversation summaries.
- Improved memory usage by allocating storage for the prompt and other text inputs as you type instead of reserving it up front.
- Fixed the agent silently retrying, potentially without end, when a model response was blocked by content safety filters.
- Fixed plugins failing to load when `plugin.json` gives `skills` as a single path string, such as `"skills": "./skills/"`, instead of an array, as some plugins written for other tools do.
- Fixed marketplace plugin installs and automatic updates failing with a checksum mismatch or network error when a download was briefly stale or interrupted; the CLI now retries the download once.

## 1.4.4

- Added Auto mode on Windows 11 version 24H2 and later for personal Google Accounts, selectable via `--mode auto`, `Agent Mode` in `/config`, `Shift+Tab`, or Remote Control Settings (`Agent` remains the default).
- Added whole-file toggle (`f`) and hunk folding (`Ctrl+O`) to `Commit Tree` and `Per Turn` views in `/diff`, and consolidated `Per Turn` diffs so multiple edits to a file in one turn appear as a single combined diff.
- Added `_meta["antigravity.google/root_conversation_id"]` to MCP `tools/call` requests so MCP servers receive the top-level conversation ID even when a tool is called from a nested subagent.
- Improved Auto mode's review of commands that leave the terminal sandbox to include the assistant's preceding question on short replies like `yes`, check every subcommand in pipelines, and prompt before destructive Git or file commands.
- Improved `agy plugin validate` with stricter checks across `plugin.json`, MCP server configs, `hooks.json`, and sidecar manifests for invalid JSON syntax, unknown fields, bad variable placeholders, unrecognized hook tool matchers, and missing hook scripts.
- Improved CPU and memory usage while streaming responses by caching streamed code-block syntax tokens, rendered Markdown blocks, and inline file-edit confirmation diffs across frames.
- Improved `/compact` and automatic compaction to retain tool declarations on summarization requests so the model API reuses its cached prompt prefix.
- Improved Remote Control on tablets and foldables to use the multi-pane layout with touch-sized controls instead of collapsing to the phone view, and kept popovers open while dragging scrollbars.
- Fixed subagents losing plugins inherited from the parent session, and fixed plugin-bundled subagents with `plugins.inherit_user: false` and restricted MCP tools failing to start with `mcp spec not found for provider`.
- Fixed rules and `SKILL.md` skills loading twice when discovered from both a standalone customization folder and an enabled plugin.
- Fixed long rows wrapping instead of truncating at the terminal width in `/diff`'s `Commit Tree` and `Per Turn` lists, and `Per Turn` headers truncating prompts at 50 characters.
- Fixed the prompt box staying mid-screen after closing panels, dropdowns, or inline prompts, and blank gaps appearing above the prompt in `Medium` verbosity mode.
- Fixed `Ctrl+Z` undo in the prompt mishandling pasted text, merging typing with recalled history entries, recording no-op `Backspace` or `Delete` steps, and truncating characters near emoji.
- Fixed MCP client sessions and background connection routines leaking when `tools/list` failed during server startup or when the CLI shut down while a server was connecting.
- Fixed the system prompt's user rules wording so `GEMINI.md` and `AGENTS.md` rules explicitly override earlier built-in instructions instead of only instructions that follow them.
- Fixed supported media attachments with parameterized MIME types such as `audio/webm; codecs=opus` being rejected as unsupported.
- Fixed several UI issues in Remote Control, including clipped headers and dialogs on phones, iOS Safari zoom on input focus, `Enable Telemetry` and `Marketing Emails` reverting while Settings loads, and dragged URLs losing query or `#` parameters.
- Fixed rendering and export bugs in Remote Control, including broken nested code blocks, `$VAR` shell variables parsed as LaTeX, broken media previews, blurry or blank diagrams in `Copy Image` and `Export as PDF`, and background-tab timer drift.

## 1.4.3

- Added `/` search to the `/diff` file list and file view: matches are highlighted as you type, the search prompt shows how many matches the diff and each file contain, `Enter` jumps to the first match, and `n`/`N` step through matches one at a time across every file, with `match A/B` in the file view header. `n`/`N` in the artifact viewer now also step through matches one at a time, including several on the same line, instead of jumping from line to line.
- Improved `agy plugin validate` to also check a plugin's hooks, sidecars, and component lists: it reports an error when `hooks.json`, a `sidecar.json`, or a `skills.json`, `rules.json`, `agents.json`, or `sidecars.json` file can't be parsed, and warns about unknown hook events, hook matchers that aren't valid regular expressions and so never match, a `hooks/hooks.json` file (which isn't read), list entries with no path or with a path missing from the plugin, `commands/` folders and `workflows/` Markdown files (which plugins don't load), and a Claude Code-style top-level `"hooks"` key, which loads as a single hook named `hooks`.
- Improved timer labels in `/tasks` and the active task list to show durations in days, hours, minutes, and seconds, such as `1d 2h timer` or `5m timer`, instead of raw seconds such as `93784s timer`.
- Fixed Gemini 4 Argon not shown in `/model` and `--model` when you connect with a `GEMINI_API_KEY`.
- Fixed the CLI offering options that need the terminal sandbox on systems where it can't run, such as Linux systems that block unprivileged user namespaces and Windows before Windows 11 24H2.
- Fixed subagents and custom agents in Auto mode asking you to approve every command that would leave the terminal sandbox; like the main agent's, their commands are now first reviewed by a separate agent, so safe commands run without asking and risky ones still prompt you.
- Fixed the agent losing track of its most recently started subagents after a conversation was compacted, because the summary included each subagent's full initial prompt and was cut off before their conversation IDs; the summary now keeps only each subagent's type, role, and result, which also leaves more room in the context window.
- Fixed a `PostToolUse` hook that fails to run, for example because its command is missing, exits with an error, times out, or prints invalid JSON, marking the tool call it follows as failed even though the tool succeeded; the failure is now logged and the tool keeps its result.
- Fixed the agent failing to create empty files such as `__init__.py` or `.gitkeep`, and failing to write or edit regular project files with `... is not a valid artifact path` when the model sent blank artifact details.
- Fixed updating or reinstalling a marketplace plugin on Windows leaving it half-deleted when another `agy` session, the Antigravity desktop app, or the Remote Control background service had it open; the installed plugin now stays intact until the new copy is in place, and the previous version is restored if the replacement fails.
- Fixed `agy plugin install` and `agy plugin import` writing color codes into piped or redirected output, ignoring `NO_COLOR`, and showing raw codes in older Windows consoles; like `agy plugin validate`, they now use color only in a terminal and follow `NO_COLOR`, `CLICOLOR`, and `CLICOLOR_FORCE`.
- Fixed Remote Control on iPhone and iPad asking you to accept the `Security Notice & Data Use` terms and showing the `Enable Notifications` prompt again every time you reopened it; it now remembers your answers, along with your theme, layout, and dismissed tips.
- Fixed the prompt cursor appearing in the wrong place after resizing the terminal (sometimes on the `↑ N more lines` indicator or below the input box), when a slash command's completion hint didn't fit on the last line of the prompt (the hint is now shortened or left out), when the prompt was taller than the terminal, after pressing `Up` or `Down` onto a line with CJK characters or emoji, and after entering Vim visual mode, which also rewrapped the text.
- Fixed the cursor drifting on lines with emoji such as 👩‍💻, 👍🏽, or ⚠️ inside tmux 3.6 and later, and after returning from your external editor (`Ctrl+G`) or a `Ctrl+Z` suspend in terminals that support grapheme-cluster widths.
- Fixed the cursor drifting and lines wrapping too early under Japanese, Chinese, or Korean locales such as `LANG=ja_JP.UTF-8` when text contains characters like `→`, `…`, `─`, or `•`, which parts of the CLI counted as two columns wide while the rest drew them as one.
- Fixed `Left`, `Right`, `Backspace`, and `Delete` in the prompt and other text boxes moving over or deleting only part of an emoji such as 👩‍💻 or 👍🏽, a flag, or a letter with a combining accent, and fixed text boxes cutting off a wide character, such as a CJK character or emoji, at the end of a wrapped line instead of moving it to the next line.
- Fixed lines containing combining marks or other zero-width characters wrapping too early or leaving blank rows in `/diff` and the inline diff preview, and being cut off with `…` too soon in `/artifact` previews.

## 1.4.2

- Fixed conversation history not showing in Remote Control in daemon mode.

## 1.4.1

- Improved `agy plugin validate` to also check a plugin's skills, subagents, and rules: for skills, it errors on a `SKILL.md` with missing or invalid frontmatter and warns when `name` or `description` is missing, when `name` doesn't match its folder, when the body is over the 24 KB limit, or when a skill in `skills/` is skipped because an earlier skill has the same name; for subagents, it errors on an `agents/` Markdown file with invalid frontmatter or a missing `name` or `description`, an unparseable `agent.json`, or a name reserved for a built-in agent, and warns on duplicate agent names, Markdown files in `agents/` without frontmatter, and `agent.json` files, which the CLI ignores; and for rules, it errors on a rule with invalid frontmatter or without a valid `trigger` (skipping a `README.md` in `rules/` without frontmatter), and warns on a `model_decision` rule without a `description`, a `glob` rule without `globs`, content cut to fit the 24 KB limit, or an `AGENTS.md` or `GEMINI.md` at the plugin root instead of in `rules/`.
- Improved the inline diff preview when the agent asks to edit or create a file so it renders like the `/diff` file view, with syntax highlighting for your color scheme, background tints on added and removed lines (picked from your terminal's light or dark background when using the `Terminal` color scheme), and an untinted line-number gutter.
- Improved CPU usage while typing and while the agent is working by rendering the prompt area once per frame, reusing measured line widths for unchanged rows across frames, and rendering the animated status line in styled runs instead of one character at a time.
- Fixed `Enable Telemetry` in `/config` remaining editable for Business accounts (such as Google Cloud project and Application Default Credentials sign-in via `AGY_ADC_AUTH`), where prompts, content, and model responses are never collected: the row now shows `off (disabled)` and explains why, and first-run setup with `AGY_ADC_AUTH` now shows the Google Cloud Platform Terms of Service without the consumer telemetry opt-in checkbox.
- Fixed agent commands failing to start on Windows versions that don't support the terminal sandbox (Windows 10 and Windows 11 before version 24H2) when a sandboxed permission mode was selected: the CLI now turns off the terminal sandbox and falls back to asking before running commands, and the Remote Control browser Settings modal hides sandboxed permission options on those systems.
- Fixed socket disconnect errors such as `broken pipe`, `software caused connection abort`, `network is down`, and `http2: client connection lost` (for example after laptop sleep or a Wi-Fi change) stopping the turn with `Agent execution terminated due to error.` instead of retrying automatically and reporting a network error if retries fail.
- Fixed an MCP server continuing to show as `Ready` in `/mcp` after its process exited unexpectedly, which left later tool calls failing with `client is closing: EOF`; the server is now marked as `Error` and its closed session is removed.
- Fixed large structured tool outputs (such as JSON results from MCP tools) bypassing the per-step token limit while still being counted as truncated, which could push long conversations past the model's context window before automatic compaction ran.
- Fixed clickable links in agent responses whose URL contains `;` opening a URL cut off at the first `;` in terminals and multiplexers that split link sequences on semicolons.
- Fixed `/title` and `/remote-control` rejecting `on` and `off` when typed with uppercase letters, such as `/title ON` or `/remote-control Off`.

## 1.4.0

- Added terminal status reporting over OSC 7501: in terminals that support it, the tab or window shows whether the CLI is working, waiting for your input, done, or failed. The CLI checks for support first, so other terminals are unaffected. Set `AGY_CLI_OSC7501=off` to turn it off, `AGY_CLI_OSC7501=on` for a terminal that supports it but doesn't answer the check, or `AGY_CLI_OSC7501_MESSAGES=brief` to show only the status without details such as the pending command or question.
- Added the `alt+m` shortcut (`Option+m` on macOS when Option is set to act as Alt) to send a message using the opposite of your `Queued Messages` setting in `/config`, so you can send right away while in `Queue` mode, or queue a message while in `Send Immediately` mode.
- Improved `agy plugin validate` so it checks a plugin with the same rules the CLI uses to load it, instead of simplified checks that rejected valid plugins (such as a manifest without a `name`) and missed problems that kept a plugin from loading. It lists each error and warning with its file and line, accepts a plugin directory or its `plugin.json`, warns about common `plugin.json` mistakes such as unknown fields (with "did you mean" suggestions), invalid names, and components placed inside `.antigravity-plugin/` instead of the plugin root, and adds `--strict` to fail on warnings and `--json` for a machine-readable report in CI.
- Fixed the CLI refusing every message with `Eligibility check failed` until you restarted it when the service was briefly unavailable or rate-limited at launch; the check now retries temporary errors and no longer locks the session.
- Fixed plugin MCP servers that use a variable in a request header, such as `"Authorization": "Bearer ${TOKEN}"`, sending the literal placeholder and failing to authenticate; headers now get the value you configured, like the server's command, arguments, and environment already did.
- Fixed the `/diff` Commit Tree view: the header now counts commits instead of lines, the cursor stops only on commit rows and `Enter` opens that commit, the view fills the terminal height, and it shows the latest 100 commits (previously 10) with scrolling.
- Fixed the agent losing track of its file changes, tasks, and session cost when a background command finished while the agent kept working; they no longer roll back to the point where that command started.
- Fixed a background command's final output sometimes missing from its task log; the output is now always recorded when the command finishes or is canceled.
- Fixed links to directories disappearing from agent responses; they now show the directory name, for example `pipelines/`.

## 1.3.6

- Added Claude Opus 5.5 and Claude Sonnet 5.5 for Application Default Credentials (`AGY_ADC_AUTH`) sign-in. Claude models now appear in `/model` only if your Google Cloud project can use them.
- Improved Auto mode's review of commands that would leave the terminal sandbox: the review is faster and no longer times out without a decision, it allows the workspace's own format, lint, and fix commands instead of asking about them, and it blocks commands that would upload sensitive data.
- Improved the `/diff` Commit Tree view with colors: commit hashes and change IDs are highlighted, descriptions are dimmed, the `Working Copy (Uncommitted Changes)` row stands out, and `@` is bold, so hashes, timestamps, and descriptions no longer run together.
- Fixed the agent hanging indefinitely when the model connection stalled: if no data arrives for 5 minutes the request is now canceled and retried automatically, and a stalled request no longer leaves an empty response step behind.
- Fixed questions asked by subagents and workflow agents being lost, which left the subagent waiting forever: the alert now reads `<agent> has a question` and shows it, and `Ctrl+K` or `a` in the subagent's view opens a question picker that sends your answer to that agent. Headless `-p` runs skip these questions so the subagent can continue.
- Fixed agent shell commands hanging on an invisible editor when a version control command wants one, such as `git commit` without `-m` or `jj describe`: the CLI now sets `GIT_EDITOR`, `HGEDITOR`, and `JJ_EDITOR` to `false` for agent commands, so they fail right away instead.
- Fixed skills, rules, workflows, and Markdown agents failing to load with `mapping values are not allowed in this context` when an unquoted `description:` contains a colon, such as `description: Runs checks: formatters and linters.`
- Fixed Mermaid diagrams that start with YAML frontmatter, a `%%{init: ...}%%` directive, or `%%` comments, or that use Mermaid v11 syntax such as `id@{ shape: ..., label: ... }` nodes, showing as raw source instead of rendering in agent responses and the artifact viewer.
- Fixed the `@` file-mention dropdown staying open after a newline in a multi-line prompt, where it took over `Up`/`Down` and made `Enter` pick a file instead of inserting the newline.
- Fixed `/` search in the file and artifact viewer highlighting the wrong characters, or crashing, on lines with letters whose lowercase form has a different length such as `İ`; `n` and `N` now stop only on lines that show a highlight.
- Fixed long lines and file paths containing CJK or other multi-byte text turning into `�` characters in `/codesearch` results; they are now cut cleanly with an ellipsis.
- Fixed `agy plugin validate`, the summary `agy plugin install` prints, and marketplace previews in the `/plugin` Discover tab leaving out subagents a plugin declares in its root `agents.json`.
- Fixed plugin names and manifests being case-sensitive where the agent was not: `/plugin` subcommands such as `/plugin List` now work in any case instead of failing with `Unknown subcommand`, and a manifest named `Plugin.json` is now found by `agy plugin install`, `agy plugin validate`, and enable and disable.

## 1.3.5

- Added Auto mode, which approves file edits and safe commands without asking and still prompts before irreversible actions; commands that would leave the terminal sandbox are first reviewed by a separate agent. Choose it with `--mode auto`, from `Agent Mode` in `/config`, or by pressing `Shift+Tab` to cycle modes. Auto mode is available on Linux and macOS, with Windows support coming later.
- Added the `/compact` command to compact the conversation on demand and free up the context window: `/compact` on its own summarizes the conversation and ends the turn, and `/compact <message>` summarizes it and then answers your message. While it runs the CLI shows a `Compacting conversation...` progress label that you can cancel with `Esc`, and when it finishes it shows how many steps were summarized and how much smaller the context became.
- Added syntax highlighting to the `/diff` file view, with token colors for each color scheme and a background tint on added and removed lines. With the `Terminal` color scheme the CLI detects whether your terminal has a light or dark background and picks matching colors. The color scheme previews in `/config` and first-run setup now show a sample exactly as `/diff` draws it.
- Added folding to the `/diff` file view: each hunk header now shows how many unchanged lines are hidden above it, `Ctrl+O` expands or collapses the fold nearest the cursor, and `f` switches between showing only the changes and the whole file. Both keys work on uncommitted changes when the file on disk still matches the diff, and the footer explains when they can't be used.
- Improved `/diff` performance on very large files by rendering only the rows on screen, so scrolling, expanding folds, and opening the whole file no longer freeze the CLI. Expanding folds and showing the whole file are turned off for files over 100,000 lines or 10 MB, and the footer says why.
- Fixed colors being reduced to 256 colors in iTerm2 over SSH, where `COLORTERM` is not forwarded; the CLI now uses full 24-bit color when `LC_TERMINAL=iTerm2` is set, unless `COLORTERM` or `NO_COLOR` says otherwise.

## 1.3.4

- Added a `--json` flag to `agy plugin list` for machine-readable output, and fixed the command showing only imported plugins: it now lists every installed plugin, including ones installed from a marketplace, with its version and whether it is enabled.
- Changed `--model` and `/model` to accept a base model name without `--effort`: instead of failing with an error asking for `--effort`, the CLI now picks the model's default thinking level (the server's default for that model, otherwise medium, otherwise the lowest available).
- Improved Remote Control so the browser's Settings modal opens for CLI sessions and shows the settings the CLI actually uses (project and global permissions, queued messages, AI credits, telemetry, and artifact review) instead of a notice that settings can't be changed in the browser, and `agy remote-control serve` sessions now use your saved `settings.json` and save changes made in the browser back to it.
- Improved the `/model` picker for Business sign-in with a Google Cloud project on pay-as-you-go: third-party models your project can't access are now hidden instead of failing when you send a message.
- Fixed long stalls when model requests fail repeatedly: the agent now waits at most 30 seconds between automatic retries instead of up to 4 minutes.
- Fixed remote MCP servers that use OAuth signing you out after a temporary network failure, timeout, or server error; saved sign-ins are now cleared only when the server or its authorization server actually rejects them.
- Fixed `--agent` silently running the default agent when the name matches no agent: headless `-p` runs now exit with code 1 and list the available agents, and interactive sessions show an `Agent Not Found` warning before falling back to the default agent.
- Fixed combining `--print` with `--prompt-interactive` exiting with status 0 after reporting the conflict; it now exits with status 2 like other print-mode usage errors.
- Fixed `/diff` showing `No uncommitted changes` in Git, Mercurial, and Jujutsu repositories configured to always color output, for example with `color.ui = always`.
- Fixed `@conversation:` suggestions getting stuck on `Fetching matches for ...` when conversation search is slow; after 2 seconds the list now falls back to your local conversations.
- Fixed the `Agents:` row in `/plugin` plugin details leaving out subagents a plugin declares in its root `agents.json`; it now lists every loaded agent by name instead of by its `agents/` folder name.
- Fixed "Always allow" rules approved from a Remote Control browser session still applying after you removed them in the browser's rules editor or the shared tab of `/permissions`; these rules are now saved only to the shared `config.json`.
- Fixed requests failing with `thinking_budget and thinking_level are not supported together` when signed in with Application Default Credentials and using a model that has a thinking level.
- Fixed a conversation failing on every later request after the agent read a truncated or header-only WebM file; such files are now rejected when read instead of being attached.

## 1.3.3

- Added a pinned prompt header in no flickering mode while you scroll back through a long conversation: the prompt that produced the response you're reading stays at the top of the transcript, and clicking it jumps back to that prompt.
- Added support for MCP servers to mark a tool as always loaded by setting `_meta: {"antigravity/alwaysLoad": true}` on it in their `tools/list` response, so the agent gets that tool directly instead of discovering it on demand.
- Added support for a root-level `agents.json` in plugins, so a plugin can declare its subagents the same way it declares skills and rules with `skills.json` and `rules.json`.
- Changed the macOS terminal sandbox to block sandboxed commands from reading `~/Library/Application Support` by default, since desktop apps keep credentials and session tokens there; previously it was readable, and you can still allow it explicitly in your sandbox rules.
- Improved error messages: a request that fails with an HTML error page, for example from a corporate proxy, now shows the page title instead of the raw HTML, other long non-JSON error bodies are cut off after 500 bytes, and reaching your individual quota is reported right away instead of being retried.
- Improved search in the `/plugin` Installed tab: you can now type spaces in a search query, press `Enter` to finish searching, then use `Space` to toggle the selected plugin and `Enter` to expand its details; start typing again to resume the search.
- Fixed an expired or revoked sign-in showing an unclear error mid-session; the agent now says `Authentication expired. Please log back in.`, and a token refresh that was already in flight no longer restores the expired credentials.
- Fixed `/add-dir` claiming it added a path that doesn't exist or isn't a directory; it now reports `directory not found` or `not a directory`.
- Fixed `/btw` side questions running your user and workspace hooks, which could make hooks such as stop hooks loop or add extra steps to a quick question.
- Fixed Jujutsu (`jj`) commands run by the agent, such as `jj diff` or `jj log`, hanging in an interactive pager; agent commands now set `JJ_PAGER=cat` alongside `PAGER` and `GIT_PAGER`.
- Fixed subagents started with a `branch` or `share` workspace in a multi-repository workspace silently working in your real checkout; each repository now gets its own isolated copy.
- Fixed a stopped subagent staying in the active agents list while it still had an approval pending; stopping it now clears its pending approvals right away.
- Fixed `--remote-control` failing when you sign in with Application Default Credentials (`AGY_ADC_AUTH`); Remote Control doesn't support ADC yet, so the flag now exits with a clear error and the `/remote-control` command is hidden.
- Fixed custom `alt` keybindings such as `alt+s` not working with the macOS Option key in terminals that don't treat Option as Meta, such as Terminal.app and VS Code-based terminals.
- Fixed `/keybindings` silently doing nothing when the configured editor can't be found; it now shows an error.
- Fixed `agy plugin validate` and plugin listings missing skills declared through the `skills` field in `plugin.json` or ignoring `skills.json` exclusions, so they now match the skills that actually load, and fixed a race that could drop results when importing plugins.
- Fixed sandboxed commands failing with `Access is denied.` on Windows when PowerShell 7 was installed from the Microsoft Store; the agent now falls back to Windows PowerShell in that case.
- Fixed `/diff` showing the error from `git diff HEAD` instead of the real cause, such as a corrupt index, when the fallback `git diff` also fails.
- Fixed file links in agent responses whose line anchor was percent-encoded, such as `file.go%23L795`; the label now shows the line number and the link opens the correct line.
- Fixed separate links to the same URL highlighting together when you hover over one of them in terminals that support clickable links.
- Fixed counts in tool steps and the `/codesearch` panel, which now read "Found 1 result", "1 match", "1 file", and "Wrote 1 line" instead of "1 results", and the file-creation step reporting one line too many.

## 1.3.2

- Added `/plugin`, an interactive manager for the official Antigravity plugin marketplace: browse and install plugins that bundle skills, MCP servers, subagents, rules, and hooks, or install them from your shell without opening the CLI with `agy plugin install <plugin-name>@antigravity-plugins-official`; install one straight from a folder on your computer with `+ Install from local directory...`; fill in any settings a plugin needs in a simple form before it turns on; and manage installed plugins with `/plugin install`, `uninstall`, `enable`, `disable`, and `list`.
- Added more options for plugin authors: keep the manifest in a `.antigravity-plugin/` or `.gemini-plugin/` folder, list skills in `plugin.json`, store data in a per-plugin folder available as `PLUGIN_DATA`, and ship command-line tools in a `bin/` folder that the agent can run by name.
- Improved plugin installs: the plugin list opens instantly, an interrupted install never leaves a half-installed plugin behind, and installing or removing plugins on Windows is more reliable.
- Improved plugin compatibility: plugins load every skill in their `skills/` folder, remote MCP servers start correctly once their settings are filled in, and a plugin's subagents can use the plugin's own MCP servers.
- Changed `--dangerously-skip-permissions` to stop auto-approving the agent's implementation plan in `/plan` mode: the flag now only skips tool permission prompts, so plans wait for your review again. Set `Artifact Review` in `/config` if you want plans and other artifacts to proceed automatically.
- Improved CPU usage while the agent runs long shell commands with a lot of output, since output that is already valid UTF-8 is no longer rescanned in full on every update.
- Fixed `Tab`, `→`, and `←` in the `/diff` Commit Tree view moving the cursor to other lines instead of switching views as the `←/→ switch view` hint says, and added `Shift+Tab` to switch to the previous view in every `/diff` tab.
- Fixed the `/resume` conversation picker crashing when you pressed `Enter` to import a conversation from the `Other` tab on a narrow terminal, and conversation titles with CJK characters being cut off mid-character.
- Fixed conversations that collect many images failing on Claude models: images the agent views or you attach are now scaled down to at most 2576 pixels per side (previously 4096), keeping them within the model's limits however many images a conversation contains.
- Fixed a timer the agent scheduled with a wake-up condition keeping a CPU core at 100% until it expired when the condition could no longer be met; the timer now waits idly and fires on schedule.

## 1.3.1

- Improved navigation in the `/diff` file view: `←`/`→` now open the next or previous file at its first change with the hunk header and leading context in view, each file remembers its cursor and scroll position when you switch files or go back to the file list, `n`/`N` continue into the next or previous file's changes instead of stopping at the last change in the current file, and the key-hint footer drops the generic scroll and page hints and wraps onto extra lines instead of being cut off on narrow terminals.
- Improved the `/diff` file view header to show where you are: it now ends with a right-aligned `change A/B · file X/Y` position, counting the block of added or removed lines under the cursor and the file's place in the file list (`file X/Y` is left out when only one file changed, and the position is hidden on narrow terminals).
- Fixed `/rewind` in very long conversations listing older messages as `(empty message)` and failing with an error when you picked one: messages that were cleared to save space now show their original text, dimmed and labeled `cleared to save space, can't rewind here`, and can no longer be selected.
- Fixed installing, reinstalling, and uninstalling plugins with `/plugin` on Windows failing while one of the plugin's MCP servers was running: the CLI now stops the plugin's MCP servers before replacing or deleting its folder and restarts them afterwards, and if another Antigravity process such as another `agy` session, the Antigravity Hub, or the `remote-control` daemon still holds the plugin open, it tells you to close it and retry. Plugin manifests, `mcp_config.json`, and `hooks.json` files saved with a UTF-8 byte-order mark now load, and installing from a marketplace no longer overwrites an existing plugin folder that came from a different source.
- Fixed markdown custom agents ignoring `skills:`, `plugins:`, `rules:`, `agents:`, and `hooks:` entries written as paths relative to the agent's own file when the agent ran as a subagent or as the main agent; such entries now resolve against the agent's directory, so an agent that lists `agents: [child.md]` can invoke `child`.
- Fixed subagents that stopped on an error, such as running out of quota or model capacity, being shown as `Done` in `/agents` and the list of running agents; they now show `Error:` with the reason, and the error clears once the subagent makes further progress.
- Fixed `/tasks`, the active task list, and the status line's task count showing only background shell commands; timers and recurring jobs the agent schedules, and other tools running in the background, now appear there too and are shown as `completed` or `failed` without a made-up exit code.
- Fixed messages sent with `Queued Messages` set to `Send Immediately` in `/config` being silently queued until the end of the turn whenever the agent had already written or updated an artifact, such as a task list or plan, during that turn; they now reach the agent right away.
- Fixed terminal notifications not firing when the agent stops to ask you a question; with `Notifications` turned on in `/config`, the CLI now alerts you for pending questions just as it does for tool permission prompts.
- Fixed restarting an MCP server from `/mcp` sometimes leaving it stopped, with an error such as `Failed to stop existing instances for reload: ... signal: killed`, when the old server process took too long to exit; the server now always starts again.
- Fixed the sign-in error for accounts that need to verify their identity or appeal a Terms of Service block sometimes showing only `Verify your account to continue.` with no link; the verification or appeal link now always appears, and the CLI no longer suggests logging out and back in when that would not help.
- Fixed `GEMINI_API_KEY` sessions failing a turn as if you had cancelled it when the connection to the Gemini API was dropped internally; the CLI now retries the request instead.

## 1.3.0

- Changed the default `Verbosity` setting from `high` to `medium`, so the conversation view now groups related tool calls and thoughts into concise summaries while keeping commands and responses visible. This applies to everyone who never picked a verbosity, including anyone who selected `high` while it was still the default; set `Verbosity` back to `high` in `/config` to see every tool call, command, and thought in full again.
- Changed `j` and `k` in the `/diff` file view to move the line cursor like the up and down arrow keys, matching the file list and Vim, instead of jumping to the next or previous file; use the left and right arrow keys to switch files.
- Fixed trackpad and mouse-wheel scrolling in the conversation view jumping back and forth, most noticeably over SSH or inside tmux, by ignoring the sideways part of diagonal swipes and limiting how far a single fast scroll step can move; `Page Up` and `Page Down` still move a full page.
- Fixed files and folders whose paths contain spaces, `#`, `%`, or other special characters, or that sit on a Windows drive, being mishandled across the CLI: `@` file mentions, `/codesearch` results, and file links in agent responses now open the right file, and workspace trust and project-scoped custom agents now recognize projects created in the Antigravity desktop app in such folders.

## 1.2.17

- Added announcement cards above the prompt for model launches, deprecations, and other service notices. Cards appear one at a time, newest first; press `Esc` on an empty prompt to dismiss the current card permanently and show the next one, and sending a message hides the card for the rest of the session.
- Improved the Windows command sandbox so sandboxed commands no longer need administrator rights, and common tools such as Python, Git, and `npm` work inside the sandbox out of the box.
- Fixed markdown table columns drifting out of alignment when a cell contains emoji such as ⚠️ or 👍🏽 or scripts with combining characters such as Hindi, which affected every session over SSH or inside tmux.
- Fixed `.tiff` images being reported with the wrong file type and silently converted to PNG when the agent viewed them.

## 1.2.16

- Added `←`/`→` shortcuts to `/config`: on a highlighted setting they switch to the previous or next value and save it right away, without opening the dropdown, and the footer shows a `←/→ Change` hint
- Improved responsiveness in long conversations in no flicker (altscreen) mode: resizing the terminal no longer freezes or lags the CLI, the full-screen view redraws the messages on screen first instead of showing text wrapped for the old width until the whole conversation has re-rendered, and interrupting the agent with `Esc` or resuming a conversation no longer re-renders every step already on screen.
- Improved mouse text selection in the `altscreen` view and in the artifact viewer: dragging past the top or bottom now auto-scrolls, the selection stays on its text while the agent streams or you scroll with the wheel, and copying includes lines that scrolled off screen, without line numbers or comment previews from the artifact viewer
- Improved the always-allow suggestion when approving `go` commands: approving a command such as `go vet` or `go build` now offers to allow that subcommand with any arguments, while `go run`, `go test`, `go generate`, `go install`, and `go tool` still require the exact command
- Improved the `Send Immediately` option for Queued Messages in `/config`: a message you send while earlier messages are still queued now goes to the agent together with them, in order, instead of joining the queue, and a message that fails to send mid-turn goes back to the queue instead of being lost
- Changed how the agent generates images: it now hands image requests to a built-in `image-generator` subagent, which writes the prompt, checks each result with up to three attempts, and saves the images to the conversation's artifacts, so image generation appears as a subagent run in the conversation
- Fixed the agent stalling when a background command it was waiting on crashed or was killed by the system, for example when it ran out of memory; the agent now sees the command finish with its exit code, such as `137` or `134`, and keeps going
- Fixed headless `-p` runs sometimes exiting before the agent could respond to a background command that finished after its first turn
- Fixed `k` in Vim Normal mode recalling the last history entry instead of your queued messages when pressed on the top line, which could send a queued message twice; `k` now pulls queued messages back into the editor like the `Up` arrow does
- Fixed `skills.json`, `rules.json`, and other customization manifests in a parent `.agents/` directory being ignored when a session started in a subdirectory; manifests now load from every `.agents/` directory between the working directory and the project root
- Fixed the `/` menu listing built-in skills that the current agent does not enable, which inserted instructions for tools the agent could not use when selected
- Fixed settings failing to load when `~/.gemini/config/config.json` starts with a UTF-8 byte order mark, as files saved by Notepad or PowerShell `Set-Content` on Windows do
- Fixed slash-command output and alerts where a line exactly as wide as the terminal had its last word pushed to the start of the next line without indentation

## 1.2.15

- Added prebuilt native Android binaries of the CLI that can run directly in Termux, without requiring a proot-distro environment.
- Improved responsiveness while typing, scrolling, and streaming agent output by sharply reducing the memory the CLI allocates on every update and redraw
- Improved `-p "/usage"` to show quota reset times in your local time zone when printing to a terminal; piped and `--json` output still use UTC timestamps, so existing scripts are unaffected
- Improved the always-allow suggestion when approving `repo` commands: it is now limited to the subcommand, such as `repo status`, instead of allowing every `repo` command, matching `git`, `hg`, and `jj`
- Improved how the agent handles a permission request that is not approved, such as one raised by a subagent that cannot ask you: it now respects the denial and no longer tries to work around it with other commands, scripts, or tools
- Fixed the conversation view freezing for the rest of the session, with no new steps appearing while the agent kept working, after redraws such as several quick terminal resizes in a long conversation; the CLI now reconnects automatically, warns only if reconnecting fails, and sending a new message recovers a lost connection
- Fixed requests made after your plan quota is used up and your AI credits balance cannot cover them: instead of retrying on `Working...` for about two and a half minutes and then showing the generic "Agent execution terminated due to error.", the CLI now immediately says "Your AI credits balance is too low to continue."
- Fixed text like `Ga=q,f=32,s=1,v=1,i=31;AAAAAA==` being left behind in macOS Terminal.app after exiting the CLI over SSH; the CLI now asks the terminal to identify itself before probing for image support, and over SSH only Kitty and Ghostty are treated as image-capable, so WezTerm and Konsole no longer show garbled image placeholders
- Fixed the Vim mode cursor stopping inside emoji such as 👩‍💻 or ⚠️ and characters with combining marks such as Devanagari: `h`, `l`, and other motions now move over whole characters, and `x` and `r` delete or replace the whole character instead of a hidden part of it
- Fixed the search box in the `/resume` conversation picker wrapping long queries so that their beginning scrolled out of view; the box now uses the full terminal width
- Fixed the agent being blocked from reading your global rules and customization files in `~/.gemini/config`, including the `rules/` folder, `AGENTS.md`, `GEMINI.md`, `skills.json`, `rules.json`, `plugins.json`, and `agents.json`; it can now read them and asks before editing them, while other files in that folder stay off-limits
- Fixed global rules being added to the agent's context more than once when `~/.gemini/GEMINI.md`, `~/.gemini/AGENTS.md`, or their `~/.gemini/config/` counterparts are symlinks to the same file
- Fixed signing in to MCP servers whose OAuth client registration responds with HTTP `200` instead of `201`, which previously failed with `registration failed with status 200`
- Fixed large WebP images opened by the agent not being scaled down to fit image size limits the way PNG and JPEG images are

## 1.2.14

- Added the `Queued Messages` option to `/config`: keep the default `Queue` to hold follow-up messages until the current turn ends, or choose `Send Immediately` to interrupt the agent with them; it can also be set with `"queuedMessages": "send-immediately"` in `settings.json`, which was previously ignored
- Improved `remote-control start` on Linux machines without a systemd user service manager, such as most containers: instead of failing, it now starts the daemon as a background process and warns that it will not restart after a crash or start at boot; `remote-control status` shows its PID and `remote-control stop` shuts it down
- Improved loading long conversations: resuming a conversation with thousands of steps is noticeably faster because the CLI no longer scans every step up front
- Improved automatically generated conversation titles to take images and files attached to your first message into account, so screenshot- or file-driven requests get specific titles and messages with only attachments get a title too
- Improved the sign-in error shown to accounts blocked for a Terms of Service violation, which now includes a link to submit an appeal
- Changed `--json-schema` to reject plain text, bare type names such as `string`, and missing schema files instead of silently treating them as a string schema; these inputs, and any schema whose root is not `"type": "object"`, now fail at startup with an error and exit code `1`
- Fixed the prompt cursor drifting away from the end of the text after emoji such as ⚠️ or 👩‍💻, or scripts with combining marks such as Devanagari and Thai, especially inside `tmux`, and fixed prompt wrapping splitting such characters across two lines
- Fixed the agent hanging when it tried to view a pipe, socket, or device file, and a conversation getting stuck with `INVALID_ARGUMENT` errors after the agent viewed a truncated MP4, MOV, or M4A recording; both are now rejected up front with a clear message
- Fixed resuming a conversation whose history had a missing step, for example after a crash or an interrupted write, hiding the most recent steps and letting new messages overwrite them

## 1.2.13

- Improved rate-limit handling when the model API returns a retry delay: the CLI now waits the delay the server asks for instead of a fixed 5 seconds, and stops right away instead of retrying when the delay is longer than 30 seconds or the quota is a daily or billing cap
- Improved rendering efficiency, cutting CPU use and memory churn while the conversation view redraws, such as during fast scrolling or while the agent is working
- Improved the artifact viewer's `m` hint to name the content and the mode it switches to, such as `diagram ASCII`, `diagram source`, or `math image`, instead of `toggle ASCII` or `toggle raw`
- Fixed the workspace trust dialog, the `/help` panel, and the sign-in and MCP authentication screens clipping text on narrow terminals of around 40 columns; long lines and navigation hints now wrap, and the `/help` tab bar compacts to fit

## 1.2.12

- Improved scrolling in the full-screen view: bursts of mouse-wheel or trackpad events are now coalesced before redrawing, which cuts CPU use and reduces scroll lag in long conversations and the artifact viewer
- Improved `GEMINI_API_KEY` sessions to stop immediately when the Gemini API reports an exhausted daily quota, a project or billing-account spend cap, or depleted prepaid credits, instead of spending several minutes on retries that cannot succeed; short-lived per-minute rate limits are still retried
- Fixed resuming a long conversation in `medium` or `low` verbosity taking many seconds and lagging while history replayed: earlier tool groups now appear already finished instead of each re-animating, and keys pressed during the replay no longer refresh a half-loaded transcript
- Fixed the terminal or tab title changing to a string like `Ga=q,f=32,...` every time the CLI starts inside GNU `screen`, `tmux` (including iTerm2 `tmux -CC` tabs), or Zellij; the CLI no longer sends its image-support probe through a multiplexer, and `CLI_GRAPHICS=kitty` still forces image mode
- Fixed Vim mode ignoring non-ASCII characters such as `é` or `中` after `r`, `f`, `F`, `t` and `T`, `fv` and `fV` in Visual mode leaving Visual mode instead of extending the selection, and `D`, `C`, or Visual `~`/`u`/`U` recording an empty undo step and clearing redo history when they changed nothing

## 1.2.11

- Improved reasoning effort level for models with different support, selectable with `--effort` or from the effort gauge in `/effort` and `/model`.
- Changed plugins placed directly in `~/.gemini/config/plugins` so that a plugin whose MCP server needs configuration variables now starts disabled until you enable it, matching plugins installed through `/plugin`.
- Fixed Mermaid diagrams and LaTeX rendering as rows of garbled placeholder characters in WezTerm and the VS Code integrated terminal; these terminals are no longer assumed to support Kitty graphics and now show the ASCII fallback
- Fixed copying text from the artifact viewer when `Copy on Select` is turned off in `/config`: the viewer no longer captures the mouse, so your terminal's own selection and copy shortcut work, and `Ctrl+C` goes back to interrupting or exiting
- Fixed project custom agents in .agents/agents/ not being found or selectable in workspaces created in the Desktop App, in already-trusted workspaces, under execution with --agent, in headless (-p / --prompt) runs, and in the /agents panel.

## 1.2.10

- Added `medium` verbosity mode to `/config`, between `high` and `low`, which groups related tool calls and thoughts into concise summaries (such as `Explored N files`) while keeping commands and responses visible; the Verbosity setting and each option now describe what they show
- Improved Mermaid diagram and LaTeX rendering in the artifact viewer on Kitty-compatible terminals: artifacts are pre-rendered in the background so diagrams appear as soon as the viewer opens, images are uploaded once at a smaller size, and zooming with `Ctrl+=` / `Ctrl+-` no longer flickers between the old and new sizes
- Improved the artifact viewer footer by combining the separate top and bottom hints into one `g/G top/bottom` entry, labeling `m` with the view it switches to (diagram, LaTeX, ASCII, or raw), and fixing hints that contain arrow symbols wrapping onto a new line too early
- Improved terminal sandbox behavior so the agent asks to bypass the sandbox less often: it now knows sandboxed commands can read and write its own artifact and scratch directories, and it tries the sandbox first even after an earlier command needed a bypass
- Changed the step title of commands that exit with a non-zero code from `Errored` to `Failed`
- Changed how directory entries in `skills.json`, `rules.json`, `agents.json`, and `plugins.json` are scanned: an entry now loads only the items directly inside the directory, the same as a `.agents/skills/` folder, instead of recursively loading everything beneath it; to load a nested item, name it in `include_only`, for example `{"path": "shared_skills", "include_only": ["category/my-skill"]}`
- Fixed pressing `Esc` while the suggestions dropdown is open interrupting the agent's turn; it now closes the dropdown, and a second `Esc` interrupts
- Fixed Mermaid diagrams and LaTeX leaving a blank gap inside `tmux` or GNU `screen` when the outer terminal supports Kitty graphics; the CLI now falls back to ASCII diagrams unless images actually reach the terminal, and `CLI_GRAPHICS=kitty` still forces image mode for setups with image passthrough configured
- Fixed headless (`-p` / `--prompt`) runs that streamed part of a response and then ended on a model or agent error exiting with code 0; they now exit with code `3` and print the `AGY_ERROR` line, and JSON error output includes the partial response, while multi-turn `stream-json` sessions still warn and continue
- Fixed machines set up with the old Remote Control installer script crash-looping after an upgrade; when the CLI is launched by that deprecated background service it now unregisters the service and points to `remote-control start` instead of restarting repeatedly
- Fixed files that subagents write inside their own Git worktree being treated as artifacts, which demanded artifact metadata and left `.metadata.json` files in the worktree; subagent worktrees now live under a `worktrees/` directory in the app data directory

## 1.2.9

- Added `@<subagent> <message>` prompt syntax to send a message directly to a subagent conversation, with autocomplete listing running and completed subagents
- Added Vim numeric count multipliers so counts apply to operators, motions, and actions in Normal and Visual modes, including `3dw`, `2d3w`, `3dd`, `3x`, `3rX`, `3p`, `3u`, `[count]G`/`gg`/`$`, and counted text objects such as `2di(`
- Improved `GEMINI_API_KEY` sessions to reduce behavior discrepancies with the non-API-key sign-in path
- Improved the artifact viewer to show a Left/Right pan hint in the footer when a wide diagram overflows the window
- Improved `/rewind` to show a relative timestamp for each step and to focus the most recent step when the panel opens
- Improved command allow-listing suggestions to recognize `jj config` and `jj op` subcommands when offering to always allow a command
- Fixed headless (`-p` / `--prompt`) runs leaving daemon background processes running after exit, which could hang scripts reading the CLI's output until end-of-file; daemon processes now terminate when the run ends
- Fixed headless (`-p` / `--prompt`) runs cancelling still-running background tasks about 5 seconds after the agent went idle; runs now wait for background tasks until the `--print-timeout` deadline, up to a 30-minute cap
- Fixed a conversation-history database corruption risk where checking the database file for write access could silently drop file locks held by concurrent CLI processes on the same file
- Fixed context compaction failing when the tool configuration used for compaction checkpoints was rejected in certain scenarios
- Fixed a backend crash when a streamed model response chunk arrived without its response envelope, which terminated the session with connection errors
- Fixed markdown table column alignment when a table cell contains file links that wrap across lines
- Fixed markdown file links to code symbols dropping their display text and rendering the raw path instead
- Fixed incomplete enterprise sign-ins (for example closing the browser window before finishing license or project selection) leaving behind a stuck partial credential; such credentials are now cleared automatically so sign-in can be retried cleanly
- Fixed the browser companion page title to read `Antigravity CLI` instead of `Antigravity Cli`

## 1.2.8

- Improved context compaction to spread its user-request budget across all captured prompts, so a long initial instruction is no longer truncated to a small fixed slice when the other prompts in the conversation are short
- Improved context compaction to size summary and truncation budgets from the model's full context window instead of the compaction trigger threshold, so compacted summaries and background-task lists are no longer prematurely cut short
- Fixed PDF and audio tool outputs and attachments failing with `unsupported mime type` errors on custom models configured in `settings.json`; custom models now accept PDFs by default and honor the `modelFeatures` media flags for images, video, PDF, and audio
- Fixed pressing `Ctrl+G` to edit the prompt in a full-screen terminal editor such as `vim` hanging with `Vim: Warning: Output is not to a terminal`; external editors now run against a real terminal stdout
- Fixed voice dictation sessions longer than 4 minutes failing with a deadline error and erasing the drafted transcription; recordings now automatically stop and finalize at 3 minutes 30 seconds
- Fixed the startup banner displaying a Google Cloud Project ID for consumer (non-enterprise) sign-ins
- Fixed a stack-overflow crash when loading or compacting conversations containing background-task, subagent-management, messaging, or scheduling steps
- Fixed forked conversations inheriting step output data from steps after the fork point, which could collide with new steps produced in the fork
- Fixed a background poller and timer leaking for every conversation session, slowly accumulating memory over long-running sessions
- Fixed canceled conversation and workspace creation requests continuing to provision resources in the background; aborted requests now stop immediately
- Fixed quitting the CLI taking around 5 extra seconds before the process exited; shutdown now cancels open streaming connections immediately instead of waiting for a forced timeout

## 1.2.7

- Added inline Kitty graphics rendering for LaTeX math equations (`$$...$$` and fenced `math`, `latex`, and `tex` blocks) and Mermaid flowcharts and sequence diagrams in the artifact detail viewer, with Unicode ASCII fallback, Left/Right arrow horizontal panning for wide diagrams, and `m` to cycle between Image, ASCII, and Raw views
- Improved the `ask_question` interactive prompt with Left/Right arrow navigation between questions, inline previews of confirmed write-in answers, check marks on answered options, and single-step submission on the final question
- Improved the CLI startup banner for enterprise accounts to display the active Google Cloud Project ID beneath the signed-in account and plan tier
- Improved model API retry responsiveness by capping per-attempt retry backoff at 30 seconds instead of waiting up to 4 minutes between attempts
- Improved customization token budgeting by giving user and workspace rules a dedicated 20,000-token budget (cutting oversized rules on newline boundaries and listing over-budget rules by path and description) so large rule sets no longer evict skills, workflows, subagents, or MCP tools
- Improved the `/usage` panel by removing the duplicate remaining-quota percentage line beneath each progress bar
- Improved the default agent and subagent toolset by retiring the legacy `find_by_name`, `grep_search`, and `list_dir` tools from the default baseline while keeping them available to custom agents that explicitly list them in `tools`
- Fixed plugin skill slash commands being double-prefixed (`/<plugin>:<plugin>:<skill>`) when a skill's frontmatter name already includes the plugin prefix, or being shadowed when multiple plugins define skills with the same short name
- Fixed plugin upgrades leaving old MCP server and sidecar processes running from deleted install directories, and pruned superseded plugin versions and staging directories from the marketplace cache on startup
- Fixed disabled plugins disappearing from the `/plugin` list after enabled-only customization queries, and hardened plugin ID path validation on uninstall
- Fixed terminal rendering and Kitty keyboard protocol stack handling on exit and screen clear by upgrading Bubble Tea to v2.0.9
- Fixed headless (`-p` / `--prompt`) runs occasionally skipping the background-task waiting notice, logged background SDK tool progress to task log files, and reduced memory usage by cloning truncated command output previews
- Fixed starting the CLI unpinning conversations or marking them unread in the desktop app

## 1.2.6

- Added Remote Control (start a connection via `--remote-control` startup flag or `/remote-control` slash command) to create a session-scoped remote connection for following and controlling your active terminal session from another device. Typing `/remote-control off` or closing the session automatically tears down the tunnel and unregisters the device from the active Remote Control session list.
- Changed the default timeout for headless (`-p` / `--prompt`) runs from 5 minutes to unlimited so long-running agent turns run until the response completes unless `--print-timeout` is passed explicitly, and enabled daemon background commands in headless `GEMINI_API_KEY` sessions so background servers stay running after the turn finishes.
- Improved headless (`-p` / `--prompt`) error reporting when a turn terminates on an agent or model API failure: the CLI now prints a structured `AGY_ERROR: {...}` JSON line on stderr with canonical status, HTTP or gRPC error code, retryability, and error ID (including HTTP status mapping for `GEMINI_API_KEY` SDK errors) and exits with code `3` instead of `1`.
- Improved word-wise cursor movement (`Alt+F`, `Alt+B`, and `Ctrl`/`Alt`+Arrow keys) and word deletion (`Ctrl+W`, `Alt+Backspace`, and `Alt+D`) in the prompt editor to stop at punctuation boundaries instead of only whitespace, making it easy to step through or delete individual segments of file paths, URLs, and flags.
- Fixed turns triggered from a connected Remote Control session or running across secondary workspaces executing without the CLI session's active permission mode, cycle mode, and non-workspace file access grants.
- Fixed artifacts in the Remote Control companion rendering as plain `<name>.md` file links instead of rich artifact cards when the CLI's application data directory differs from the default bundle name.
- Fixed text selection in the full-screen artifact viewer capturing the line-number gutter and trailing padding; dragging across the viewer now highlights and copies only the document text, with `Ctrl+C` to re-copy an active selection, `Esc` to clear it, and `Shift`+drag for native terminal selection.
- Fixed submitting `/model <name> <prompt>` while a turn is already running switching the active model immediately in the middle of the in-flight turn; the one-shot model switch now waits until the queued prompt begins executing so the running turn and any earlier queued prompts finish on the session's original model.
- Fixed file edits with diffs larger than 1 MiB exceeding the conversation storage limit and force-clearing the session; oversized edits now preserve their line-change statistics while omitting the raw diff body from stored conversation history and skipping the elided diff during `/rewind` reverts.
- Fixed `/rewind` conversation reverts and forks sweeping backward to an older workspace snapshot when recent snapshot commits were skipped, which could silently overwrite kept work; snapshot lookup now sweeps forward from the target step and falls back to step-by-step revert replay when no later snapshot exists.

## 1.2.5

- Added automatic subagent guidance for custom agents defined in Markdown: agents that list `invoke_subagent` in their tools now receive the roster of available subagents and usage instructions in their system prompt, so they can actually delegate to the subagents they declared.
- Improved background task naming so a task keeps the name it was given when sent to the background; completion notifications and task lists now show that name instead of a generic auto-derived one.
- Fixed stale credentials lingering after the sign-in server definitively rejects them (for example a revoked or invalidated enterprise account); the CLI now signs you out and clears the stale tokens so you can sign in again cleanly, while temporary network failures, server errors, and rate limits never cost you your session.
- Fixed commands killed by an outside signal (for example when the whole session shuts down mid-run) being recorded as successful runs with exit code 0; such commands now finish as canceled while keeping the output collected before the interruption.
- Fixed the `Interrupted` hint only appearing when Esc was pressed locally in the terminal; it now appears whenever the current turn is actually cancelled, including when it is stopped from a connected remote session.
- Fixed the artifact viewer leaving markdown text stuck at its original width after a terminal resize; content now re-wraps to the new window size.
- Fixed in-progress thinking frames occasionally freezing permanently in the conversation history (for example showing `Thinking... (31s)` forever), including after a terminal resize or session reload.

## 1.2.4

- Added a `/skills reload` subcommand to asynchronously reload discovered skills and slash commands without restarting the session or blocking user input.
- Added an inline argument autocomplete dropdown when typing `/model` and a live fuzzy search bar inside the interactive `/model` picker to filter models by name or ID.
- Improved authentication error messages when OAuth tokens lack required scopes by including explicit instructions to run `/logout` and `/login`.
- Fixed mid-conversation model switching to Gemini thinking models failing with `thought_signature` validation errors when prior turns were generated by non-Gemini models.
- Fixed web search (`search_web`) failing with `"no summary returned from GenerateContent"` when the summarization model emits leading thought parts.
- Fixed agent turns terminating prematurely with `NO_TOOL_CALL` when a tool call fails schema validation, allowing the agent loop to return the validation error and self-correct.
- Fixed MCP tool schema augmentation mutating tool definitions in place, preventing strict argument validation failures.
- Fixed `hooks.json` configurations being silently dropped when customization token budget truncation is active.
- Fixed custom subagents losing configured `exclude` skill filters when runtime skill filtering is applied.
- Fixed subagent status and termination tracking under pubsub batch coalescing so killed subagents are not reset to active by late step updates.
- Fixed conversations with active turns or running daemon background tasks failing to auto-resume after a restart.
- Fixed terminal `ERROR` steps (such as failed tool executions or timeouts) being omitted from `transcript.jsonl` conversation logs.
- Fixed raw OSC 8 escape sequences rendering in `Apple_Terminal` over SSH connections by disabling unsupported hyperlink sequences.

## 1.2.3

- Added the `/copy btw` slash subcommand to copy the full text of the active `/btw` side-question response to the clipboard even when the response card is collapsed or scrolled, along with argument ghost hints when typing `/copy`.
- Improved tool-calling fidelity by translating per-request tool-choice constraints (`any`, `required`, and named functions) into native backend function-calling configurations.
- Fixed the `/hooks` command and hook inspection utilities omitting hooks bundled inside enabled plugins when listing active `hooks.json` configurations.
- Fixed custom subagents created with `enable_mcp_tools: true` receiving an empty MCP server list instead of inheriting the parent agent's configured MCP servers, and fixed declarative subagent configurations failing to resolve relative config file paths (`relative_path_to_config`) against the parent agent's directory.
- Fixed proactive feedback prompts triggering prematurely during the first few turns of a session or on transient, recovered tool errors.

## 1.2.2

- Improved the startup warning for deprecated `unsandboxed` permission rules across CLI, shared, and project configuration files to list each affected file path, up to five offending rules, and step-by-step instructions for migrating them to `command` rules.
- Improved `/resume` startup responsiveness when opening a large conversation history with a cold or stale summary cache.
- Fixed MCP servers bundled inside plugins colliding with each other or with user-configured servers in `mcp_config.json` when they shared the same server name by automatically namespacing plugin MCP servers as `<plugin>_<server>`.
- Fixed a memory leak where opening or scanning conversations left background step-cache eviction goroutines running for the rest of the session, significantly reducing memory usage after opening `/resume` or switching conversations.
- Fixed `view_file` attempting to parse non-UTF-8 binary files as text or loading files larger than 100 MB into the model context; unsupported binary formats and oversized files are now rejected with a clear error before overflowing the context window.
- Fixed Gemini API (`GEMINI_API_KEY`) sessions dropping model thinking blocks from prior turns on subsequent user messages and failing to propagate thought signatures on text and thought parts.
- Fixed artifact review failing to trigger when a directory name above `.gemini/` matched a skipped path component such as `scratch`, prevented conversation forks and snapshot reverts from copying internal `.system_generated/subagents` and `.system_generated/worktrees` directories, and cleaned up subagent metadata records when deleting a conversation.
- Fixed deleted conversations being recreated as empty, schema-less SQLite database files when background queries reconnected after deletion.
- Fixed conversations launched without a workspace folder inheriting workspace paths and customizations from other open sessions.

## 1.2.1

- Added support for `excludeDefaultComponents: true` in custom agent Markdown frontmatter, allowing custom agents to opt out of default prompt sections and built-in tools while preserving post-invocation hooks.
- Improved model API error resilience and diagnostics: transient `genai.APIError` failures (`502`, `503`, `504`, per-minute `429` rate limits, and mid-stream interruptions) automatically retry in-process with exponential backoff while preserving completed tool call outputs, and unrecovered `503` and `429` responses surface clear user-facing error messages.
- Improved MCP and provider tool schema validation to preserve open object schemas (such as `{"type": "object"}` or explicit `additionalProperties: true`) instead of rejecting undeclared arguments on schemas that allow them.
- Improved per-turn responsiveness and reduced memory usage when opening large conversations.
- Fixed `--continue` starting a brand-new conversation when launched from a subdirectory, after a crash, or while another session is open in the same workspace; it now falls back to the most recent non-empty conversation in the current workspace or its parent/child directories.
- Fixed full-screen blank flashes in inline mode when content first pushes to scrollback, at the end of a turn, or when clearing the screen with `Ctrl+L`.
- Fixed remote companion UIs connected to an interactive CLI session via Remote Control displaying an unauthenticated sign-in screen instead of the active session's signed-in state.
- Fixed the status line reporting the terminal sandbox as disabled when the session was launched with the `--sandbox` command-line flag.
- Fixed image zoom keys (`Ctrl+=` and `Ctrl+-`) and the footer zoom hint appearing in the artifact viewer when a Mermaid diagram is rendered in ASCII mode instead of as a Kitty image.

## 1.2.0

- Added the `remote-control start`, `remote-control status`, and `remote-control stop` subcommands to run the CLI as a background service registered with your operating system's service manager so your machine stays reachable across logouts and reboots; `remote-control start --name <label>` sets a custom machine label in the Remote Control instance list, and `--session` scopes the service to your active login session.
- Improved half-page scrolling across all scrollable views — including altscreen mode, the diff viewer, and read-only detail panels where `ctrl+d` no longer triggers the exit prompt — and set `shift+up` and `shift+down` as customizable default keybindings for half-page navigation (`navigation.half_page_up` and `navigation.half_page_down`).
- Fixed prompts or model responses blocked by content safety filters failing with a spurious "no candidate found" error, ending silently with an empty turn, or repeatedly retrying the rejected input; the CLI now surfaces a clear content-filter stop reason.
- Fixed temporary working files written to the agent `scratch/` directory triggering recursive filesystem watchers and appearing as noisy entries in the artifact review panel and checkpoints.
- Fixed MCP servers bundled inside globally installed plugins failing to initialize at CLI startup or failing to update their running status when plugins are enabled or disabled.
- Fixed third-party MCP server tools failing schema validation when their input schemas omit `additionalProperties`.
- Fixed unnecessary filesystem customization discovery walks running on every user message even when no slash command is invoked, reducing latency before the agent begins responding.
- Fixed every log line in `cli.log` and background daemon subcommand output being prefixed with a spurious `ERROR: logging before google.Init` message.
- Fixed the macOS `remote-control` background service terminating shortly after startup when launched by the system service manager, `remote-control start` and `remote-control stop` leaving legacy installer-script background services running, and the Remote Control setting being unavailable when your access comes from a paid Google Cloud project.
- Fixed older conversations failing to load with an `unknown step type` error when resumed.

## 1.1.28

- Improved resilience to transient model API errors: the agent now retries errors such as `503 Unavailable` for much longer with exponential backoff, so a brief service hiccup no longer aborts your session.
- Improved sign-in and startup speed by reading your signed-in identity from the stored credential instead of making a network request on every launch and after browser consent; a failed identity lookup no longer prevents sign-in from completing, and the displayed plan tier no longer briefly disappears during startup.
- Improved headless (`-p`) runs to exit promptly once the final answer is delivered: the CLI waits for running background tasks and scheduled timers to finish, bound by `--print-timeout`, and leaves daemon background tasks such as dev servers running instead of terminating them.
- Improved failure reporting in headless (`-p`) runs: fatal errors now appear on stderr with a stable `error:` marker, a note is printed when the response may be truncated, and runs that previously ended silently with no output now explain why.
- Improved headless (`-p`) turnaround by cutting up to 200 ms of idle latency per turn and skipping the model call that generated a conversation title no one would see.
- Improved tool approval prompts to say exactly what you are approving — for example `Run this command?`, `Allow access to this URL?`, or `Allow calling this tool?` — with the command-editing shortcut offered only when a command is being approved, and a `Reason:` line explaining why approval is being requested when it is not obvious, such as a hook flagging the action or a file belonging to a different project.
- Improved model selection auditability: the CLI log now records whenever a model name you specify resolves to a different model, such as alias resolution, `--effort` variant selection, or replacement of a deprecated saved model.
- Changed what happens when `--print-timeout` expires mid-turn: the CLI now returns the partial output it has and exits successfully with a warning on stderr, instead of failing with a timeout error; interrupts such as Ctrl+C still exit non-zero.
- Changed the default permission for fetching URLs from always allowed to asking first, so the agent now requests approval before reading a URL unless you have granted access.
- Fixed plugin reinstalls keeping files that had been deleted from the source: installing a plugin now replaces its managed directory exactly, installing a plugin from its own installed directory is refused instead of corrupting it, and uninstalling a plugin no longer leaves its enabled/disabled entry behind in `config.json`.
- Fixed MCP servers defined by plugins resolving relative or unset working directories against the wrong location; they now resolve against the plugin's own directory so plugin-bundled scripts run correctly.
- Fixed a startup race where subagents could fail to find tools from MCP servers that were still initializing.
- Fixed subagents sometimes appearing stuck in a running state after they had finished — especially in very large conversations — which also left queued when-idle messages undelivered until restart.
- Fixed a memory leak where every finished terminal command kept internal state alive for the rest of the session; long sessions that run many commands now use significantly less memory.
- Fixed headless (`-p`) runs stalling forever on implementation-plan approval that no one could give; non-interactive runs now proceed through plan review automatically.
- Fixed sign-in failing with a project access error after switching from a business account with a selected project to a personal account; stale business project and license details are now fully cleared on personal sign-in.

## 1.1.27

- Added `/model <name> <prompt>`, which runs a single prompt on another model and then returns the session to the model it was using, so you can consult a different model mid-conversation without disturbing your saved default.
- Added a `conversation_title` field to the JSON payload passed to custom status line and window title scripts, so they can show the active conversation's name and pick up renames immediately.
- Added an `agents` list to custom agent Markdown frontmatter, letting an agent declare the subagents it depends on using the same workspace-relative, absolute, and agent-relative path rules as `skills`.
- Improved `/model` to show a `[model]` argument hint as you type, so the command's arguments are discoverable without opening help.
- Improved the `/settings` panel so each Verbosity option explains itself as you highlight it, describing whether tool calls, commands, and thoughts are shown in full or collapsed into a token metrics table.
- Improved the sign-in and Google Cloud setup screens to use the CLI's standard styled key hints, which follow your color scheme and keybindings and drop the navigation hint when only one option is available.
- Changed `/model <name>` to report `Model already set to <name>` when the session is already using that model, instead of reporting a switch that did not happen.
- Fixed tool calls to MCP servers accepting arguments the server's own schema never declared, so an invented parameter is now rejected and corrected instead of being silently dropped.
- Fixed headless runs with `-p` silently skipping tool actions they were not permitted to take, which now end with a notice naming the refused actions and report them as `denied_actions` in the JSON output.
- Fixed `?` in Vim Normal mode opening the shortcuts panel while the prompt already contained text, so character-search and replace operators such as `f?`, `t?`, and `df?` work; `?` still opens shortcuts on an empty prompt.
- Fixed `/model` with no argument doing nothing when run before the session had finished starting up, so it now opens the model picker.
- Fixed print mode (`-p`) exiting before the session finished shutting down, which could drop the run's trailing conversation history before it reached disk.
- Fixed a redundant approval prompt when the agent reads or writes another conversation's artifact files after you have already allowed access to files outside your workspace.

## 1.1.26

- Added half-page scrolling with `Ctrl+D` and `Ctrl+U` to the artifact viewer.
- Added the `pickerGrouping` setting to `/config` and `settings.json` to configure the default conversation list view in `/resume` (flat or grouped by workspace).
- Improved terminal ASCII diagram rendering for Mermaid flowcharts in the artifact viewer and conversation.
- Improved `/logout` execution time by short-circuiting token removal directly to file storage when keyring storage is bypassed or unreachable.
- Changed unselected model families in the interactive `/model` picker to default to medium reasoning effort instead of low.
- Fixed subagent tasks unexpectedly prompting for tool approval in always-proceed mode while viewing the subagent details panel.
- Fixed orphaned Git worktrees accumulating on disk under `.system_generated/worktrees` when killing subagents or deleting conversations.
- Fixed SQLite database WAL checkpointing on CLI exit so trailing session metadata updates are flushed to disk before shutdown.
- Fixed customization discovery logging spurious errors when accessing temporary directories or paths outside the active workspace.

## 1.1.25

- Added an opt-in workspace-grouped view to the `/resume` conversation picker, allowing users to toggle between a flat list and conversations grouped by directory with `Ctrl+F`.
- Added Gemini 3.8 Flash to the model catalog when connecting with a `GEMINI_API_KEY`.
- Changed custom agents defined in Markdown to inherit ambient skills, rules, and subagents by default, matching the configuration of default agents.
- Fixed MCP OAuth authentication failing when authorization servers return authorization codes longer than 1024 characters.
- Fixed skill path matching and grouping in the `/skills` panel on Windows where host path separators (`\`) caused global and workspace skills to be misclassified.
- Fixed relative path resolution in Markdown-defined custom agents so relative subagent and plugin paths resolve correctly against the agent definition's directory.
- Fixed duplicate permission grants accumulating in configuration settings across session reloads and subagent invocations.
- Fixed /boost failing at runtime by improving worker tool configurations.
- Fixed a fatal nil pointer crash in the agent runtime caused by background summary updates attempting to read cached steps after trajectory closure.
- Hardened Remote Control reverse-tunnel routing.

## 1.1.24

- Improved `/mcp` panel navigation so up and down arrow keys strictly navigate between MCP servers and plugins, left and right arrow keys cycle available actions, and `Esc` exits action mode or the panel.
- Fixed duplicate agent entries appearing in the `/agents` picker when an agent with the same name is discovered across multiple configuration sources or plugins.
- Fixed tool initialization and agent startup failing when launched from an inaccessible or deleted working directory by using absolute URI schemes for in-memory parameter schemas.
- Fixed headless CLI invocations with piped standard output or standard error hanging on exit by setting `FD_CLOEXEC` on the preserved streams so child processes do not keep the caller's pipes open.
- Fixed MCP configuration parsing failing when `mcp_config.json` contains single-line (`//`) comments, multi-line (`/* */`) comments, or trailing commas.
- Fixed orphaned annotation files accumulating in local storage when deleting conversations.
- Fixed `/btw` side questions in conversations with an active `/goal` being forced to continue and making unintended tool calls.

## 1.1.23

- Improved `/model <name>` autocompletion to accept the proposed model name ghost text with `Tab`.
- Reduced subagent streaming overhead by sending subagent trajectory metadata once per subtrajectory instead of with every step.
- Fixed commands with subcommands (such as `models` or `agents`) hanging on an inherited, unclosed standard input pipe instead of executing immediately.
- Fixed CLI crashes caused by prompt hooks by catching hook panics and rejecting nil completion configurations in model requests.
- Fixed tool invocations and results omitting tool-call IDs when reconstructing request history for Gemini models.
- Fixed tool permission prompts for direct and MCP tool calls displaying generic prompt titles instead of their declared human-readable action descriptions.
- Fixed unconfigured or interrupted Google Cloud authentication and onboarding sessions dropping into broken chat sessions instead of prompting with the sign-in screen.
- Fixed transient authentication errors caused by token expiry clock skew by proactively refreshing browser and WIF OAuth tokens five minutes before expiration.
- Fixed instructional cycle mode placeholders reappearing in the input prompt after typing and clearing content.
- Fixed subagents defined with `enable_mcp_tools=true` failing with unknown tool errors by ensuring the MCP dispatcher meta-tool is available to the subagent executor.
- Fixed prompts entered immediately after login being discarded with an account verification alert by queueing them until background eligibility verification completes.
- Fixed cancelled or killed subagents remaining stuck in the "Running" state in the UI task drawer across ancestor conversations.
- Fixed parsing MCP JSON configuration files on Windows when saved with a UTF-8 byte order mark (BOM).

## 1.1.22

- Added a `/model <name>` argument that switches to a model by name, slug or label and saves it as your default in one step, with the rest of the first matching name offered as ghost text while you type; `/model` on its own still opens the picker, and an unrecognized name prints the valid ones.
- Improved the `/effort` hint so it completes what you have actually typed instead of always showing a fixed `[low|medium|high]` placeholder.
- Improved artifact handling in conversations that produce many files by coalescing bursts of filesystem events into a single rescan.
- Fixed selectable reasoning effort for Gemini 3.1 Pro and Gemini 3.5 Flash when you authenticate with a Gemini API key.
- Fixed the interface redrawing continuously while the tasks panel or a subagent detail panel was open with nothing running, which held process CPU near 32% instead of the roughly 10% it now settles at.
- Fixed a running subagent's elapsed timer freezing on screen whenever the parent agent was itself waiting.
- Fixed an HTTP 502 from the model endpoint ending the whole run instead of being retried, so a transient bad gateway is now treated as the temporary outage it is.
- Fixed a `self` subagent launched from a conversation with no recorded agent configuration re-resolving its setup from scratch and drifting from its parent, most visibly by running interactively when the parent was in autonomous mode.
- Fixed file deletions failing on Windows with a sharing violation while another process still held the file open, which is now retried with backoff for about a second before reporting failure.
- Fixed headless daemon printing an `Open in your browser: http://localhost:<port>` line in its startup banner, which was never a supported way to connect and, under a service manager, was written to the log on every restart.
- Fixed the built-in `migrate-workflows` skill assuming POSIX home directories and path separators, so it now resolves and reports paths correctly on Windows.

## 1.1.21

- Added `/voice` dictation, which transcribes speech straight into the prompt; press `f5` or run `/voice` to start and stop it, and use the `mic-serve` subcommand to forward a local microphone to a CLI running on another machine over SSH. Only one live dictation stream is allowed per account, and a second one now says so instead of reporting an exhausted quota.
- Added a `cost` field to the status line data model, exposing the unrounded estimated cost of the current session so a custom status line can display running token spend.
- Improved the agent's code search by running an embedded `ripgrep` binary instead of shelling out to whatever the machine provides, so searches are faster and behave identically on systems with no `ripgrep` installed.
- Improved the `always-proceed` permission mode to auto-approve MCP tool calls and page reads as well, which kept prompting even though the mode exists to run without interruptions.
- Improved allow-always permission suggestions for script runners such as `npm run`, `yarn`, `pnpm` and `cargo run` by pinning the specific script name, so approving `npm run dev` no longer grants every script in the project.
- Improved conversation titles by generating them automatically when a conversation is created, so the resume picker shows a meaningful name instead of a placeholder from the first message.
- Improved the error shown when an MCP server configured for Google credentials cannot find Application Default Credentials.
- Fixed corrupted edits to files containing non-ASCII text such as CJK characters, accented letters or emoji, where an inexact match was spliced at the wrong offset and produced invalid UTF-8.
- Fixed the session stalling mid-response when a tool result or file diff contained invalid UTF-8, which broke the agent state stream and left the interface waiting indefinitely.
- Fixed a file write being reported as a failure after the content had already been written to disk, which sent the agent into unnecessary retries on large files such as notebooks.
- Fixed explicitly configured skill and plugin paths losing to customizations discovered automatically nearby, so a path you set in your configuration now wins a name collision.

## 1.1.20

- Added skill icon and visual branding support across the CLI, displaying emoji icons declared under `metadata.icon` in `SKILL.md` frontmatter across the `/skills` catalog list view, detail inspection headers, and slash command autocompletion popups, with proper multi-byte Unicode display width calculation to maintain terminal layout alignment.
- Improved `@` file path autocompletion by indexing empty directories alongside files in ripgrep search results, allowing unpopulated and directory-only workspace structures to be discovered and traversed during path completion.
- Improved permission management by automatically granting workspace-scoped read access under the default review mode, eliminating repetitive approval prompts for reading or listing files within the workspace root while strictly maintaining confirmation prompts for file modifications and external access.
- Improved Git repository inspection performance by skipping recursive submodule worktree scans while continuing to track commit pointer updates to eliminate status latency in repositories with submodules.
- Fixed print mode (`-p`/`--print`, including `--output-format json` and `stream-json`) treating benign tool execution errors and permission denials as fatal run failures with non-zero exit codes, ensuring headless exit codes reflect only cascade-level failures and match interactive session behavior.
- Fixed the CLI overwriting and discarding unparsed configuration in `settings.json` when encountering an unrecognized setting value or syntax error on startup, preserving the existing configuration file on disk instead of saving a truncated version.
- Fixed `/skills`, `/plugins`, `/agents`, and `/hooks` commands reporting that no customizations were found when invoked without an explicit agent configuration by mounting built-in customizations in listing views.
- Fixed CJK draft jitter in the main prompt by normalizing boundary whitespace in streaming transcript updates, preventing unwanted spaces from being inserted characters.
- Fixed the conversation spinner animation loop continuing to tick indefinitely in the background after turns completed, eliminating unnecessary CPU wakeups while the CLI is idle.

## 1.1.19

- Fixed `--remote-control` refusing to start whenever port was taken, so it now takes a free port from the operating system.
- Added the `AGY_CLI_HIDE_LOGO` environment variable for narrow terminals, screen readers and recordings where the banner's logo art gets in the way; setting it suppresses the art while keeping the version and account lines.
- Added `AGY_CLI_DISABLE_ESCAPE_SEQUENCE_OPTIMIZATIONS` to bypass the renderer's dirty-rectangle and diffing optimizations.

## 1.1.18

- Added support for passing a project name to `--project`, which previously accepted only a project ID and failed on anything else.
- Added `item.rename` and `item.delete` keybindings for the conversation picker's rename and delete actions, so `f2` and `f4` can be rebound in `keybindings.json` on keyboards without function keys.
- Improved `@` file path completion with a typo-tolerant fallback, so a query with a transposed or mistyped character still finds the file; typo matches never outrank exact ones.
- Improved audio attachments by recognizing the standard formats Gemini models accept, including `wav`, `mp3`, `m4a`, `aac`, `flac` and `opus`, which were previously refused as unsupported.
- Improved keystroke responsiveness on Windows by discarding the key-release events the console reports and nothing in the CLI reads, which were roughly doubling the rendering work per keystroke.
- Improved the artifact viewer footer by moving the outline shortcut next to the scroll and page hints, so the three ways to move through a document read as one group.
- Fixed print mode (`-p`) exiting successfully with an empty response when the agent state stream was dropped mid-run, which reported a failed turn as a clean success; it now surfaces the stream error and exits non-zero.
- Fixed a valueless prompt flag swallowing the next flag as its prompt, so `--print --sandbox 'do the task'` no longer runs with the prompt `--sandbox` and the sandbox off; both that and a stray trailing argument are now errors.
- Fixed an expanded `/btw` card pushing the footer hints and the prompt off-screen on a long answer, which is now clamped to the terminal height and scrollable with the arrow and page keys.
- Fixed `/resume` opening below the fold instead of on the workspace you are working in, which happened whenever the CLI ran from a subdirectory of that workspace.
- Fixed text losing its styling for the rest of a line after a file link, where the link's own reset also reset the surrounding prose.
- Fixed a stray character appearing in the prompt every couple of seconds on terminals that print the CLI's periodic input-mode re-arming as literal text; the re-arm now happens only inside a terminal multiplexer, which is the only thing that resets those modes behind the CLI's back.

## 1.1.17

- Improved the agent execution harness by consolidating onto a single execution path, giving more consistent tool, hook, and prompt behavior.
- Fixed `/teamwork-preview` and some other slash commands disappearing for some users.
- Fixed `Enter` not opening an active background task or subagent while the prompt was in Vim insert mode.
- Fixed attaching Ogg audio and video files such as `.ogg`, `.opus` and `.ogv`, which the model rejected because they were sent as the generic `application/ogg`.

## 1.1.16

- Added `mcp` subcommands (`add`, `remove`, `list`, `enable`, `disable`) for managing MCP servers in your user-level `mcp_config.json` without hand-editing it, covering both stdio and HTTP servers through `--type`, `--env` and `--header`.
- Improved `@` file path completion in large workspaces by running the lookup through the bundled `ripgrep` and debouncing keystrokes, and by ranking a file whose name matches your query above a directory or generated artifact that merely contains it.
- Improved `/effort` so it adjusts reasoning effort for Gemini 3.6 Flash and Gemini 3.7 Flash when you sign in with a Gemini API key, a route that previously reported those models as not adjustable even though the same models were adjustable on every other sign-in path.
- Fixed links printing as raw escape sequences on terminals that do not implement OSC 8 hyperlinks, such as Terminal.app, and extended the same detection to command output and alert bodies, which still emitted hyperlinks unconditionally.
- Fixed a `=` character accumulating in the prompt every couple of seconds on terminals that do not implement the Kitty keyboard protocol, where the renderer's periodic re-arming of that protocol was printed as literal text instead of being interpreted.
- Fixed `@` file path completion showing files that were in your `.antigravityignore`.
- Fixed the artifact list showing a percent-escaped filename such as `quarterly%20plan.md` for artifacts whose name contains a space, so the list row, the inline preview and the detail header all spell the name the same way.
- Fixed the prompt editor's cursor becoming misaligned when text wrapped.
- Fixed the `/mcp` panel dropping `enabledTools`, `timeoutSeconds`, `url` and `tools.eager` from `mcp_config.json` when you toggled a server on or off; it now preserves any field it does not recognize, so configuration written by a newer client survives an edit.
- Fixed `read_resource` discarding non-image binary content returned by an MCP server, which now offloads every blob to disk and inlines only small text and image resources, so large PDFs, audio and other binary resources are usable instead of silently dropped.
- Fixed Workforce Identity Federation sign-in signing you out roughly every hour, because the token refresh went to the standard sign-in endpoint rather than the federated one.
- Fixed skills that ship with the CLI being reported as not built-in, so the `builtin` flag in the `/skills` listing under `--output-format json` is accurate and the `/skills` panel groups them correctly.
- Fixed the reasoning-effort description under the timeline gauge in the `/effort` and `/model` pickers overflowing on narrow terminals, where it is now omitted so the gauge stays readable.
- Fixed `/btw` failing with a planner configuration error in conversations driven by a custom or SDK-defined agent, so side questions work regardless of which agent you are running.
- Fixed a failed `/btw` side question always reporting `model returned an empty response`, which was a hardcoded guess rather than the real failure; the card now shows the side question's own error when there is one.
- Fixed the status line, the active-items list and the `/tasks` panel continuing to show background tasks that had already finished.
- Fixed the CLI overwriting a `settings.json` it could not parse with default settings, which silently reverted every setting the next time anything was saved; a refused save now leaves the file byte-identical so you can repair it by hand, and the status line names the file.
- Fixed a subagent whose definition leaves `model` at `inherit` failing to start when the parent agent has no model of its own, which now falls back to the default fast tier.

## 1.1.15

- Added `--input-format stream-json` to print mode, which reads newline-delimited JSON prompts from stdin and runs one turn per message in a single conversation, so a driver can keep a session open.
- Added a `rules:` key to markdown agent frontmatter, so an agent can name rule files directly instead of inheriting your whole rule tree; a rule named this way always applies.
- Added plugin support for a top-level `rules.json`, so a plugin can declare the rule files it ships the same way it already declares its skills.
- Added a more specific hint on the spinner line, which now names the tool call the agent is currently running.
- Fixed the CLI aborting at startup on hosts that preload their own allocator through `LD_PRELOAD`, such as Cloud TPU VM images, where it died before the interface appeared.
- Fixed personal accounts hitting a resource-exhausted error at startup when saved credentials were restored from the system keyring, and cut the repeated account checks that followed.
- Fixed your billing project, and the license tier it selects, being lost when the CLI restarted and restored saved credentials from the system keyring.
- Fixed a spurious "Out of credits" message for enterprise users signed in through Application Default Credentials.
- Fixed the `/model` picker cutting off models, and its own header, on terminals too short to show every model; the list now scrolls.
- Fixed the `/model` picker misaligning its columns for model names that are not plain ASCII, by measuring column widths in display cells rather than bytes.
- Fixed the spinner line flickering to a generic label between quick tool calls.
- Fixed streamed text corrupting non-ASCII characters into replacement characters, in both the interactive display and `--output-format stream-json` text deltas.
- Fixed artifacts written into a subdirectory of a conversation's artifact directory, such as `scratch/`, never appearing in the artifact list.
- Fixed reading a `.wav` file failing as an unsupported media type, by normalizing non-canonical MIME types such as `audio/wave` before they reach the model.

## 1.1.14

- Added a faster return path for enterprise sign-in, so a returning user is offered a single `Continue with ...` option naming the method they last used.
- Added support for OAuth client ID metadata documents when connecting to an MCP server, so servers implementing that part of the specification no longer require a manually supplied client ID or dynamic client registration.
- Improved the `/context` panel, which is now scrollable and sized to the terminal. `/usage` is sized the same way.
- Improved markdown-defined agents with a single `inheritCustomizations` switch that decides whether the agent adopts your skills, rules, plugins, subagents and MCP servers, replacing per-kind defaults that silently disagreed with each other.
- Improved the setting that allows access outside your workspace, which now grants only read access; writes are auto approved according to the cycle mode setting.
- Fixed the CLI exiting silently when its language server failed, both at startup and while running; the failure is now printed to the terminal and the process exits non-zero instead of reporting success.
- Fixed the sign-in URL and other links rendering as garbled text on terminals that do not parse OSC 8 hyperlinks, such as GNU `screen`, which are now detected and given plain text instead.
- Fixed `Enter` being swallowed while the path-suggestion popup was still loading, which sent the prompt and then popped the results open on top of it.
- Fixed the artifact list marking every earlier artifact as approved when reopened, so artifacts that were unreviewed, commented on or rejected in a previous turn keep their real status.
- Fixed one malformed entry in your MCP configuration bringing down every other server, which is now logged and skipped so the remaining servers still load.
- Fixed built-in skills, rules and plugins disappearing from an agent that set `inherit_user` to false, which was only meant to opt out of your personal customizations, not the ones shipped with the CLI.
- Fixed reverting or branching a long conversation failing with `too many SQL variables`.
- Fixed a long conversation's title jumping to an unrelated older message once history was truncated, by protecting the checkpoint the title is derived from.
- Fixed a multi-line paste submitting one prompt per line on terminals that do not honour bracketed paste.

## 1.1.13

- Added support for `GEMINI_API_KEY`, so the CLI can run against the Gemini API directly without signing in. Set `modelProvider: "gemini"` in `settings.json`, export `GEMINI_API_KEY`, and point `GOOGLE_GEMINI_BASE_URL` at a custom endpoint if you need one. The banner and `/help` show `Gemini API key` as the credential, and `/logout` explains that it comes from the environment rather than appearing to end a session.
- Improved `/codesearch` resilience by falling back to a local search when the `ripgrep` binary cannot be executed, such as when an endpoint security agent blocks it.
- Improved artifact list scrolling by caching each file's preview line count, which previously re-read every listed file from disk on every keypress.
- Improved custom agent support by making `manage_task` available to declarative agents that have not opted out of fundamental components, so a custom agent can list and kill its own background tasks, and reworded its step lines to read `Killed task X` and `Checked task X`.
- Improved `search_web` steps by showing the query while the search is still running rather than only after it returns.
- Improved the agent's behavior after backgrounding work by removing the anti-polling reminder text from the `manage_task` and `manage_inbox` tool results, which could itself nudge the model into a polling loop.
- Improved the `/resume` picker by relabeling its second tab, which previously carried a name that did not distinguish it from the first.
- Improved deleting a conversation from the `/resume` picker by moving the keybinding from `ctrl+delete` to `f4`, since macOS terminals disagree on how they report the delete key and the old binding silently did nothing there.
- Improved the time to open a large conversation by loading step headers in batches and no longer reading each step's full payload just to read its type.
- Improved embedded ripgrep reliability and security by saving extracted binaries to the user cache directory instead of /tmp. Added content-addressed SHA-256 verification and atomic renaming to guarantee binary integrity and prevent concurrent execution races.
- Fixed a distorted startup banner in Cloud Shell, where the web terminal mishandles the cursor-optimization escape sequences the renderer emits; a conservative rendering mode now turns on automatically there.
- Fixed the direct Gemini API route parking on the sign-in screen instead of booting straight into the main UI, and fixed model requests failing against a custom endpoint set through `GOOGLE_GEMINI_BASE_URL` by dropping a session field such an endpoint is not guaranteed to support.
- Fixed conversations disappearing from the `/resume` picker after cycling to the second tab and back, which left it reporting `No conversations available`, and kept the `tab` hint in the shortcut bar even when a tab is empty.
- Fixed trajectory truncation destroying nearly all of a long conversation's history, by charging the size budget only against steps whose bytes can actually be reclaimed instead of against protected checkpoints and the unreclaimable residue of already-cleared steps.
- Fixed unbounded growth of the on-disk conversation database in sessions woken by background tasks, subagents or agent messages, where each wake appended duplicate grants and settings to every persisted row.
- Fixed corruption of the saved transcript when a background message appended to it while context compaction was rewriting it, which left malformed JSON that no longer parsed.
- Fixed a hung sandbox setup killing the rest of the conversation, where the step was never unregistered so every later message was silently swallowed and the session appeared dead until a restart.
- Fixed `define_subagent` using a model-supplied agent name directly as a directory name, so a name containing `..` could write its `agent.md` outside the conversation's artifact directory; names are now validated at both the tool and the handler.
- Fixed artifact list rendering, where previews produced garbled text and overflowed the panel on wide CJK or emoji characters, the cursor could point past the end of the list when entries disappeared, and the header and footer lines were left out of the scroll math so the list overflowed its viewport.
- Fixed `Esc` in the artifact viewer showing a spurious submit confirmation for reviews that had completed in earlier turns, and fixed submitting re-reporting those same reviews.
- Fixed `invoke_subagent`, `send_message`, `manage_subagents`, `define_subagent`, and `generate_image` rendering with no tool call line at all in collapsed and expanded tool groups, leaving a bare `(ctrl+o to expand)` hint with no tool name.

## 1.1.12

- Added a heading outline to the artifact viewer, opened with `t`, so a long markdown document's structure is visible at a glance and you can jump straight to a section instead of scrolling.
- Added non-interactive answers for more read-only slash commands in print mode, so `-p "/permissions"`, `/hooks`, `/help`, `/changelog` and `/config` each emit one tab-separated record per line — or a structured payload under `--output-format json` and `stream-json` — without starting an agent turn, spending quota or leaving a conversation behind, with `/help` listing exactly the commands print mode answers and `/changelog` printing the release notes.
- Added machine-readable output to the `models` and `agents` subcommands through an `--output-format` flag accepting `json` and `stream-json`, and moved their error messages and progress spinner off stdout so captured output contains only the list.
- Added a `disable-slash-command: true` flag for a skill's `SKILL.md` frontmatter, which hides that skill from the `/` menu and from `/name` resolution while leaving it discoverable and invocable by the model, so a large skill library no longer floods the command menu.
- Added rendering for alert callouts (`[!NOTE]`, `[!TIP]`, `[!IMPORTANT]`, `[!WARNING]`, `[!CAUTION]`) and for carousel blocks in markdown artifacts, which previously showed as raw markup.
- Improved terminal hyperlink support, enabling clickable links over SSH and in hyperlink-capable `tmux`, keeping word-wrapped URLs clickable past their first line, linking URLs that the markdown renderer had left as plain text including ones inside code blocks, no longer highlighting unrelated links together on hover, and fixing horizontal scrolling and text selection on lines that contain a link.
- Improved tool call headers so every native and MCP tool call carries a short summary of what it is doing instead of a bare name or a raw argument blob, with the same summary naming background tasks and subagents in the activity list and the matching action phrase describing the request in permission prompts.
- Improved headroom for large toolsets by raising the per-session limit on tool declarations, so heavy MCP, plugin and skill setups stop being rejected for having too many tools.
- Improved sign-in with Application Default Credentials by resolving the quota project automatically, so service-account logins work without extra configuration.
- Improved repository detection so a Git repository nested inside a larger multi-repository checkout resolves to the intended root, with submodules and worktrees covered.
- Improved headless `-p` runs so the agent settles a choice itself where it would otherwise ask, instead of stalling on a question nobody is there to answer.
- Improved the `schedule` tool by dropping the redundant `Timer Cancelled` notification when a one-shot timer with an early-termination condition is cancelled, and by naming both the condition and the exact sender whose message satisfied it in the step result.
- Improved file paths in tool step lines by collapsing your home directory to `~` instead of truncating the front of the path, so the interesting end of a long path stays on screen.
- Fixed `--mode` being ignored in headless `-p` runs, where a valid value such as `accept-edits` or `plan` was never applied and an unrecognized value produced no warning at all.
- Fixed startup diagnostics being swallowed into the log file instead of reaching the terminal, including crash notices, the `--conversation` not-found warning, the `--print` and `--prompt-interactive` conflict, conversation load errors, and the `--mode` and `--agent` warnings.
- Fixed a character disappearing from your submitted prompt where it wrapped at the terminal's right edge, caused by the echoed prompt being indented after it had already been wrapped to the full width.
- Fixed file citations in a response losing their line numbers, so a cited range renders as `path:10-25` again instead of just the file name.
- Fixed a write-in answer in a multi-select question discarding the boxes you had already ticked, and fixed a stale write-in being submitted after you went back to a predefined option.
- Fixed large background tasks crowding out the prompt by limiting each active item below the input box to a single line.
- Fixed corruption of `config.json` by writing user config atomically, so a crash or a concurrent writer can no longer leave a truncated file that silently breaks settings persistence.
- Fixed the CLI giving up on a slow OS keyring after one second and falling back to empty storage, which forced a re-login; it now waits five seconds, as every other keyring operation already did.
- Fixed conversation preview titles derived from the first user message by cutting them at the first line and capping them at 500 characters, so a large pasted or scripted prompt no longer produces a multi-megabyte stored title.
- Fixed a crash on Windows when resolving the conversation transcript path, by honoring the path's drive letter in the trajectory log artifact converter.
- Fixed a subagent going silent on its parent when its own message failed to send, and fixed the parent being handed an empty notice when a subagent went idle without a final response.
- Fixed the `read_url_content` tool leaking a connection on every call, which could eventually exhaust the machine's available ports.
- Fixed the status line reporting model quota that was always one fetch out of date, so it now matches the quota you actually have left.

## 1.1.11

- Added a Vim editing mode, off by default and switched on from `/settings` under `Editor Mode`, bringing modal editing to the prompt with Normal, Insert, Visual and Visual Line modes, a mode badge in the status line and a Vim tab in `/help`, and covering the `h`/`j`/`k`/`l`, `w`/`b`/`e` and `W`/`B`/`E` motions, the `0`/`^`/`$`/`gg`/`G` boundaries, the `f`/`F`/`t`/`T` character searches with their `;` and `,` repeats, the `i`/`a`/`I`/`A` insert entries, the `d`/`c`/`y` operators alongside `x`, `D` and `C` filling the unnamed register for `p`, and the `iw`/`aw`/`iW`/`aW`/`ip`/`ap` text objects.
- Added Vim-aware submission so a prompt can be sent without leaving modal editing, through an `Editor Mode > Insert First` toggle that opens the prompt in Insert mode where a bare `Enter` submits and a modified key such as `shift+enter` or `ctrl+j` inserts a newline, `ctrl+s` and `ctrl+enter` keys that submit from Normal mode, an `Enter` binding available as `vim.insert.submit`, and the full set of `vim.*` scopes in `keybindings.json` for remapping any of it.
- Added Vim editing to the comment editors in the diff and artifact-detail views, whose footer hints follow the active mode rather than showing one fixed set of bindings, and made a collapsed block behave as a single unit under Vim motions.
- Added non-interactive answers for the read-only slash commands in print mode, so `-p "/usage"`, `/quota`, `/credits`, `/model`, `/effort` and `/skills` emit one tab-separated record per line — or a structured payload under `--output-format json` and `stream-json` — without starting an agent turn, spending quota, or leaving a conversation behind.
- Added an explicit refusal for the remaining interactive-only slash commands in print mode, which previously fell through as literal prompt text and let the model answer as though the command had run, so `-p "/clear"` reported the context cleared while nothing was cleared; each now fails with the flag or subcommand that replaces it.
- Improved plugin enable and disable so `config.json` is the only place enablement lives, seeded once from each plugin's manifest, which stops a plugin that later ships `"disabled": true` from switching itself off under someone who was already running it and stops a shipped-default change from moving every user on the next release.
- Improved the artifact detail view by wrapping long lines in code files instead of clipping them at the right edge.
- Improved model retries by honoring the server-supplied retry delay instead of the client's own backoff, so a retry after a rate limit or an overload waits exactly as long as the server asks.
- Improved model-loading errors so a permission failure such as a missing license or a missing IAM role is shown as itself, with a troubleshooting link, instead of a generic failure during the run.
- Fixed an allowlist entry that tokenizes to zero command words — `command(time)`, a comment-only entry, or an empty compound such as `()` — matching every command and silently auto-approving anything the agent ran; such an entry now matches nothing.
- Fixed commands being auto-approved while the session was in request-review or strict permission mode.
- Fixed admin controls being skipped for MCP servers at startup, where a fetch made before authentication cached "admin controls not applicable" and allowed every server for the next five minutes, and fixed the built-in Chrome DevTools MCP server being blocked outright by admin controls.
- Fixed MCP progress callbacks being dropped and the task log file not being initialized, so long-running MCP tool calls report progress again.
- Fixed a slash command receiving the collapsed `[Pasted text #N]` placeholder instead of the pasted content when its argument was pasted into the prompt.
- Fixed the prompt saving the typed prefix rather than the completed command name to history when an autocompleted slash command was submitted, so up-arrow recall replays what actually ran, and made an alias require an exact match before auto-executing so a partial alias fills the prompt instead of running a command you did not finish typing.
- Fixed an asynchronous settings refresh re-enabling the feedback survey partway through a print-mode run that had switched it off.
- Fixed spurious "Out of credits" errors, where an empty credits response was read as a balance of zero.
- Fixed the "Use AI Credits" setting being offered to accounts signed in through a Google Cloud project or application default credentials, where it does not apply.

## 1.1.10

- Added Business sign-in for Gemini Enterprise accounts, so you can authenticate with a Google Cloud project under Google Cloud terms, use a license seat allocated or auto-assigned from your organization's GE-Standard or GE-Plus subscription, run inference in a chosen region, and have your organization's administrator controls applied to various features.
- Added Workforce Identity Federation sign-in for enterprise users, available as the `Use advanced SSO config` option on the Google Cloud sign-in screen, so organizations that federate identity through an external provider can authenticate with their own identity provider.
- Added sign-in with Application Default Credentials so you can use Agent Platform.
- Added a non-blocking advisory banner when the same conversation is already open in another CLI instance on the same machine, pointing at `/fork` so two sessions no longer interleave writes into one trajectory.
- Improved the terminal sandbox by granting read-only rather than writable access to a Git repository's `.git` directory, so the agent can inspect repository metadata without being able to rewrite it from inside the sandbox.
- Improved hook ordering so hooks defined in `hooks.json` run before the built-in termination checks, which lets `PostInvocation` hooks observe the final invocation of a turn and lets `Stop` hooks run at all instead of sitting unreachable behind the built-ins.
- Improved the `schedule` tool to accept `DurationSeconds` and `MaxIterations` when a model emits them as bare JSON numbers rather than strings, accepting integral values and rejecting non-integral ones with a clear error instead of failing the call.
- Fixed `--model` and `--effort` being ignored in interactive sessions and in headless `-p` runs, where the flags were applied after model configuration had already been initialized so the run silently fell back to the persisted or default model.
- Fixed a bare `--effort` resolving against the default model instead of the model you actually have selected, which could silently move you to a different model.
- Fixed stopping a subagent tree stopping only the conversation it was invoked from, while every descendant subagent and the background tasks they owned kept running and the CLI still reported them as killed.
- Fixed a forced-continuation deadlock where a coordinator waiting on active subagents or background tasks would loop injecting empty continue steps until it hit the invocation limit, wasting tokens and blocking progress.
- Fixed the spacebar not toggling an option in multi-select prompts, including the `ask_question` dialog and the onboarding import checkbox, which left `x` as the only working toggle; the hint bar now advertises it.
- Fixed the Left and Right arrow keys being captured to navigate the input box suggestion dropdown, so you can move the cursor and edit text again while suggestions are showing.
- Fixed the model picker's "No models available" state rendering without its header and footer, so it now shows the standard chrome and an `esc` hint to go back.
- Fixed tools that an MCP server marks to always run in the background executing as blocking calls that stalled the turn.
- Fixed an MCP process leak when a server connection dropped unexpectedly.
- Fixed the artifact viewer corrupting plain documents by horizontally clipping every document rather than only the diagram artifacts that need it.
- Fixed the sandbox not recording blocked network requests when the command itself exited successfully, which hid the fact that a request had been denied.

## 1.1.9

- Added slash-command and skill expansion to print mode, so a headless run such as `-p "/my-skill review this diff"` now resolves and applies the skill instead of sending it as literal text, with `--disable-slash-commands` to opt out.
- Improved interactive startup so a slow or hanging MCP server no longer stalls the first agent turn, loading MCP servers in the background for the interactive session while headless and one-shot runs keep blocking so their single scripted turn still sees the full toolset.
- Improved permission grants so a pattern approved at a prompt is recorded for the rest of the conversation, letting later commands that match it run without prompting again.
- Improved the default system temporary-directory grant to cover writes as well as reads, so agents no longer trigger a permission prompt when creating or updating files there.
- Fixed stop hooks that always block hanging the agent forever; after a configurable number of consecutive continuations, the hook can no longer block and the turn ends normally.
- Fixed `PostToolUse` hooks firing on non-tool steps such as user input and model responses, which also caused them to ignore their configured matchers.
- Fixed slash commands not being recognized when separated from their arguments by a newline or tab, so a prompt starting with a command followed by a newline is now parsed as a command instead of being sent verbatim.
- Fixed deleting into a collapsed paste placeholder removing one character at a time, which left a visible fragment in the prompt while the full pasted content was still submitted; the block is now deleted atomically.
- Fixed the artifact viewer losing syntax highlighting when returning from the editor view, and returning to the wrong panel when exiting the artifact detail view.
- Fixed the headless `stream-json` `init` event advertising tools that are not available in your build.
- Fixed MCP servers forcing a full re-authentication after a dropped connection.

## 1.1.8

- Print mode (`-p` / `--print`) now supports structured, machine-readable output via the `--output-format` flag (`text` (default), `json`, or `stream-json`), so headless runs in CI, eval harnesses, and scripts can consume the CLI's output programmatically; these flags are now discoverable in `--help`.
- Added the `stream-json` output format: a strongly-typed NDJSON event stream that emits typed `init`, `step_update`, and terminal `result` events with a stable, closed-vocabulary `step_type` discriminator, so consumers receive progress incrementally instead of waiting for the whole run to finish.
- Added the `--json-schema` flag to enforce a custom JSON schema on the structured output, accepting either an inline schema string or a path to a schema file; for `stream-json` the schema applies to the final `result` event.
- Enriched the structured stream with a `tool_info` object for each tool call (canonical tool name, parameters, and output) and a `subagent_info` payload for delegated subagents (including `conversation_id` and `log_uri`) so consumers can correlate child trajectories.
- The JSON usage object emitted by `json` and `stream-json` now reports token accounting including `cache_read_tokens`, so non-interactive consumers can attribute prompt-cache hits.
- Added a `copyOnSelect` setting (default on, toggleable in `/settings`) that controls whether releasing a mouse text-selection auto-copies it to the system clipboard in the TUI's altscreen rendering mode; disable it to stop the automatic copy on release — useful when the auto-copy is unwanted or corrupts certain payloads.
- Improved compound-command permissions so an exact chained command (such as `git fetch && git rebase`) can be saved as an allow-always rule and no longer re-prompts on the next identical run.

## 1.1.7

- Improved permission prompts for compound shell commands so the full command is shown when any part of it needs approval.
- Fixed disabled plugins still running their hooks and contributing other customizations, which could keep a broken hook active and break file-editing tools even after the plugin was turned off.
- Fixed MCP OAuth against providers that do not strictly follow the spec (such as Salesforce and Atlassian) by relaxing issuer validation and including the `refresh_token` grant.
- Fixed `/btw` failing with a "parent conversation not found" error when used as the very first action in a fresh session.
- Fixed clipboard corruption of CJK and other non-ASCII text when copying on Windows.
- Fixed print mode (`-p`) sending a prompt before the account-eligibility check finished.

## 1.1.6

- Custom Agents (Markdown Format). Added support for defining custom agents using Markdown files (`agent.md`) with YAML frontmatter and H1-delimited system prompts. Markdown agents support `mainAgent`, `subagent`, `hidden`, `inheritMcp`, and `commandExecutionPolicy` frontmatter fields for fine-grained control over agent behavior. Dynamically defined subagents (via `define_subagent`) now also write Markdown format so they resolve correctly on external builds.
- Added an optional index argument to `/copy` so `/copy <n>` copies the n-th most recent response to the clipboard, while `/copy` and `/copy 1` still copy the latest.
- Improved `/codesearch` to render results progressively as they stream in, showing a live count while loading and letting you cancel an in-flight search with `Esc` instead of blocking until the whole search finishes.
- Improved default file access by granting read access to the system temporary directory out of the box, resolved correctly per platform, so agents no longer trigger permission prompts when reading temporary files.
- Improved support for markdown-based custom agents so custom agent management and selection behave more consistently.
- Improved customization discovery by sorting rules and discovered paths deterministically, preventing unstable prompt ordering and needless prompt-cache misses.
- Improved overall reliability and stability across the CLI with additional hardening and fixes for intermittent failures in background tasks, print mode, and interactive flows.
- Fixed switching from a custom agent back to the default agent via `/agents`, which previously failed silently and left the conversation stuck on the custom agent's persona.
- Fixed a crash when a command was blocked by sandbox permissions before its output was captured, and cleaned up the permission approval and denial messages.
- Fixed the artifact viewer emitting garbage escape bytes when cycling to image mode on terminals that are detected but cannot actually render Kitty graphics, such as iTerm2.
- Fixed the first keystroke (such as `Esc`) being dropped when opening the first artifact view on some non-Kitty terminals.
- Fixed conversation jitter and a stranded input box during streaming so transient markdown reflow no longer shifts the pending line and input box upward.
- Fixed print mode (`-p`) surfacing the real conversation-creation failure instead of a misleading "no active conversation" error.
- Fixed the message list dropping its header when rewinding or resetting conversation steps.
- Fixed a background auto-updater double-spawn race where two processes could each spawn an updater within a single update window.
- Fixed sandbox error reporting so blocked actions are recorded even when the network proxy is disabled.
- Fixed the screen going blank after the authentication page.
- Fixed the `ctrl+b` shortcut being hardcoded to background shell commands even when none were running, so a remapped `ctrl+b` is now respected whenever there are no running shell commands in the conversation.

## 1.1.5

- Added a `/effort` command to view and change the current model's reasoning effort, with a left/right timeline-gauge picker and a direct `/effort <level>` form so you can trade latency for depth on the fly.
- Added an `--effort` flag to select a model's reasoning-effort variant when launching the CLI.
- Added stable, user-facing model slugs that appear in the `/model` picker and are accepted by `--model`, so you can pin a specific model reliably across sessions.
- Added a `model` option to custom agent frontmatter so an agent runs at a chosen model tier (such as `flash` or `pro`) when invoked as a subagent, defaulting to `inherit` (the parent's model).
- Redesigned the `/model` picker to group models by their base model and choose reasoning effort from a timeline gauge navigable with Left and Right, and added an effort badge to the status line for models that expose multiple effort variants.
- Improved the `/settings` (`/config`) panel by making it a bounded, scrollable list so it renders correctly in short terminals instead of overflowing, and stopped it from flickering when opening and closing dropdowns.
- Improved background-task reliability by moving long-running work onto a shared lifecycle with deterministic startup and shutdown and panic-safe launching, so a failure in one background task no longer disrupts the session and pending analytics are flushed on exit instead of dropped.
- Improved responsiveness of bursty background refreshes by coalescing rapid repeated triggers into a single run, cutting redundant work.
- Fixed a crash when triggering Authenticate on a remote MCP server in the `/mcp` panel.
- Fixed MCP tool results containing embedded resources being silently dropped, so text and inline media returned by MCP servers now surface in the conversation.
- Fixed permission checks splitting a single command into a pipeline when an argument contained quoted shell metacharacters (such as `--grep="a|b"`), which caused spurious permission prompts.
- Fixed the file-view and file-search tools failing with invalid-UTF-8 errors when a multi-byte character was split at a truncation boundary.
- Fixed a data race when collecting customization rules by guarding the shared structures.

 ## 1.1.4

- Added support for stacking multiple leading slash commands in a single prompt, so a chain like `/plan /grill-me <prompt>` parses, activates, and renders every command in the order you typed them.
- Improved scrolling in the `/diff` viewer so paging through a diff no longer jitters or pushes the status line off the screen when lines wrap or comments expand.
- Fixed custom agents that declare `subagent: false` still appearing in the available-subagents list and being invocable as subagents.
- Fixed headless (`-p` / `--print`) runs so they now honor persisted `settings.json` policies, including `permissions`, file access, sandbox mode, auto-execution, and artifact review.
- Fixed `/btw` side-questions leaking into the conversation list as duplicate entries that carried the parent conversation's title.
- Fixed the prompt to honor a custom Enter binding to `prompt.insert_newline`, so a remapped Enter inserts a newline instead of submitting.
- Fixed eligibility error messages so the CLI shows the real reason again instead of defaulting to a generic "unknown reason".

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
