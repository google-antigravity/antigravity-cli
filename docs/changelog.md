[Google Antigravity](https://antigravity.google/)

Products keyboard\_arrow\_down

Use Cases keyboard\_arrow\_down

Pricing

Blog

Resources keyboard\_arrow\_down

Download download

menu

Products keyboard\_arrow\_down

Explore our next generation products

[See overview](https://antigravity.google/product)

Products

[antigravity Antigravity 2.0](https://antigravity.google/product/antigravity-2) [terminal Antigravity CLI](https://antigravity.google/product/antigravity-cli) [code Antigravity IDE](https://antigravity.google/product/antigravity-ide) [sdk Antigravity SDK](https://antigravity.google/product/antigravity-sdk)

Use Cases keyboard\_arrow\_down

Built for developers in the agent-first era

[See overview](https://antigravity.google/use-cases)

[Enterprise](https://antigravity.google/use-cases/enterprise) [Frontend](https://antigravity.google/use-cases/frontend) [Fullstack](https://antigravity.google/use-cases/fullstack) [Science](https://antigravity.google/use-cases/science) [Marketer](https://antigravity.google/use-cases/marketer)

Pricing  Blog  Resources keyboard\_arrow\_down

Everything you need to stay up-to-date and get help

[Documentation keyboard\_arrow\_right](https://antigravity.google/docs) [Changelog](https://antigravity.google/changelog) [Support](https://antigravity.google/support) [Press](https://antigravity.google/press) [Releases](https://antigravity.google/releases)

![](https://antigravity.google/assets/image/antigravity-cursor.png)
Google Antigravity Changelog

G

o

o

g

l

e

A

n

t

i

g

r

a

v

i

t

y

C

h

a

n

g

e

l

o

g

[View docs](https://antigravity.google/docs)[Follow us on X](https://x.com/antigravity)

Antigravity 2.0  Antigravity IDE

info

New versions are rolled out gradually and may take a few days to reach all users.

Version

Description

* * *

2.3.1

July 16, 2026

### Startup stability fix

Fixes a bug where an empty or malformed configuration file caused AGY to fail to load on startup.

Improvements (0)

Fixes (0)

Patches (1)

- Fixed a bug where an empty or malformed \`config.json\` configuration file in the \`~/.gemini/config/\` directory prevented AGY from loading on startup.

2.3.0

July 13, 2026

### Queued messages, plain text files support, and stability improvements

Added support for queued messages, settings to configure message execution, a send now option, plain text file attachments, and various bug fixes and improvements.

Improvements (10)

- Added support for queued messages with settings to configure execution behavior and a 'Send Now' option for immediate delivery.
- Added support for attaching and rendering plain text (.txt) files in conversations.
- Improved startup performance by optimizing file watching.
- Adjusted the vertical positioning of the comment button in diff views to align better with the code.
- Improved the layout, count badge, and styling of the Queued Messages card in the chat input area.
- Improved stability by automatically retrying when encountering intermittent backend overload errors.
- Improved teamwork reliability by ensuring helper agents do not hang when requesting feedback on created files.
- Improved application startup performance by optimizing the initialization sequence.
- Improved command permission prompting by defaulting to strict literal matching, relaxing checks on commands with redirection, and ignoring global wildcards in sandbox configuration.
- The UI default theme now respects system preferences instead of defaulting to dark mode.

Fixes (5)

- Fixed find-in-page (Cmd+F) search to correctly locate and highlight matches in virtualized file views.
- Improved side questions (/btw) with persistence across conversation switches, display of the agent's thinking process, and a fix for background retries when closed.
- Stopped background tasks from continuing to run after a conversation is archived.
- Fixed an issue where diffs for files with more than 1000 lines rendered incorrectly.
- Fixed an issue where the agent could hang indefinitely after subagents finished executing.

Patches (0)

2.2.1

June 25, 2026

### Antigravity Guide, audio support, search improvements, and performance fixes

New built-in Antigravity Guide skill, audio file rendering, improved substring file search, performance optimizations, and critical bug fixes.

Improvements (19)

- Added a new built-in Antigravity Guide skill to provide helpful guidance when users ask about Antigravity.
- Added syntax highlighting for C++, Python, and Protobuf files in markdown code and diff blocks.
- Added hover tooltips to file pills in the chat and workspace views to display absolute paths and clarify workspace locations.
- Improved readability of context pills by truncating long labels and adding hover tooltips to view the full content.
- Enabled automatic saving of refreshed OAuth tokens to the OS keyring to reduce authentication prompts.
- Added support for rendering and playing audio files (.mp3, .wav, .ogg, .m4a) within the sidebar file viewer and artifact viewer.
- Added a new 'Conversation Width' setting under Appearance settings, allowing you to configure the maximum width of the conversation panel (Default, Narrow, or Wide).
- When creating a new project, Antigravity 2.0 will now notify you if a project with the same folders already exists, allowing you to quickly navigate to it.
- Added a tooltip to show the full task summary when hovering over items in the Running Items panel.
- Improved the model selector dropdown to dynamically resize and prevent truncation of long model names.
- Updated the permissions request dialog to display a clear description of the action or command being run.
- Improved response time and reliability of account status checks when Terms of Service violations are encountered.
- Improved UI responsiveness and eliminated lag when resizing the sidebar layout.
- Aligned theme colors, font sizes, text size, and line height in the chat input area to match surrounding UI density and ensure consistent rendering.
- Improved usability for touch and stylus users by increasing the size of various UI hit targets, including buttons, pills, and toolbars.
- Adjusted the diff viewer layout to provide more horizontal space for code contents.
- Added a brief delay before displaying tooltips for long conversation titles in the sidebar.
- Optimized file watching notifications to prevent visual flickering and improve performance during high-frequency file writes.
- Updated icons for built-in slash commands and redesigned mentions/slash commands menu alignment in the chat input box.

Fixes (17)

- Fixed an issue with broken text selection anchoring when adding comments to files or artifacts.
- Fixed an issue where workspace context was lost when navigating to the history page or other views.
- Fixed performance issues, rendering loops, and lag when navigating folders using the file path breadcrumbs or the file tree.
- Fixed erratic behavior and lag in slash command autocomplete during network instability.
- Improved file search in your workspace by matching substrings instead of requiring exact prefix matches.
- Fixed an issue where file search within workspaces could fail with a 'No such file or directory' error.
- Fixed an issue where allowing commands with special characters (like dots or environment variables) could trigger an infinite permission prompt loop.
- Improved command execution permission matching to support prefix-matching for build/test commands and correct handling of quoted arguments.
- Fixed issues where in-progress prompts and local history edits were discarded during navigation or permission checks.
- Fixed an issue where custom theme settings and color modes were not correctly applied on startup, including rejecting hex codes with a leading '#' symbol.
- Fixed startup issues and recurring User Account Control (UAC) prompts on Windows by registering a scheduled task and resolving access control errors on system PATH directories.
- Fixed crashes and synchronization issues when deleting persistent state across tabs.
- Improved accessibility and usability of the artifact review dialog, including contrast, tooltips, and error messaging.
- Fixed an issue where the agent was blocked from reading builtin customizations and skills due to sandbox restrictions.
- Fixed a startup race condition that could cause duplicate project folders to be created.
- Fixed a deadlock issue that could cause subagents to hang during execution.
- Fixed a potential crash when calculating token usage.

Patches (0)

2.1.4

June 11, 2026

### Quota Screen Redesign and PDF Support

Quota screen redesign, PDF attachment support, new /btw slash command, and other bug fixes

Improvements (7)

- Quota screen redesign: clearer, unambiguous view into “used” versus “remaining” credits in the Models tab of the Settings screen.
- Ask side questions via /btw: while in a conversation, type ‘/btw’ in the input and select the ‘btw’ option in the menu to write a message to an ephemeral, single-response agent that has the context of your current conversation.
- Simple conversation search functionality: cmd/ctrl+F to search for visible text in the conversation view.
- Support for PDF attachments to messages to Gemini models: drag and drop PDFs from your filesystem or add PDFs using the media option in the Add Context menu button in the input box.
- Breadcrumbs in file viewer pane header: quality-of-life UI to more easily see and navigate directories in your repo.
- Nested subagents in the overview pane: see all nested subagents belonging to the main conversation instead of only the subagents that are one level deep.
- Minor improvements to Projects UX: you can now specify a project name during the creation flow and sort conversations in the left sidebar by worktree.

Fixes (4)

- Improved LaTeX support: the agent has a better understanding and awareness of its ability to output LaTeX-rendered math text.
- Improved MCP server stability: increased resilience to unresponsive MCP servers and improved browser agent self-troubleshooting abilities when using the Chrome DevTools MCP server.
- MCP server schema compatibility: the mcp\_config.json schema now accepts url in addition to serverUrl as a field.
- New entries in the sensitive paths list: .vscode and .cache are now recognized as sensitive paths that require explicit user confirmation before the agent can access them.

Patches (0)

2.0.11

June 3, 2026

### Antivirus and Open IDE fixes

Startup and Open IDE button fixes

Improvements (0)

Fixes (2)

- Fixed an issue that occurs when certain antivirus products are installed that caused a dark blank screen on app startup.
- Fixed some bugs related to the Open IDE button.

Patches (0)

2.0.10

May 28, 2026

### AGY 2.0 Bug fixes

AGY 2.0 Bug fixes

Improvements (1)

- Various reliability and usability improvements

Fixes (1)

- G1 credit bug fix

Patches (0)

2.0.6

May 22, 2026

### Antigravity IDE integration

Added integration with Antigravity IDE.

Improvements (2)

- Add an install IDE button if Antigravity IDE is not installed.
- Add an open IDE button if Antigravity IDE is installed which allows you to open the current project in Antigravity IDE.

Fixes (0)

Patches (0)

2.0.1

May 19, 2026

### AGY 2.0 Bug Fixes

Antigravity 2.0 Launch bug fixes.

Improvements (0)

Fixes (3)

- Fixed project migration issues for projects with CJK characters in their titles.
- Fixed an issue that caused duplicate projects to be created when importing from Antigravity 1.0.
- Resolved an issue where Google One credits were not being applied or utilized.

Patches (0)

Experience liftoff

[Download](https://antigravity.google/download) [Product](https://antigravity.google/product) [Docs](https://antigravity.google/docs) [Changelog](https://antigravity.google/changelog) [Press](https://antigravity.google/press) [Releases](https://antigravity.google/releases)

[Blog](https://antigravity.google/blog) [Pricing](https://antigravity.google/pricing) [Use Cases](https://antigravity.google/use-cases)

[Google](https://www.google.com/)

[About Google](https://about.google/) [Google Products](https://about.google/products/) [Privacy](https://policies.google.com/privacy?hl=en-US) [Terms](https://antigravity.google/terms) Manage cookies