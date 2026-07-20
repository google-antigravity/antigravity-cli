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
>- Commands
>- Resume (/resume)

# Resume Command (/resume) [link](https://antigravity.google/\#resume-command-resume)

Browse, search, and resume past conversation threads, or recover your last session instantly from the command line.

## Overview [link](https://antigravity.google/\#overview)

Antigravity CLI allows you to maintain multiple ongoing development threads. The `/resume` command opens an interactive **Session Picker** TUI panel to browse and load your history. You can also resume sessions directly from your host terminal using command-line flags.

\-\-\-

## Interactive Session Picker [link](https://antigravity.google/\#interactive-session-picker)

To open the Session Picker inside the TUI:

1. Type `/resume` (or aliases `/switch`, `/conversation`) in the prompt box.
2. Press `Enter`.

text

content\_copy

```
            /resume

```

### 1\. Navigating and Searching Conversations [link](https://antigravity.google/\#1-navigating-and-searching-conversations)

The Session Picker displays a list of past conversations sorted by recency (newest first).

- **Search**: Start typing to instantly filter conversations by their title, preview text, or unique ID.
- **Navigate**: Use `↑`/`↓` to scroll through the filtered list.
- **Page**: Use `←`/`→` to page backward and forward through older history blocks.
- **Select**: Highlight your target session and press `Enter` to load it.
- **Exit**: Press `Esc` to close the picker and return to the active prompt.

![Navigating Conversations](https://antigravity.google/assets/image/docs/cli/resume-navigate.png)

### 2\. Renaming a Conversation [link](https://antigravity.google/\#2-renaming-a-conversation)

To keep your history organized, you can rename conversations directly within the picker:

1. Use `↑`/`↓` to highlight the conversation you want to rename.
2. Press `F2`. An input field opens at the bottom of the panel, prefilled with the current title.
3. Type the new name and press `Enter` to save, or `Esc` to cancel.

![Renaming a Conversation](https://antigravity.google/assets/image/docs/cli/resume-rename.png)

### 3\. Deleting a Conversation [link](https://antigravity.google/\#3-deleting-a-conversation)

To clean up obsolete threads:

1. Highlight the target conversation in the list.
2. Press `Ctrl+Delete`. A confirmation prompt appears.
3. Press `Enter` (or `y`) to confirm deletion, or `Esc` (or `n`) to cancel.

![Deleting a Conversation](https://antigravity.google/assets/image/docs/cli/resume-delete.png)

### 4\. Importing from Antigravity 2.0 [link](https://antigravity.google/\#4-importing-from-antigravity-20)

You can import and resume active threads initiated in the Antigravity 2.0 desktop application:

1. With the Session Picker open, press `Tab` to switch from the **CLI** tab to the **Antigravity** tab.
2. Highlight the desktop conversation you wish to import.
3. Press `Enter`. A confirmation prompt `[Import this? (y/n)]` appears.
4. Press `Enter` (or `y`) to confirm. The CLI clones the history, context, and tool trajectories into your terminal session.

![Importing from Antigravity 2.0](https://antigravity.google/assets/image/docs/cli/resume-antigravity.png)

\-\-\-

## Command-Line Shortcuts [link](https://antigravity.google/\#command-line-shortcuts)

You can bypass the TUI picker and resume sessions directly when launching `agy` from your host shell.

### Quick Resume Last Session (\`-c\` / \`--continue\`) [link](https://antigravity.google/\#quick-resume-last-session-c-continue)

To instantly resume the single most recent conversation associated with your active workspace:

bash

content\_copy

```
            agy -c

```

_(Alternative: `agy --continue`)_

### Resume Specific Session (\`--conversation\`) [link](https://antigravity.google/\#resume-specific-session-conversation)

To load a specific conversation directly by its unique ID:

bash

content\_copy

```
            agy --conversation <conversation-id>

```

\-\-\-

## Under the Hood: The Session Cache [link](https://antigravity.google/\#under-the-hood-the-session-cache)

When you use the `-c` / `--continue` flag, the CLI resolves the target session using a local workspace-keyed cache.

### The Cache File [link](https://antigravity.google/\#the-cache-file)

- **Location**: `~/.gemini/antigravity-cli/cache/last_conversations.json`
- **Format**: A JSON map associating absolute workspace directory paths with their most recently active conversation ID:

content\_copy

```
                {
        "/usr/local/google/home/username/Develop/my-project": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
        "/usr/local/google/home/username/Develop/another-repo": "f9e8d7c6-b5a4-3210-fedc-ba9876543210"
    }

```

### Resolution Workflow [link](https://antigravity.google/\#resolution-workflow)

1. **Launch**: You run `agy -c` from `/path/to/workspace`.
2. **Lookup**: The CLI reads `last_conversations.json` and looks up the key `/path/to/workspace`.
3. **Verification**: If an ID is found, the CLI queries the backend to verify the conversation still exists.
4. **Load**:

- If verified, it loads the session.
- If the conversation was deleted or the key is missing, it starts a fresh session for that workspace.

\-\-\-

## See also [link](https://antigravity.google/\#see-also)

- **[Managing Conversations](https://antigravity.google/docs/cli/conversations)**: Learn about workspace scoping and branching with `/fork`.
- **[CLI Reference](https://antigravity.google/docs/cli/reference)**: See all available slash commands and default keybindings.
- **[Settings & Keybindings](https://antigravity.google/docs/cli/settings)**: Configure rendering modes and customize keyboard shortcuts.

[Permissions Command (/permissions)](https://antigravity.google/docs/cli/commands/permissions)

[Status Line Command (/statusline)](https://antigravity.google/docs/cli/commands/statusline)

On this Page

- Resume Command (/resume)

- Overview

- Interactive Session Picker

- Command-Line Shortcuts

- Under the Hood: The Session Cache

- See also