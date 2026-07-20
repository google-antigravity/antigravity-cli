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
>- Gemini Migration

# Migrating from Gemini CLI [link](https://antigravity.google/\#migrating-from-gemini-cli)

Convert your legacy configurations, import Gemini CLI extensions as native plugins, adapt custom skills paths, and reformat Model Context Protocol configurations.

## Overview [link](https://antigravity.google/\#overview)

Antigravity CLI preserves backward compatibility with the core developer-experience constructs popularized by Gemini CLI. To ensure a seamless upgrade, the CLI offers automatic onboarding conversion alongside explicit CLI migration command sequences.

## First-launch onboarding [link](https://antigravity.google/\#first-launch-onboarding)

When you execute `agy` for the first time in an environment containing legacy configurations, the CLI automatically detects your existing profiles. An interactive checklist prompts you to choose which assets to migrate:

1. **Auto-conversion**: Select the extensions and global configurations you wish to convert.
2. **Keyring storage**: The CLI migrates your active session tokens securely into your operating system's native keyring storage.
3. **Settings alignment**: Default visual parameters and rendering buffers map automatically to your new settings profile.

info

**Partial Parity**: While we preserve support for workspace skills, rules, and MCP servers, certain customized terminal themes or experimental visual overlays from Gemini CLI may not be supported.

## Converting extensions to plugins [link](https://antigravity.google/\#converting-extensions-to-plugins)

Since Gemini CLI launched, the industry has standardized on the term **plugins**. You can manually convert your legacy Gemini extensions to native Antigravity plugins by executing:

bash

content\_copy

```
            agy plugin import gemini

```

This utility searches your legacy local directories, parses your extension manifests, and converts files into native layout blocks.

### Expected import output [link](https://antigravity.google/\#expected-import-output)

text

content\_copy

```
            [ok]   conductor-tools
       - skills     : skipped (none detected)
       - agents     : skipped (none detected)
       ✔ commands   : 4 legacy commands converted to skills
       - mcpServers : skipped (none detected)
[ok]   google-workspace
       ✔ skills     : 5 skills processed
       - agents     : skipped (none detected)
       ✔ commands   : 2 legacy commands converted to skills
       ✔ mcpServers : 1 server definition migrated to mcp_config.json

```

## Context files and workspace rules [link](https://antigravity.google/\#context-files-and-workspace-rules)

Both CLI platforms utilize identical workspace context rules. No modifications are needed to your existing rule documents:

- **Workspace local context**: The agent continues to parse and enforce rule constraints defined inside your active directory's `GEMINI.md` and `AGENTS.md` files.
- **Global developer context**: The agent automatically consults and enforces your global constraints located at `~/.gemini/GEMINI.md`.

## Updated skills paths [link](https://antigravity.google/\#updated-skills-paths)

While global shared skills remain in your user home directory, the target folder path for local workspace-specific skills has been updated.

| Configuration | Gemini CLI | Antigravity CLI |
| --- | --- | --- |
| **Global shared path** | `~/.gemini/skills/` | `~/.gemini/antigravity-cli/skills/` |
| **Workspace project path** | `.gemini/skills/` | `.agents/skills/` |

warning

**Action Required**: If your project contains custom workspace skills defined in `.gemini/skills/`, you must manually rename or relocate the folder to `.agents/skills/` for the Antigravity agent to recognize them as active slash commands.

## MCP config formatting changes [link](https://antigravity.google/\#mcp-config-formatting-changes)

Antigravity CLI separates Model Context Protocol servers into dedicated, lightweight JSON profiles instead of nesting them inside your primary preferences configuration.

### Directory mapping [link](https://antigravity.google/\#directory-mapping)

- **Legacy Gemini Config**: Servers were declared inline within `~/.gemini/settings.json`.
- **Antigravity CLI Config**: Servers are defined inside a standalone `mcp_config.json` profile:
- Global servers: `~/.gemini/config/mcp_config.json`
- Workspace servers: `.agents/mcp_config.json`

### Required schema updates [link](https://antigravity.google/\#required-schema-updates)

When manually migrating remote websocket or SSE server definitions, update the URI key parameter to match the current standard:

- **Legacy schema keys**: `url` or `httpUrl`
- **Modern schema key**: `serverUrl`

json

content\_copy

```
            {
  "mcpServers": {
    "remote-indexer": {
      "serverUrl": "https://mcp.internal.enterprise.com/sse",
      "env": {
        "AUTH_TOKEN": "secure_alpha_token"
      }
    }
  }
}

```

## Next steps [link](https://antigravity.google/\#next-steps)

Begin configuring your new visual parameters and troubleshooting any setup anomalies:

- **[Settings, Rendering & Keybindings](https://antigravity.google/docs/cli/settings)**: Customize keyboard hotkeys, themes, and screen buffers.
- **[Troubleshooting](https://antigravity.google/docs/cli/troubleshooting)**: Learn how to resolve authentication lockouts or path issues.
- **[CLI Reference](https://antigravity.google/docs/cli/reference)**: Access standard parameters lists and slash command mappings.

[Features](https://antigravity.google/docs/cli/features)

[Prompting & Interaction](https://antigravity.google/docs/cli/prompting)

On this Page

- Migrating from Gemini CLI

- Overview

- First-launch onboarding

- Converting extensions to plugins

- Context files and workspace rules

- Updated skills paths

- MCP config formatting changes

- Next steps