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

[See overview](product.md)

Products

[antigravity Antigravity 2.0](product-antigravity-2.md) [terminal Antigravity CLI](product-antigravity-cli.md) [code Antigravity IDE](product-antigravity-ide.md) [sdk Antigravity SDK](product.md/antigravity-sdk)

Use Cases keyboard\_arrow\_down

Built for developers in the agent-first era

[See overview](use-cases.md)

[Enterprise](use-cases.md/enterprise) [Frontend](use-cases-frontend.md) [Fullstack](use-cases.md/fullstack) [Science](use-cases-science.md) [Marketer](use-cases.md/marketer)

Pricing  Blog  Resources keyboard\_arrow\_down

Everything you need to stay up-to-date and get help

[Documentation keyboard\_arrow\_right](docs.md) [Changelog](changelog.md) [Support](support.md) [Press](press.md) [Releases](releases.md)

[Home](docs-home.md)

Antigravity 2.0 chevron\_right

Antigravity CLI chevron\_right

Antigravity SDK chevron\_right

Antigravity IDE chevron\_right

Migration chevron\_right

[Enterprise](docs.md/enterprise)

[Plans](docs.md/plans)

[FAQ](docs.md/faq)

- side\_navigation
- Antigravity CLI
>- Best Practices

# Best practices for Antigravity CLI [link](\.md#best-practices-for-antigravity-cli)

Master the workflows, prompt architectures, and local configuration choices to maximize agent velocity while maintaining robust control.

## Establish verification loops [link](\.md#establish-verification-loops)

The single most effective way to ensure reliable, correct modifications from an autonomous agent is to provide the agent with a local verification mechanism (such as unit tests, build commands, or formatting scripts).

Before asking the agent to implement a code change:

1. Ensure your workspace directory has a test suite ready.
2. If tests do not exist, direct the agent to write a standard test block _first_.
3. Once the agent proposes code, instruct it to run the local test command to verify its work.
4. Watch the agent execute the command and iterate on the test outputs automatically.

text

content\_copy

```
            > Implement feature X in main.py. Run npm test afterward to verify the build.

```

## Explore, plan, then execute [link](\.md#explore-plan-then-execute)

Autonomous local agents operate with highest accuracy when complex changes are partitioned into distinct exploration, planning, and execution phases.

- **Exploration**: Ask the agent to explain how the target codebase resolves a particular problem or where an interface is defined before writing any changes.
- **Planning**: Request an implementation plan. The agent will list targeted files, required dependencies, and logic overrides in an implementation plan artifact.
- **Execution**: Once you approve the structured plan, direct the agent to apply the edits.

text

content\_copy

```
            > Explore how our router resolves `/docs/:page`. Write down an implementation plan to add `/docs/best-practices`.

```

## Enrich your prompting context [link](\.md#enrich-your-prompting-context)

Give local agents high-fidelity indicators to narrow down reasoning boundaries and minimize token overhead.

### Target file autocompletion [link](\.md#target-file-autocompletion)

Type `@` within your prompt box to trigger the **Interactive Path Suggestion** overlay. Highlighting and selecting a path imports the absolute workspace file path directly into your prompt. This helps the agent target its code searches.

### Attaching visual evidence [link](\.md#attaching-visual-evidence)

If debugging visual UI issues, rendering bugs, or frontend layout inconsistencies, capture a screenshot or video recording, copy it, and press `ctrl+v` inside the prompt box to attach it. The agent will consult the media file to diagnose the issue.

## Configure your workspace environment [link](\.md#configure-your-workspace-environment)

Optimize your local workstation rules and security boundaries to match your engineering flow.

### Write a codebase rule file [link](\.md#write-a-codebase-rule-file)

Create a `GEMINI.md` or `AGENTS.md` file at your workspace root to outline specific directory standards, styling paradigms, test command parameters, and deprecation warnings. The agent automatically parses these rules on startup and consults them before suggesting changes.

### Establish structured permissions [link](\.md#establish-structured-permissions)

Tune your safety barriers in `~/.gemini/antigravity-cli/settings.json` based on your project risk level:

- **`request-review`** (Default): Prompts you before executing any write operations, bash commands, or remote network calls.
- **`proceed-in-sandbox`**: Restricts all terminal executions to a secure sandbox containment ring. Safe commands execute autonomously, while risky commands prompt for reviews.
- **`strict`**: Always prompts for all non-read operations, providing complete line-by-line transparency.

json

content\_copy

```
            {
  "toolPermission": "proceed-in-sandbox",
  "enableTerminalSandbox": true
}

```

## Manage TUI sessions proactively [link](\.md#manage-tui-sessions-proactively)

Use active session navigation tools to recover from engineering dead-ends or course-correct intermediate agent loops.

### Course-correct early (\`esc\`) [link](\.md#course-correct-early-esc)

If you watch an agent execute an incorrect search pattern or write code that deviates from your intentions, press the global escape hatch key `esc` immediately to interrupt the turn and regain focus of a clean prompt.

### Rewind history with \`/rewind\` [link](\.md#rewind-history-with-rewind)

If an agent has made several successive changes that introduce build errors, you do not need to discard the session. Type `/rewind` (or `/undo`) to roll back your conversation thread to a previous stable checkout.

### Branch experiments with \`/fork\` [link](\.md#branch-experiments-with-fork)

If you are unsure of the best implementation path:

1. Reach a stable baseline thread.
2. Type `/fork` to spin up a duplicate parallel session.
3. Test your speculative code modifications in the branched session.
4. If the approach fails, run `/resume` to swap back to your stable main branch.

## Automate and script [link](\.md#automate-and-script)

Antigravity CLI is designed to operate seamlessly within standard shell pipeline tools.

### Run non-interactive commands (\`-p\`) [link](\.md#run-non-interactive-commands-p)

To automate quick queries or integrate agents into git hooks, use the one-shot prompt flag `-p`:

bash

content\_copy

```
            agy -p "Review this git diff and draft a conventional commit message" --cwd $(pwd)

```

### Fan out using parallel subagents [link](\.md#fan-out-using-parallel-subagents)

For large-scale sweeps or multi-file refactoring, direct the primary agent to spawn concurrent background subagents. The agent manager handles background threads autonomously while you continue working on your primary screen.

## Related resources [link](\.md#related-resources)

Learn how to configure settings and customize visual layouts:

- **[Settings, Rendering & Keybindings](docs-cli-settings.md)**: Customize keyboard hotkeys and buffers.
- **[Permissions & Sandbox](docs-cli-sandbox.md)**: Enforce filesystem containment.
- **[Plugins & Skills](docs.md/cli/plugins)**: Create your own custom slash commands.

[Model Quotas (/usage)](docs.md/cli/commands/usage)

[Troubleshooting](docs.md/cli/troubleshooting)

On this Page

- Best practices for Antigravity CLI

- Establish verification loops

- Explore, plan, then execute

- Enrich your prompting context

- Configure your workspace environment

- Manage TUI sessions proactively

- Automate and script

- Related resources