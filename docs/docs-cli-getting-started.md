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
>- Getting Started

# Getting Started with Antigravity CLI [link](https://antigravity.google/\#getting-started-with-antigravity-cli)

Welcome to Antigravity CLI! This guide provides a direct, high-level developer roadmap to install the client, launch the Terminal User Interface (TUI), and begin collaborating with autonomous agents.

## Roadmap checklist [link](https://antigravity.google/\#roadmap-checklist)

Complete the following sequential steps to launch your first session:

1. **Install the client (fast path)**

Run the appropriate fast-path command for your operating system:

**macOS / Linux**:

content\_copy

```
                curl -fsSL https://antigravity.google/cli/install.sh | bash

```

**Windows (PowerShell)**:

content\_copy

```
                irm https://antigravity.google/cli/install.ps1 | iex

```

**Windows (CMD)**:

content\_copy

```
                curl -fsSL https://antigravity.google/cli/install.cmd -o install.cmd && install.cmd && del install.cmd

```

By default, the installer registers the `agy` binary to your platform-specific directory:

- **macOS / Linux**: `~/.local/bin/agy`
- **Windows**: `C:\Users\<Username>\AppData\Local\agy\bin` (where `<Username>` represents your active Windows profile name).

info

**Advanced Setup**: For detailed enterprise credentials configuration, secure keyring auth permissions, proxy setups, or troubleshooting installation issues, consult the **[Installation & Auth Guide](https://antigravity.google/docs/cli/install)**.

1. **Launch the TUI inside a project**

Open a fresh terminal window, navigate to your target project codebase directory, and execute the launcher command:

content\_copy

```
                agy

```

1. **Complete the first-launch setup**

On your very first launch, the TUI walks you through a brief interactive setup:

- **Color Scheme**: Select your preferred visual theme (Solarized, Dark, Solarized Light, or standard Terminal colors).
- **Rendering Mode**: Choose Alt-Screen mode (alternate buffer with full-screen scrolling) or Inline mode (sequential stream integrated with your terminal's history).
- **Workspace Trust**: Confirm that you trust the repository directory. Once confirmed, the agent indexes the files and stands ready.

1. **Run your first agent task**

Type the following instruction in the prompt box at the bottom of your TUI screen and press `Enter`:

content\_copy

```
                Write a simple python script to fetch web page text

```

The agent reads the workspace, reasons about the task, and proposes a plan. For a detailed step-by-step tutorial on reviewing code and running test commands inside the TUI, follow the **[Tutorial Guide](https://antigravity.google/docs/cli/tutorial)**.

## Related resources [link](https://antigravity.google/\#related-resources)

Optimize your local environment configurations and master advanced collaboration tools:

- **[Best Practices](https://antigravity.google/docs/cli/best-practices)**: Master verification loops, planning phases, rule files, and session checkpoints.
- **[Troubleshooting](https://antigravity.google/docs/cli/troubleshooting)**: Resolve common path, keyring, or SSH forwarding errors.
- **[CLI Reference](https://antigravity.google/docs/cli/reference)**: Dense reference sheets cataloging all slash commands, shortcuts, and JSON keys.

[Overview](https://antigravity.google/docs/cli/overview)

[Installation & Auth](https://antigravity.google/docs/cli/install)

On this Page

- Getting Started with Antigravity CLI

- Roadmap checklist

- Related resources