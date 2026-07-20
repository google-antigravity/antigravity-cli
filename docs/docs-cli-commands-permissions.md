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
>- Permissions (/permissions)

# Permissions Command (/permissions) [link](https://antigravity.google/\#permissions-command-permissions)

Manage your fine-grained agent permission rules interactively within the TUI.

## Overview [link](https://antigravity.google/\#overview)

Antigravity CLI uses a fine-grained permissions engine to secure your workstation. While you can configure these rules manually in your settings file, the `/permissions` command opens an interactive **Permissions Manager** TUI panel to view, add, edit, and delete rules live.

For details on how the permission engine works, supported actions, and manual configuration, see the conceptual **[Permissions Guide](https://antigravity.google/docs/cli/permissions)**.

## Managing permissions interactively [link](https://antigravity.google/\#managing-permissions-interactively)

To open the Permissions Manager:

1. Type `/permissions` in the prompt box.
2. Press `Enter`.

text

content\_copy

```
            /permissions

```

### Navigation and controls [link](https://antigravity.google/\#navigation-and-controls)

The Permissions Manager operates in three panels:

1. **Scope Picker**: Select the configuration scope you want to edit:

- **Project**: Rules applying only to the active project (disabled if no project is open).
- **Shared**: Rules shared across all Antigravity products.
- **Global**: Global rules applying to all your sessions.

Use `↑`/`↓` (or `j`/`k`) to navigate, `Enter` to select, and `Esc` to exit.

1. **Rule Viewer**: View the rules configured for the selected scope.

- Switch between **allowlist**, **denylist**, and **asklist** tabs using `←`/`→` (or `Tab`).
- Scroll through the rules using `↑`/`↓` (or `j`/`k`).
- Press `a` to add a new rule.
- Press `e` (or `Ctrl+G`) to edit the highlighted rule.
- Press `d` (or `Backspace`) to delete the highlighted rule.
- Press `Esc` to return to the Scope Picker.

1. **Add/Edit Rule**: Type or edit a rule in the input field.

- Rules must follow the `action(target)` format (e.g., `command(git)`).
- Press `Enter` to validate and save the rule.
- Press `Esc` to cancel.

\-\-\-

## Step-by-step walkthrough [link](https://antigravity.google/\#step-by-step-walkthrough)

Here is how to view, add, edit, and delete rules live in the TUI.

### 1\. Selecting a scope and viewing rules [link](https://antigravity.google/\#1-selecting-a-scope-and-viewing-rules)

When you run `/permissions`, you first see the **Scope Picker**. Select **Global** to manage your global rules:

![Selecting Global Scope](https://antigravity.google/assets/image/docs/cli/permissions-scope.png)

Press `Enter` to open the **Rule Viewer** for the selected scope. You can use `←`/`→` to switch between the **allow**, **deny**, and **ask** tabs:

![Global Rule Viewer](https://antigravity.google/assets/image/docs/cli/permissions-viewer.png)

### 2\. Adding a permission rule [link](https://antigravity.google/\#2-adding-a-permission-rule)

To allow the agent to run `git` commands automatically without prompting:

1. In the Rule Viewer, press `a`. The **Add Rule** panel opens at the bottom:

![Add Rule Panel](https://antigravity.google/assets/image/docs/cli/permissions-add.png)

1. Type `command(git)` in the input field:

![Typing the Rule](https://antigravity.google/assets/image/docs/cli/permissions-add-typed.png)

1. Press `Enter`. The rule is validated and saved. You are returned to the Rule Viewer, and `command(git)` now appears in your allowlist:

![Rule Saved Successfully](https://antigravity.google/assets/image/docs/cli/permissions-viewer-with-rule.png)

### 3\. Editing a permission rule [link](https://antigravity.google/\#3-editing-a-permission-rule)

If you want to restrict the agent so it can only run `git diff` automatically, you can edit the rule:

1. In the Rule Viewer, use `↑`/`↓` to highlight `command(git)`.
2. Press `e` (or `Ctrl+G`). The input panel opens, prefilled with `command(git)`.
3. Modify the text to `command(git diff)`.
4. Press `Enter` to save. The old rule is replaced by the new one.

### 4\. Deleting a permission rule [link](https://antigravity.google/\#4-deleting-a-permission-rule)

To remove a rule and revert to prompting for those actions:

1. In the Rule Viewer, highlight the rule you want to delete (e.g., `command(git diff)`).
2. Press `d` (or `Backspace`).
3. The rule is immediately removed from the list.

## Next steps [link](https://antigravity.google/\#next-steps)

- **[Permissions Guide](https://antigravity.google/docs/cli/permissions)**: Learn about the security model, action types, and wildcard matching.
- **[Sandbox & Security](https://antigravity.google/docs/cli/sandbox)**: Configure the native OS container for running commands.
- **[CLI Reference](https://antigravity.google/docs/cli/reference)**: See all available slash commands and keybindings.

[Diff Command (/diff)](https://antigravity.google/docs/cli/commands/diff)

[Resume Command (/resume)](https://antigravity.google/docs/cli/commands/resume)

On this Page

- Permissions Command (/permissions)

- Overview

- Managing permissions interactively

- Step-by-step walkthrough

- Next steps