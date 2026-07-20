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
>- Conversations

# Managing conversations [link](https://antigravity.google/\#managing-conversations)

Resume prior development threads, scope active histories to local workspaces, and fork conversations to experiment with alternate architectures.

## Workspace scoping [link](https://antigravity.google/\#workspace-scoping)

To maintain context hygiene, Antigravity CLI scopes conversation histories directly to your current working directory. When you launch `agy` from a specific directory, the agent only displays and resume sessions associated with that specific local repository or subdirectory.

This prevents context pollution, ensuring that the agent's semantic memory and token limits remain focused solely on the relevant codebase.

## Resuming sessions [link](https://antigravity.google/\#resuming-sessions)

You can return to a prior conversation at any time to continue an implementation, refine a solution, or recover from an interrupted session.

Antigravity CLI supports both an interactive **Session Picker** TUI overlay and direct command-line flags (`agy -c` / `agy --continue`) to resume threads instantly based on your active workspace.

For a complete walkthrough of the interactive picker, keyboard shortcuts, and details on how the directory-scoped session cache works, see the dedicated **[Resume Command Guide](https://antigravity.google/docs/cli/commands/resume)**.

## Branching with \`/fork\` [link](https://antigravity.google/\#branching-with-fork)

When engineering a complex feature, you may want to explore multiple design alternatives without losing your progress. The `/fork` command enables safe, parallel experimentation.

text

content\_copy

```
            /fork

```

_(Alias: `/branch`)_

The `/fork` command clones your entire conversation history up to the current turn into a new, independent session.

### Forking workflow [link](https://antigravity.google/\#forking-workflow)

1. Type `/fork` inside the prompt panel and press `Enter`.
2. The CLI allocates a new unique session ID and duplicates your existing workspace state and agent thread.
3. Your active terminal switches immediately to the new branch.
4. If the experiment fails, run `/resume` to restore your original, stable conversation branch.

lightbulb

**Branching Filesystems**: Forking clones the _conversation thread_, not your local git checkout. To fully isolate files during parallel forks, use git branches or stash local changes before testing contrasting approaches.

## Next steps [link](https://antigravity.google/\#next-steps)

Explore how the agent handles complex, asynchronous operations and parallel tasks:

- **[Background Tasks & Subagents](https://antigravity.google/docs/cli/subagents)**: Monitor subagents and handle fast-path approvals.
- **[Settings, Rendering & Keybindings](https://antigravity.google/docs/cli/settings)**: Configure rendering buffers and override JSON preferences.
- **[Permissions & Sandbox](https://antigravity.google/docs/cli/sandbox)**: Manage security profiles and system command lists.

[Reviewing Artifacts](https://antigravity.google/docs/cli/artifacts)

[Choose an execution mode](https://antigravity.google/docs/cli/modes)

On this Page

- Managing conversations

- Workspace scoping

- Resuming sessions

- Branching with \`/fork\`

- Next steps