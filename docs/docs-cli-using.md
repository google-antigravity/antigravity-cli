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

Antigravity CLI chevron\_right

Antigravity SDK chevron\_right

Antigravity IDE chevron\_right

Migration chevron\_right

[Enterprise](https://antigravity.google/docs/enterprise)

[Plans](https://antigravity.google/docs/plans)

[FAQ](https://antigravity.google/docs/faq)

- side\_navigation
- Antigravity CLI
>- Using AGY CLI

# Using AGY CLI [link](https://antigravity.google/\#using-agy-cli)

### Settings [link](https://antigravity.google/\#settings)

Antigravity CLI provides a flexible configuration system to customize workspace behavior, safety restrictions, editor preferences, visual style, and performance.

- **Configuration File**: Stored in a plain JSON file `~/.gemini/antigravity-cli/settings.json`.
- **Settings Panel**: Type `/config` or `/settings` to open a full-screen overlay menu listing all available options.
- Select a setting to open its list of options or a text input field.
- Immediately save your selection to the disk and return to the main list.
- **Overrides**: Certain settings can be overridden at launch via CLI flags (e.g., `--sandbox` or `--dangerously-skip-permissions`).
- The settings menu will display an indicator showing where the override came from (e.g., _Sandbox Mode on overridden by `--sandbox`_).
- You can still edit the persistent setting on disk, but the current session will enforce the command-line override until restarted.

### Quick Tips [link](https://antigravity.google/\#quick-tips)

| Action/Feature | Tip/Command |
| --- | --- |
| **Auto-complete to file paths** | `@` will trigger path suggestions |
| **Clear Prompt** | Type `esc esc` to clear your prompt box (when no streaming is active) |
| **Terminal Commands** | Use `!` at the start of your prompt to run terminal commands directly |
| **Help** | Type `?` to get help and list all slash commands |
| **Reduce Noise from Tool Calls** | Set verbosity to **low** in `/config` to minimize outputs from numerous tool calls |
| **Manage Permissions** | Control permissions via `/config` or `/permissions` |
| **Go Back in Conversation** | Use `/rewind` or `/undo` to rewind the conversation history |
| **Fork Conversation** | Use `/fork` to spin up a separate workspace and branch the conversation from an earlier point |
| **Clear Conversation** | Use `/clear` to clear the prompt and start a new conversation session |
| **Resume Conversation** | Use `/resume` to list and resume previous conversation logs |
| **Auto-Save Resume** | When you close the CLI, it automatically prints the exact command needed to resume that specific session |

### Keybindings [link](https://antigravity.google/\#keybindings)

AGY CLI allows for custom keybindings. You can edit them by typing `/keybindings` or modifying the JSON file directly.

- **File Location**: `~/.gemini/antigravity-cli/keybindings.json`.
- **Reset**: To reset to default, delete the `keybindings.json` file.

**Default Keybindings**

| Action/Command | Keys | Purpose |
| --- | --- | --- |
| **Clear TUI Screen** | `ctrl+l` | Clear terminal output |
| **Enter / Submit** | `enter` | Submit prompts or choices |
| **Escape / Cancel** | `ctrl+c`, `esc` | Stop stream, close menus, or clear prompt |
| **Exit CLI** | `ctrl+d` | Terminate CLI TUI session |
| **Suspend CLI** | `ctrl+z` | Push CLI session to terminal background |
| **Edit Command** | `e` | Open editor to edit proposed terminal command |
| **Confirm No** | `n` | Decline terminal command execution |
| **Confirm Yes** | `y` | Approve terminal command execution |
| **Open Editor** | `ctrl+g` | Edit prompt inside your default shell editor |
| **Paste Text** | `ctrl+v` | Paste text from your clipboard |
| **Redo Text Edit** | `ctrl+shift+z` | Redo last undone text change |
| **Undo Text Edit** | `ctrl+_`, `ctrl+shift+-` | Undo last text change |
| **Yank (Copy)** | `ctrl+y` | Yank/copy selected text |
| **Navigate Down** | `down` | Scroll down in menu lists |
| **Go to Bottom** | `ctrl+end` | Jump TUI view directly to the bottom |
| **Go to Top** | `ctrl+home` | Jump TUI view directly to the top |
| **Navigate Left** | `left` | Move prompt cursor left |
| **Page Down** | `pgdown`, `shift+down` | Scroll TUI page down |
| **Page Up** | `pgup`, `shift+up` | Scroll TUI page up |
| **Navigate Right** | `right` | Move prompt cursor right |
| **Tab / Focus** | `tab` | Auto-complete choices or switch component focus |
| **Navigate Up** | `up` | Scroll up in menu lists |
| **Insert Newline** | `alt+enter`, `ctrl+j`, `shift+enter` | Add newline to prompt without submitting |

You can map a single action to many keybindings in the JSON file. To disable keybindings, set the list to empty (e.g., `[]`). If the file is malformed, the CLI will use the valid parts and fall back to defaults for the broken actions.

warning

**Important**: Keybindings `cli.exit` and `cli.enter` cannot be disabled.

[Tutorial](https://antigravity.google/docs/cli/tutorial)

[Features](https://antigravity.google/docs/cli/features)

On this Page

- Using AGY CLI