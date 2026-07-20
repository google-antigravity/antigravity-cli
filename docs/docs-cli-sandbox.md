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

Agent Capabilities expand\_more

[Choose an execution mode](https://antigravity.google/docs/cli/modes)

[Subagents](https://antigravity.google/docs/cli/subagents)

[Sandbox](https://antigravity.google/docs/cli/sandbox)

[Permissions](https://antigravity.google/docs/cli/permissions)

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
>- Agent Capabilities
>- Sandbox

# Sandbox [link](https://antigravity.google/\#sandbox)

Enforce native operating system process isolation, manage execution containment boundaries, and protect your local workstation.

## The security model [link](https://antigravity.google/\#the-security-model)

Because autonomous development agents run local terminal commands, edit source codes, and execute tests directly in your workspace, maintaining a secure workstation environment is critical. Antigravity CLI integrates a native **Terminal Sandbox** to restrict destructive shell operations or unauthorized remote network calls.

### Native OS containment [link](https://antigravity.google/\#native-os-containment)

Unlike heavy virtual containers or isolated virtual machines that slow down execution speeds, Antigravity uses lightweight, native operating system kernel utilities to create secure process rings with zero execution overhead:

| Operating System | Sandboxing Utility | Security Characteristics |
| --- | --- | --- |
| **Linux** | `nsjail` | Open-source process isolator utilizing kernel namespaces and cgroups to confine CPU, memory, and path visibility. |
| **macOS** | `sandbox-exec` | Native system tool enforcing policy profiles that restrict absolute filesystem access and raw TCP queries. |
| **Windows** | `AppContainer` | Desktop security containment ring isolating filesystem permissions and registry visibility. |

## Activating the sandbox [link](https://antigravity.google/\#activating-the-sandbox)

You configure the sandbox directly inside your global preferences:

text

content\_copy

```
            ~/.gemini/antigravity-cli/settings.json

```

### Sandbox configurations [link](https://antigravity.google/\#sandbox-configurations)

Add the sandboxing toggle to your settings profile:

json

content\_copy

```
            {
  "enableTerminalSandbox": true
}

```

- **`enableTerminalSandbox`** (boolean, default: `false`): Restricts all local execution commands launched by agents to OS containment rings.

## Interactive approvals with sandbox [link](https://antigravity.google/\#interactive-approvals-with-sandbox)

When the agent attempts to run a terminal tool or shell command, the TUI prompt block adapts dynamically based on your sandboxing state:

- **When Sandbox is Enabled**: The prompt panel offers a temporary escape option:

content\_copy

```
                Do you want to proceed?
    1. Yes
    2. Yes, and run without sandbox restrictions
    3. No

```

Choosing Option 2 bypasses the containment barrier exclusively for that single execution run.

- **When Sandbox is Disabled**: The prompt lets you force containment for a risky command:

content\_copy

```
                Do you want to proceed?
    1. Yes
    2. Yes, and run in sandbox
    3. No

```

## See also [link](https://antigravity.google/\#see-also)

- **[Permissions Engine](https://antigravity.google/docs/cli/permissions)**: Configure fine-grained allow/deny policy rules.
- **[Plugins & Skills](https://antigravity.google/docs/cli/plugins)**: Create your own custom skills slash commands.
- **[Settings, Rendering & Keybindings](https://antigravity.google/docs/cli/settings)**: Customize keyboard hotkeys and buffers.

[Background Tasks & Subagents](https://antigravity.google/docs/cli/subagents)

[Settings, Rendering & Keybindings](https://antigravity.google/docs/cli/settings)

On this Page

- Sandbox

- The security model

- Activating the sandbox

- Interactive approvals with sandbox

- See also