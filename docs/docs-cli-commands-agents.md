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
>- Agents (/agents)

# Agents Command (/agents) [link](https://antigravity.google/\#agents-command-agents)

Browse, select, and switch between custom agents, or monitor active and completed background subagents directly inside an interactive TUI panel.

## Before you begin [link](https://antigravity.google/\#before-you-begin)

- [Install Antigravity CLI](https://antigravity.google/docs/cli/install)
- Understand the [Asynchronous execution model](https://antigravity.google/docs/cli/subagents)

## Overview [link](https://antigravity.google/\#overview)

The `/agents` command opens the interactive **Agent Manager Panel**. This interface serves two distinct purposes:

1. **Custom Agent Selection & Discovery**: Choose between the default agent and custom workflow-specific agents, or discover where to define new agents locally and globally.
2. **Subagent Monitoring & Control**: Track, inspect, or terminate background subagents running concurrently during your active session.

To open the panel inside the TUI, type `/agents` and press `Enter`:

bash

content\_copy

```
            /agents

```

![Interactive Agents Panel](https://antigravity.google/assets/image/docs/cli/agents-panel.png)

\-\-\-

## Custom Agent Selection & Discovery [link](https://antigravity.google/\#custom-agent-selection-discovery)

Antigravity CLI supports loading custom agent definitions with specialized system instructions and tool permissions. The **Available Agents** section lists all agents currently available to your session.

### 1\. Switching between agents [link](https://antigravity.google/\#1-switching-between-agents)

- **Select**: Use `↑`/`↓` to highlight an agent (`Default agent` or a custom agent) under **Available Agents**, then press `Enter`.
- **Status Indicator**: A green circle (`●`) indicates the active or prepared agent.
- **Apply & Exit**: Press `Esc` to close the panel and apply your selection.

\> **Note:** If you are currently inside an active conversation, switching custom agents automatically forks your current session (`[ Switch will fork the current conversation on exit ]`) so you do not lose context. If you start from a fresh session, the switch applies directly (`[ Switch will create a new conversation on exit ]`).

### 2\. Creating custom agents [link](https://antigravity.google/\#2-creating-custom-agents)

The header of the `/agents` panel displays exact template locations for creating new custom agents:

text

content\_copy

```
            Create New Agents
  Workspace: {workspace}/.agents/agents/{agent_name}/agent.md
  Global: ~/.gemini/config/agents/{agent_name}/agent.md

```

To create a custom agent that is available across all your workspaces and projects, place it under your global customization directory (`~/.gemini/config/agents/`). Create a directory matching your agent name and add an `agent.md` file with YAML frontmatter:

bash

content\_copy

```
            mkdir -p ~/.gemini/config/agents/code-reviewer
cat << 'EOF' > ~/.gemini/config/agents/code-reviewer/agent.md
---
name: code-reviewer
description: Rigorous code review specialist focusing on edge cases and security.
---
You are an expert code reviewer. Analyze diffs carefully and verify edge cases.
EOF

```

When you reopen `/agents`, the CLI automatically discovers `code-reviewer` and lists it under **Available Agents**. If you need an agent scoped strictly to a single project repository, place it inside that workspace's `.agents/agents/` directory (for example, `/home/user/projects/my-app/.agents/agents/code-reviewer/agent.md`). You can also package and distribute custom agents inside [Plugins](https://antigravity.google/docs/cli/plugins).

\-\-\-

## Subagent Monitoring & Control [link](https://antigravity.google/\#subagent-monitoring-control)

When your primary agent delegates tasks (such as running tests or querying large codebases), the spawned threads appear in the `/agents` panel under **Subagents**, grouped by their triggering prompt.

### 1\. Inspecting subagent progress [link](https://antigravity.google/\#1-inspecting-subagent-progress)

- **Group Toggling**: Press `Enter` on a subagent group header (`▸ Subagents (1 running, 2 done)`) to expand or collapse (`▾`) that group.
- **Status Indicators**: Each subagent row displays a live lifecycle state:
- `running`: Actively executing tools or generating reasoning steps.
- `done`: Successfully completed its assigned background task.
- `error`: Encountered a terminal failure during execution.
- `killed`: Terminated manually by the user or parent process.
- **Detail View**: Highlight a specific subagent row and press `Enter` to open the full-screen **Subagent Detail View**. This view displays the subagent's complete internal thoughts, tool calls, and execution stdout. Press `Esc` to return to the list.

### 2\. Terminating active subagents [link](https://antigravity.google/\#2-terminating-active-subagents)

If a background subagent loops or runs longer than needed, you can kill it immediately without leaving your session:

1. Open `/agents` and highlight the running subagent row.
2. Press `k` to kill the active subagent and all its child threads.

### 3\. Inline tool approvals [link](https://antigravity.google/\#3-inline-tool-approvals)

If a subagent attempts a protected operation (such as modifying a file or running a shell command in a sandboxed environment), the authorization prompt displays inline in the `/agents` panel. You can press `a` to approve or `d` to deny directly from the list.

\-\-\-

## Panel Keybindings Reference [link](https://antigravity.google/\#panel-keybindings-reference)

When focused inside the `/agents` panel, the following keyboard shortcuts apply:

| Key | Action | Behavior |
| --- | --- | --- |
| **`↑` / `↓`** | Navigate | Move the cursor between headers, subagents, and available agents. |
| **`Enter`** | Select / Toggle | Expand/collapse groups, open Subagent Detail View, or select a custom agent. |
| **`k`** | Kill Active Subagent | Instantly cancel (`CancelSubagent`) the highlighted running subagent. |
| **`Esc`** | Go Back | Exit the panel, return to the prompt box, and apply any prepared agent switch. |

\-\-\-

## Common mistakes [link](https://antigravity.google/\#common-mistakes)

| Mistake | Why it fails | Fix |
| --- | --- | --- |
| Expecting custom agent switches to modify the existing turn history | Switching agents inside an active thread forks the conversation to preserve historical integrity | Continue your workflow in the newly forked session with the new agent's capabilities |
| Putting custom agent markdown files directly inside `~/.gemini/config/agents/` or `.agents/` | The CLI scanner expects agents to live inside dedicated subdirectories under `~/.gemini/config/agents/<name>/` or `.agents/agents/<name>/` | Move your agent definition to `~/.gemini/config/agents/<name>/agent.md` |
| Using `k` on completed subagents | `KeyKillSubagent` only targets active (`running`) subagent processes | Use `Enter` to inspect completed or failed subagent logs instead |

\-\-\-

## Next steps [link](https://antigravity.google/\#next-steps)

- [Background tasks & subagents](https://antigravity.google/docs/cli/subagents): Learn more about the multi-threaded asynchronous execution architecture.
- [Plugins & Skills](https://antigravity.google/docs/cli/plugins): Discover how to bundle custom agents, skills, and MCP configs into shareable plugins.
- [Permissions & Sandbox](https://antigravity.google/docs/cli/sandbox): Configure security guardrails and approval rules for background subagents.

[Terminal Title Customization](https://antigravity.google/docs/cli/title)

[Code Search Command (/codesearch)](https://antigravity.google/docs/cli/commands/codesearch)

On this Page

- Agents Command (/agents)

- Before you begin

- Overview

- Custom Agent Selection & Discovery

- Subagent Monitoring & Control

- Panel Keybindings Reference

- Common mistakes

- Next steps