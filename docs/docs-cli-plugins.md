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
>- Customizations
>- Plugins & Skills

# Plugins & skills [link](https://antigravity.google/\#plugins-skills)

Extend agent capabilities, install third-party extension bundles, package custom workflow skills, and interface with Model Context Protocol (MCP) servers.

## The extensibility model [link](https://antigravity.google/\#the-extensibility-model)

Antigravity CLI is designed for limitless customization. You can augment the shared agent harness by installing structured package modules called **Plugins** or creating localized markdown blueprints called **Skills**.

These customizations allow agents to access specialized proprietary commands, invoke domain-specific subagents, and consult customized style constraints.

## Antigravity plugins [link](https://antigravity.google/\#antigravity-plugins)

Plugins are namespaced bundles that package custom skills, background subagents, linting rules, Model Context Protocol definitions, and event hooks into a single deployable asset.

### Plugin filesystem structure [link](https://antigravity.google/\#plugin-filesystem-structure)

When you install or import a plugin, the CLI stages the bundle files within your global configuration path:

text

content\_copy

```
            ~/.gemini/antigravity-cli/plugins/<plugin_name>/

```

A compliant plugin contains the following layout:

text

content\_copy

```
            ~/.gemini/antigravity-cli/plugins/<plugin_name>/
├── plugin.json                 # Required package marker file
├── mcp_config.json             # Optional Model Context Protocol servers
├── hooks.json                  # Optional pre/post tool event hooks
├── skills/                     # Optional specialized skills directory
├── agents/                     # Optional subagent definition templates
└── rules/                      # Optional custom codebase rules files

```

### The plugin manifest (plugin.json) [link](https://antigravity.google/\#the-plugin-manifest-pluginjson)

The `plugin.json` file is a mandatory manifest located at the root of your plugin directory. It defines the plugin's identity and metadata.

**Manifest example**

json

content\_copy

```
            {
  "$schema": "https://antigravity.google/schemas/v1/plugin.json",
  "name": "my-plugin",
  "description": "A brief description of what my plugin does."
}

```

**Field reference**

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `name` | String | **Yes** | The unique, machine-readable name of the plugin. It must contain only alphanumeric characters, hyphens, and underscores (matches `^[a-zA-Z0-9-_]+$`). This name is used to reference the plugin in CLI commands. |
| `description` | String | No | A brief human-readable description of the plugin's purpose, displayed in plugin listings. |

**Automatic validation**

To enable automatic autocomplete and validation in editors like VS Code or WebStorm, include the `$schema` key pointing to the official schema URL:

json

content\_copy

```
            "$schema": "https://antigravity.google/schemas/v1/plugin.json"

```

**Full JSON Schema**

json

content\_copy

```
            {
  "$schema": "https://antigravity.google/schemas/v1/plugin.json",
  "title": "Antigravity Plugin Manifest",
  "description": "Schema for Antigravity CLI plugin manifest files (plugin.json)",
  "type": "object",
  "properties": {
    "name": {
      "type": "string",
      "description": "The unique, machine-readable name of the plugin. Must contain only alphanumeric characters, hyphens, and underscores.",
      "pattern": "^[a-zA-Z0-9-_]+$"
    },
    "description": {
      "type": "string",
      "description": "A brief human-readable description of the plugin's purpose and capabilities."
    }
  },
  "required": [\
    "name"\
  ],
  "additionalProperties": false
}

```

### Managing plugins via CLI subcommands [link](https://antigravity.google/\#managing-plugins-via-cli-subcommands)

The CLI exposes a `plugin` (or plural `plugins`) subcommand pipeline to manage your extensions:

- **List installed plugins**: Show active packages and their loaded components.

content\_copy

```
                agy plugin list

```

- **Install a local or remote plugin**: Stage a package directory into your local profile.

content\_copy

```
                agy plugin install /path/to/local/plugin

```

- **Disable/Enable a plugin**: Suspend a plugin's tools without deleting its assets.

content\_copy

```
                agy plugin disable <plugin_name>
    agy plugin enable <plugin_name>

```

- **Uninstall a plugin**: Purge the package directory and clean up registries.

content\_copy

```
                agy plugin uninstall <plugin_name>

```

## Agent skills [link](https://antigravity.google/\#agent-skills)

Skills are declarative, human-readable markdown files that outline explicit instruction protocols, scripts, and target resources for specialized engineering tasks.

Once registered, **Skills convert automatically into slash commands** inside the TUI, allowing you to invoke them manually (e.g., typing `/refactor-ui`).

### Creating local workspace skills [link](https://antigravity.google/\#creating-local-workspace-skills)

To deploy workspace-specific skills that stay with your git repository:

1. Create a directory named `.agents/skills/` at your project root.
2. Inside, draft a markdown file with a `.md` extension (such as `format-tests.md`).
3. Define the skill's Frontmatter metadata (see the example below).
4. Below the metadata, write explicit instructions for the agent. When you run `agy` in this directory, the skill is compiled, and `/format-tests` becomes available in the prompt box.

**Frontmatter example:**

yaml

content\_copy

```
            ---
name: format-tests
description: Standardize and re-format Python unittest assertions
---

```

### Sharing global skills [link](https://antigravity.google/\#sharing-global-skills)

To share skills across all workspaces on your workstation, place the target markdown files inside your global configuration path:

text

content\_copy

```
            ~/.gemini/antigravity-cli/skills/

```

Any markdown skill in this directory is automatically imported as a global slash command whenever you launch `agy` in any directory.

## Managing hooks [link](https://antigravity.google/\#managing-hooks)

Hooks intercept agent actions right before or immediately after execution. They are useful for running automated pre-flight checks or post-generation formats (such as running `prettier` after writing files).

Hooks are defined inside a plugin's `hooks.json` or configured inside your primary `settings.json` file. You can inspect all loaded and active hooks inside the TUI by typing:

text

content\_copy

```
            /hooks

```

## Model Context Protocol (MCP) [link](https://antigravity.google/\#model-context-protocol-mcp)

Model Context Protocol is an open standard enabling foundation models to interface securely with local APIs, file parsers, and custom developer tools.

For comprehensive documentation on configuring local and remote MCP servers in Antigravity CLI, accessing the interactive `/mcp` manager overlay, and understanding server schemas and authentication, see the dedicated [MCP Documentation](https://antigravity.google/docs/mcp).

## Next steps [link](https://antigravity.google/\#next-steps)

Learn how to migrate your existing configurations from Gemini CLI and troubleshoot connection anomalies:

- **[Migration from Gemini CLI](https://antigravity.google/docs/cli/gcli-migration)**: Fast-track your legacy extensions and config conversions.
- **[Troubleshooting](https://antigravity.google/docs/cli/troubleshooting)**: Resolve terminal hook errors, lockouts, or network failures.
- **[Permissions & Sandbox](https://antigravity.google/docs/cli/sandbox)**: Configure security containment rings around your custom plugins and MCP servers.

[MCP](https://antigravity.google/docs/mcp)

[Permissions](https://antigravity.google/docs/cli/permissions)

On this Page

- Plugins & skills

- The extensibility model

- Antigravity plugins

- Agent skills

- Managing hooks

- Model Context Protocol (MCP)

- Next steps