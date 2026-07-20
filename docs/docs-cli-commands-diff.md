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

Settings chevron\_right

[AI Credits](https://antigravity.google/docs/cli/credits)

Customizations chevron\_right

Commands expand\_more

[Agents (/agents)](https://antigravity.google/docs/cli/commands/agents)

[Code Search (/codesearch)](https://antigravity.google/docs/cli/commands/codesearch)

[AI Credits (/credits)](https://antigravity.google/docs/cli/commands/credits)

[Diff (/diff)](https://antigravity.google/docs/cli/commands/diff)

[Permissions (/permissions)](https://antigravity.google/docs/cli/commands/permissions)

[Resume (/resume)](https://antigravity.google/docs/cli/commands/resume)

[Status Line (/statusline)](https://antigravity.google/docs/cli/commands/statusline)

[Window Title (/title)](https://antigravity.google/docs/cli/commands/title)

[Model Quotas (/usage, /quota)](https://antigravity.google/docs/cli/commands/usage)

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
>- Commands
>- Diff (/diff)

# Diff Command (/diff) [link](https://antigravity.google/\#diff-command-diff)

View and review workspace changes, commit history, and agent turn diffs interactively within the TUI.

## Overview [link](https://antigravity.google/\#overview)

The `/diff` command opens the **Interactive Diff Viewer**, a full-screen panel that allows you to inspect changes in your workspace and conversation history. It supports three distinct modes (VCS, Turn, and Commit) and provides an interactive review workflow where you can add line-by-line comments to steer the agent's next steps.

## Interactive Diff Viewer Panels [link](https://antigravity.google/\#interactive-diff-viewer-panels)

To open the Diff Viewer:

1. Type `/diff` in the prompt box.
2. Press `Enter`.

text

content\_copy

```
            /diff

```

### Navigation and Controls [link](https://antigravity.google/\#navigation-and-controls)

The Diff Viewer operates in three modes, which you can cycle through using **`Tab`** (or **`Right`** / **`Left`** arrow keys):

- **VCS Mode**: Shows a list of all modified and untracked files in your active workspace.
- Supports Git, Mercurial (Hg), and Jujutsu (JJ) automatically.
- Use `↑`/`↓` to navigate the file list, and `Enter` to open the detail view.
- **Turn Mode**: Shows the changes introduced by the agent in each turn of the current conversation.
- Useful for reviewing the agent's work step-by-step.
- Use `↑`/`↓` to navigate, and `Enter` to view details.
- **Commit Mode**: Renders an interactive commit graph/tree of your repository.
- Use `↑`/`↓` to navigate the commit chain.
- Use `←`/`→` to navigate to adjacent branches in the graph.
- Press `Enter` to load the diff for the selected commit.

\-\-\-

## Step-by-Step Walkthrough [link](https://antigravity.google/\#step-by-step-walkthrough)

Here is how to use the Diff Viewer to review changes, add comments, and steer the agent.

### 1\. Reviewing Workspace Changes (VCS Mode) [link](https://antigravity.google/\#1-reviewing-workspace-changes-vcs-mode)

When you run `/diff`, it opens in **VCS Mode** by default (if you have uncommitted changes). You will see a list of modified and untracked files:

![VCS Diff List](https://antigravity.google/assets/image/docs/cli/diff-vcs-list.png)

Press **`Enter`** on a file to open its **Detail View**. This shows the unified diff.

- Use `↑`/`↓` (arrow keys) to scroll the diff.
- Use `j`/`k` (or `←`/`→`) to quickly swap between files without returning to the list.
- Use `n`/`N` to jump to the next/previous diff hunk.

![Detail View](https://antigravity.google/assets/image/docs/cli/diff-detail.png)

### 2\. Adding Comments and Steering the Agent [link](https://antigravity.google/\#2-adding-comments-and-steering-the-agent)

While in the Detail View, you can review the code and write feedback directly onto specific lines.

**Step 1: Locate the line** Scroll to the line you want to comment on.

**Step 2: Open the comment input** Press **`c`**. The **Comment Input** overlay opens at the bottom:

![Comment Input](https://antigravity.google/assets/image/docs/cli/diff-comment.png)

**Step 3: Write your feedback** Type your feedback and press `Enter` to save (or `Esc` to cancel).

**Step 4: Manage your comments** Saved comments are marked in the diff. You can delete a comment by highlighting the line and pressing **`d`**.

**Step 5: Exit and submit** Press **`Esc`** to return to the file list. Press **`Esc`** again to exit `/diff`. If you have unsaved comments, a confirmation screen appears:

- Press **`Shift+Y`** to approve and exit. Your comments are formatted and sent to the agent as your next prompt, allowing you to steer its next turn.
- Press **`Shift+N`** to reject and exit, discarding the comments.

### 3\. Reviewing Turn History (Turn Mode) [link](https://antigravity.google/\#3-reviewing-turn-history-turn-mode)

Press **`Tab`** to switch to **Turn Mode**. This groups changes by the conversation turn in which they were introduced, allowing you to see exactly what the agent did in previous steps:

![Turn Diff List](https://antigravity.google/assets/image/docs/cli/diff-turn-list.png)

### 4\. Navigating the Commit Tree (Commit Mode) [link](https://antigravity.google/\#4-navigating-the-commit-tree-commit-mode)

Press **`Tab`** again to switch to **Commit Mode**. This renders the repository's commit history as an interactive graph. You can navigate up and down the chain, or hop between branches using `←`/`→`:

![Commit List](https://antigravity.google/assets/image/docs/cli/diff-commit-list.png)

Highlight any commit and press **`Enter`** to load and review its diff:

![Commit Detail](https://antigravity.google/assets/image/docs/cli/diff-commit-detail.png)

\-\-\-

## Keyboard Shortcuts Reference [link](https://antigravity.google/\#keyboard-shortcuts-reference)

### File List View (VCS & Turn Modes) [link](https://antigravity.google/\#file-list-view-vcs-turn-modes)

| Key | Action |
| --- | --- |
| **`Tab`** / **`→`** / **`←`** | Cycle modes (VCS → Turn → Commit) |
| **`↑`** / **`↓`** (or **`j`** / **`k`**) | Navigate file list |
| **`Enter`** | Open selected file's Detail View |
| **`Esc`** | Exit Diff Viewer |

### File Detail View [link](https://antigravity.google/\#file-detail-view)

| Key | Action |
| --- | --- |
| **`↑`** / **`↓`** | Scroll diff content |
| **`PgUp`** / **`PgDn`** | Scroll diff by page |
| **`j`** / **`k`** (or **`→`** / **`←`**) | Switch to next / previous file |
| **`n`** / **`N`** (or **`shift+n`**) | Jump to next / previous diff hunk |
| **`c`** | Add/edit comment on the current line |
| **`d`** | Delete comment on the current line |
| **`Esc`** | Return to File List View |

### Commit Tree View (Commit Mode) [link](https://antigravity.google/\#commit-tree-view-commit-mode)

| Key | Action |
| --- | --- |
| **`↑`** / **`↓`** | Navigate commit history |
| **`←`** / **`→`** | Navigate to adjacent branches in the graph |
| **`Enter`** | Load diff for the selected commit |
| **`Esc`** | Exit Diff Viewer |

### Exit Confirmation Screen [link](https://antigravity.google/\#exit-confirmation-screen)

| Key | Action |
| --- | --- |
| **`Shift+Y`** | Exit and send comments to the agent |
| **`Shift+N`** | Exit and discard comments |
| **`Esc`** | Return to File List View |

## See also [link](https://antigravity.google/\#see-also)

- **[Settings & Keybindings](https://antigravity.google/docs/cli/settings)**: Customize your TUI theme, alt-screen preferences, and keybindings.
- **[Conversations](https://antigravity.google/docs/cli/conversations)**: Learn how to manage, fork, and rewind conversation threads.
- **[CLI Reference](https://antigravity.google/docs/cli/reference)**: Quick reference for all slash commands and default shortcuts.

[AI Credits Command (/credits)](https://antigravity.google/docs/cli/commands/credits)

[Permissions Command (/permissions)](https://antigravity.google/docs/cli/commands/permissions)

On this Page

- Diff Command (/diff)

- Overview

- Interactive Diff Viewer Panels

- Step-by-Step Walkthrough

- Keyboard Shortcuts Reference

- See also