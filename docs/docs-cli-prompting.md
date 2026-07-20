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
>- Prompting

# Prompting & interaction [link](https://antigravity.google/\#prompting-interaction)

Master primary interaction patterns, multiline composition workflows, session interruption controls, and terminal media pasting.

## The prompt box [link](https://antigravity.google/\#the-prompt-box)

Antigravity CLI features a sticky prompt panel positioned at the bottom of your terminal screen. This panel handles standard user entries, multiline scripts, and direct media pasting.

text

content\_copy

```
            ───────────────────────────────────────────────────────────────────────────
> Describe your next engineering task here...
───────────────────────────────────────────────────────────────────────────

```

### Submitting prompts [link](https://antigravity.google/\#submitting-prompts)

To initiate an agent turn, type your instruction into the prompt panel and press `Enter`. The agent immediately analyzes your current directory workspace, reads required configurations, and begins formulating an execution plan.

### Interrupting active sessions [link](https://antigravity.google/\#interrupting-active-sessions)

If the agent initiates an undesired task or loops during command execution, press `Esc` to immediately halt the session.

lightbulb

**Universal Escape**: The `Esc` key acts as a global escape hatch. Pressing `Esc` instantly cancels any active agent turn, closes overlay panels, and returns focus to a clean prompt box.

## Multiline composition [link](https://antigravity.google/\#multiline-composition)

For complex directives, structured test scenarios, or multi-paragraph instructions, use our built-in multiline features.

### Shorthand newline insertions [link](https://antigravity.google/\#shorthand-newline-insertions)

- **Standard**: Press `Shift+Enter` or `ctrl+j` to insert a clean newline within your active prompt window without submitting.
- **macOS Terminal Fallback**: If using Apple Terminal (which does not forward `Shift+Enter` by default), press `Option+Enter`. Ensure you check **Use Option as Meta key** in your Terminal Preferences profile.
- **Universal Slash Escape**: Type a trailing backslash `\` at the end of your active line and press `Enter`. The CLI automatically removes the backslash and inserts a newline.

### Editing prompts in \`$EDITOR\` [link](https://antigravity.google/\#editing-prompts-in-editor)

To draft or edit extensive prompt structures in your primary development editor:

1. Press `ctrl+g` inside the empty prompt panel.
2. The CLI launches your system's default text editor (such as `vim`, `nano`, or `code`, configured via `/config` or your environment's `$EDITOR` variable).
3. Draft your multi-line instruction inside the temporary editor buffer.
4. Save and exit the editor. The CLI automatically imports the edited buffer directly back into the terminal prompt.

## Attaching media [link](https://antigravity.google/\#attaching-media)

Antigravity CLI supports pasting rich media formats directly from your system clipboard. Press `ctrl+v` (or native terminal paste) inside the prompt panel to attach screenshot mockups or video recordings.

### Supported file types [link](https://antigravity.google/\#supported-file-types)

- **Images**: PNG, JPEG, GIF, WebP, BMP, TIFF, and SVG.
- **Videos**: MP4, MOV, WebM, and AVI.

## Next steps [link](https://antigravity.google/\#next-steps)

After mastering interaction patterns, explore how the agent presents actions and requests verification:

- **[Reviewing Artifacts](https://antigravity.google/docs/cli/artifacts)**: Learn to inspect and manage file edits, plans, and test executions.
- **[Managing Conversations](https://antigravity.google/docs/cli/conversations)**: Resume prior threads and fork active sessions.
- **[Background Tasks & Subagents](https://antigravity.google/docs/cli/subagents)**: Monitor asynchronous background agents.

[Migration](https://antigravity.google/docs/cli/gcli-migration)

[Reviewing Artifacts](https://antigravity.google/docs/cli/artifacts)

On this Page

- Prompting & interaction

- The prompt box

- Multiline composition

- Attaching media

- Next steps