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

[Home](https://antigravity.google/docs/home)

Antigravity 2.0 chevron\_right

Antigravity CLI expand\_more

[Overview](https://antigravity.google/docs/cli/overview)

[Getting Started](https://antigravity.google/docs/cli/getting-started)

[Installation & Auth](https://antigravity.google/docs/cli/install)

[Tutorial](https://antigravity.google/docs/cli/tutorial)

[Using AGY CLI](https://antigravity.google/docs/cli/using)

[Features](https://antigravity.google/docs/cli/features)

[Gemini Migration](https://antigravity.google/docs/cli/gcli-migration)

[Prompting](https://antigravity.google/docs/cli/prompting)

Artifacts chevron\_right

[Conversations](https://antigravity.google/docs/cli/conversations)

Agent Capabilities chevron\_right

[Projects](https://antigravity.google/docs/cli/projects)

Settings expand\_more

[Overview](https://antigravity.google/docs/cli/settings)

[AI Credits](https://antigravity.google/docs/cli/credits)

Customizations chevron\_right

Commands chevron\_right

[Best Practices](https://antigravity.google/docs/cli/best-practices)

[Troubleshooting](https://antigravity.google/docs/cli/troubleshooting)

[Reference](https://antigravity.google/docs/cli/reference)

Antigravity SDK chevron\_right

Antigravity IDE chevron\_right

Migration chevron\_right

[Enterprise](https://antigravity.google/docs/enterprise)

[Plans](https://antigravity.google/docs/plans)

[FAQ](https://antigravity.google/docs/faq)

- side\_navigation
- Antigravity CLI
>- Settings
>- Overview

# Settings, rendering & keybindings [link](https://antigravity.google/\#settings-rendering-keybindings)

Configure persistent preferences, customize keyboard shortcuts, toggle terminal display buffers, and manage runtime CLI parameter overrides.

## Setting up preferences [link](https://antigravity.google/\#setting-up-preferences)

Antigravity CLI stores user preferences in a minimal, forward-compatible JSON configuration profile.

### Configuration file location [link](https://antigravity.google/\#configuration-file-location)

The persistent settings are saved in a plain JSON format:

text

content\_copy

```
            ~/.gemini/antigravity-cli/settings.json

```

The CLI leverages **sparse persistence** by writing only values to disk that differ from their system defaults. This keeps your configuration file clean, minimal, and fully forward-compatible with future updates.

### The interactive settings panel [link](https://antigravity.google/\#the-interactive-settings-panel)

To edit settings directly inside your active terminal session without opening raw JSON files:

1. Type `/config` (or its alias `/settings`) inside the prompt panel and press `Enter`.
2. The full-screen **Settings Editor Overlay** opens.
3. Navigate between available options using `↑`/`↓`.
4. Press `Enter` on a highlighted parameter to toggle its state or open a text insertion field.
5. Press `Esc` to save your modifications and close the editor.

![The interactive settings panel](https://antigravity.google/assets/image/docs/cli/settings-interactive-panel.png)

## Command-line overrides [link](https://antigravity.google/\#command-line-overrides)

You can temporarily override persistent preferences for individual terminal sessions using CLI command flags:

bash

content\_copy

```
            agy --sandbox --model="Gemini 3.5 Flash"

```

When an override flag is active, the interactive `/config` menu displays a warning indicator alongside the modified setting:

text

content\_copy

```
            ! Tool Permission: strict (overridden by command flag)

```

You can still edit the persistent value on disk during these sessions, but the CLI enforces the active runtime flag override until you close the session.

## Visual rendering modes [link](https://antigravity.google/\#visual-rendering-modes)

The TUI operates in one of two visual rendering modes depending on your terminal capability and connection latency.

### Alt-screen mode (\`always\`) [link](https://antigravity.google/\#alt-screen-mode-always)

This mode opens a dedicated display screen using the terminal's alternate buffer, creating an immersive, standalone app interface.

- **Key features**: Integrated scrollback, mouse-wheel scrolling support, custom rendered scrollbar, and clean terminal state restoration on exit.
- **Best used for**: Standard local development sessions in advanced terminal emulators (such as iTerm2, Ghostty, or WezTerm).

### Inline mode (\`never\`) [link](https://antigravity.google/\#inline-mode-never)

This mode renders output sequentially directly within your terminal's standard stdout pipeline.

- **Key features**: Preserves entire session history inside your emulator's native scrollback buffer, does not capture mouse inputs, and works seamlessly alongside standard command outputs.
- **Best used for**: Remote SSH terminals, terminal multiplexers like `tmux` or `screen`, and low-bandwidth remote sessions.

info

**Adaptive Rendering**: Setting Alt-Screen mode to `default` allows the TUI to automatically detect your environment. It defaults to Alt-Screen on advanced local shells and degrades to Inline mode when running over SSH or in non-interactive sessions.

## Configuration options reference [link](https://antigravity.google/\#configuration-options-reference)

The interactive settings panel (`/config`) and `settings.json` allow you to customize the CLI's behavior across several categories.

### Safety & permissions [link](https://antigravity.google/\#safety-permissions)

Manage how the agent interacts with your system and codebase:

- **Tool Permission (`toolPermission`)**: Controls the authorization flow for tools (such as running terminal commands).
- `request-review` (Default): Prompts for your approval before running write, bash, or web tools.
- `proceed-in-sandbox`: Automatically runs terminal commands if they are sandboxed; otherwise prompts for review.
- `strict`: Prompts for all non-read tools, ensuring maximum control.
- `always-proceed`: Runs all tools without prompting (highest risk, use with caution).
- **Artifact Review (`artifactReviewPolicy`)**: Controls when the agent prompts you to review generated artifacts (like code files) before writing them to disk.
- `asks-for-review` (Default): Always prompts you to review changes.
- `agent-decides`: The agent decides whether to prompt based on the complexity of the change.
- `always-proceed`: The agent writes changes directly without prompting (maximizes autonomy, but increases risk of overwriting code without review).
- **Sandbox Mode (`enableTerminalSandbox`)**: When enabled (`on`), restricts all agent-initiated terminal commands to a secure OS container.
- **Non-Workspace Access (`allowNonWorkspaceAccess`)**: Controls whether the agent can read or write files outside your active project directories. Set to `off` by default for safety.

### Display & rendering [link](https://antigravity.google/\#display-rendering)

Customize the visual experience of the TUI:

- **Rendering Mode (`altScreenMode`)**: Controls how the TUI utilizes your terminal buffer.
- `default`: Adaptive mode. Uses Alt-screen on advanced local terminals and degrades to inline mode over SSH.
- `always`: Forces Alt-screen mode, providing an immersive, page-based interface with mouse support and scrollbars.
- `never` (configurable via `settings.json`): Forces inline mode, rendering output sequentially and preserving history in your emulator's scrollback.
- **Color Scheme (`colorScheme`)**: Selects the visual theme. Options include `terminal` (inherits shell colors), `dark`, `light`, `solarized dark/light`, `tokyo night`, and colorblind-friendly variants.
- **Animation Speed (`runningLightSpeed`)**: Adjusts the speed of the progress indicator animation (`fast`, `medium`, `slow`, or `off`).
- **Verbosity (`verbosity`)**: Controls detail level. `high` shows full agent thoughts and tool steps; `low` shows only minimal progress indicators.

### Editor & notifications [link](https://antigravity.google/\#editor-notifications)

Configure integrations with your host environment:

- **Editor (`editor`)**: The text editor used to view artifacts or compose prompts (via `Ctrl+G`). Defaults to `auto` (respects `$EDITOR`), but can be set to `vim`, `emacs`, or others.
- **Notifications (`notifications`)**: When enabled (`on`), triggers a system desktop notification and a terminal bell chime when a long-running task completes or requires your attention.

### AI Credits & Feedback [link](https://antigravity.google/\#ai-credits-feedback)

Manage usage, tips, and telemetry:

- **Use AI Credits (`useG1Credits`)**: _External builds only._ When enabled (`on`), allows the CLI to use your personal AI credits for model calls if your plan's standard quota is exhausted.
- **Enable Telemetry (`enableTelemetry`)**: Helps Google improve the tool by sending anonymous usage statistics and crash reports.
- **Show Tips (`showTips`)**: Toggles the display of helpful usage tips while the agent is generating responses.
- **Show Feedback Survey (`showFeedbackSurvey`)**: Enables periodic brief surveys after task completions to help improve the experience.

## Custom status lines & terminal titles [link](https://antigravity.google/\#custom-status-lines-terminal-titles)

For advanced TUI environment integrations, you can toggle active metrics or deploy custom scripts to generate dynamic status bars and modify your terminal window titles:

- **[Status Line Customization](https://antigravity.google/docs/cli/commands/statusline)**: Learn how to manage the status indicator panel and construct custom formatted status line shell scripts.
- **[Terminal Title Customization](https://antigravity.google/docs/cli/commands/title)**: Learn how to toggle window title outputs and pipe live agent states into your window headers.

## Keybindings configuration [link](https://antigravity.google/\#keybindings-configuration)

You can customize almost all keyboard shortcuts in the TUI by mapping keys to specific workspace commands.

### Keybindings file location [link](https://antigravity.google/\#keybindings-file-location)

Custom maps are stored alongside your primary settings profile:

text

content\_copy

```
            ~/.gemini/antigravity-cli/keybindings.json

```

### Format and customization [link](https://antigravity.google/\#format-and-customization)

The JSON structure maps a single TUI command action to an array of hotkey sequences:

json

content\_copy

```
            {
  "cli.clear_screen": [\
    "ctrl+l"\
  ],
  "prompt.insert_newline": [\
    "shift+enter",\
    "ctrl+j"\
  ],
  "edit.open_editor": [\
    "ctrl+g"\
  ]
}

```

To completely disable a default hotkey, map its action to an empty array `[]`. If your JSON schema is malformed or invalid, the CLI falls back to system defaults for those specific actions and loads the remaining valid mappings.

warning

**Protected Keys**: Crucial navigation shortcuts like `cli.exit` (`Ctrl+D` / `Ctrl+C`) and `cli.enter` (`Enter`) are protected by the system and cannot be disabled.

### Restoring defaults [link](https://antigravity.google/\#restoring-defaults)

To revert all keys back to system defaults, delete the keybindings profile:

bash

content\_copy

```
            rm ~/.gemini/antigravity-cli/keybindings.json

```

## Next steps [link](https://antigravity.google/\#next-steps)

Now that you have configured your environment, review security controls and extensibility options:

- **[Permissions & Sandbox](https://antigravity.google/docs/cli/sandbox)**: Manage secure execution containment boundaries.
- **[Plugins & Skills](https://antigravity.google/docs/cli/plugins)**: Create your own custom skills and import legacy plugins.
- **[CLI Reference](https://antigravity.google/docs/cli/reference)**: Access quick reference sheets listing all configuration options, commands, and default key maps.

[Sandbox](https://antigravity.google/docs/cli/sandbox)

[AI Credits](https://antigravity.google/docs/cli/credits)

On this Page

- Settings, rendering & keybindings

- Setting up preferences

- Command-line overrides

- Visual rendering modes

- Configuration options reference

- Custom status lines & terminal titles

- Keybindings configuration

- Next steps