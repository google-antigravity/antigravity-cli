<p align="center">
  <b>English</b> | <a href="README-ZH.md">中文</a> | <a href="README-ES.md">Español</a> | <a href="README-FR.md">Français</a> | <a href="README-PT.md">Português</a> | <a href="README-UA.md">Українська</a> | <a href="README-DE.md">Deutsch</a>
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/agy-cli-demo.gif" alt="Antigravity CLI Logo" width="600" style="border-radius: 8px; box-shadow: 0 4px 20px rgba(0,0,0,0.25);" />
</p>

<h1 align="center">🚀 Antigravity CLI</h1>

<p align="center">
  <strong>Community-Fork & Hardened Offline Version of google-antigravity/antigravity-cli with automatic statusline & window title setup</strong>
</p>

<p align="center">
  <a href="https://github.com/weby-homelab/antigravity-cli"><img src="https://img.shields.io/badge/fork-google--antigravity-8a2be2?style=for-the-badge&logo=github" alt="GitHub Fork" /></a>
  <a href="CHANGELOG.md"><img src="https://img.shields.io/badge/version-1.0.8-success?style=for-the-badge&logo=git" alt="Version" /></a>
  <a href="https://antigravity.google/terms"><img src="https://img.shields.io/badge/license-Apache--2.0-blue?style=for-the-badge" alt="License" /></a>
  <img src="https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows-lightgrey?style=for-the-badge" alt="Supported Platforms" />
</p>

<p align="center">
  🤖 <b>AI coding agent directly in your terminal</b>. Understands the context of your codebase, creates and edits files, executes secure commands in a sandbox, and solves complex architectural tasks in a single prompt.
</p>

---

## ⚡ Quick Start

### Instant Installation (Offline-first & Zero-dependency)
This fork downloads precompiled binaries directly from **GitHub Release Assets** (instead of Google API servers). Completely offline installation is also supported if the required archives were preloaded into the `packages/binaries/` folder.

#### 🐧 Linux and 🍎 macOS
```bash
# Network installation from the fork repository:
curl -fsSL https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/install.sh | bash

# OR offline installation from a local repository:
git clone https://github.com/weby-homelab/antigravity-cli.git
cd antigravity-cli
# (Optional: download platform archives to packages/binaries/)
make install
```

#### 🪟 Windows PowerShell
```powershell
# Network installation:
irm https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/install.ps1 | iex

# OR offline installation from a cloned repository:
.\install.ps1
```

#### 🪟 Windows CMD
```cmd
# Network installation:
curl -fsSL https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/install.cmd -o install.cmd && install.cmd && del install.cmd

# OR offline installation from a cloned repository:
install.cmd
```

---

## 📋 Key Features

> [!NOTE]
> Unlike the original version, this fork is adapted for stable operation in headless/SSH sessions and local home labs.

*   📂 **Multi-file Editing** — Edits multiple files simultaneously in your workspace with prior confirmation of changes.
*   🔒 **Secure Shell Commands** — Executes any terminal commands in the built-in Docker container (sandbox) or on the host system.
*   🧠 **Multi-step Reasoning (PAV)** — Independently builds a task execution plan, tests code, and debugs its own errors.
*   💾 **Persistent Conversation History** — Saves the complete conversation context and workspace state between sessions.
*   🔌 **Plugin System** — Extend the agent's capabilities with custom *Skills* and MCP (Model Context Protocol) servers.

---

## ⚙️ Configuration

### 1. Project Configuration (`GEMINI.md`)
Create a `GEMINI.md` file in the root of your project to provide specific context and development rules to the AI agent:

```markdown
# Project Context

- This project uses FastAPI and Pydantic v2.
- Always use `model_dump()` instead of the deprecated `dict()`.
- STRICT RULE: No hardcoded passwords in code. Import all secrets from `.env`.
```

### 2. Global Settings (`~/.gemini/antigravity-cli/settings.json`)
The global settings file controls tool execution permissions, statusline/title scripts, and MCP servers:

- **Linux/Unix**: `~/.gemini/antigravity-cli/settings.json`
- **macOS**: `~/Library/Application Support/antigravity-cli/settings.json`
- **Windows**: `%APPDATA%\antigravity-cli\settings.json`

```json
{
  "toolPermission": "always-proceed",
  "statusLine": {
    "enabled": true,
    "command": "/home/user/.gemini/antigravity-cli/statusline.sh"
  },
  "title": {
    "enabled": true,
    "command": "/home/user/.gemini/antigravity-cli/title.sh"
  },
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"]
    }
  }
}
```

> [!TIP]
> For an advanced, responsive statusline with real-time Git status, token meters, model quotas, and power/battery state, check out the **[Antigravity CLI Statusline (Max Edition)](https://github.com/weby-homelab/antigravity-cli-statusline)** plugin.


### 3. Specialized Agents
You can describe custom roles and instructions for AI agents in JSON format. Each agent must have its own directory containing an `agent.json` file:

- **Global Agents (Linux/Unix)**: `~/.gemini/antigravity-cli/agents/{agent_name}/agent.json`
- **Global Agents (macOS)**: `~/Library/Application Support/antigravity-cli/agents/{agent_name}/agent.json`
- **Global Agents (Windows)**: `%APPDATA%\antigravity-cli\agents\{agent_name}\agent.json`
- **Local Agents (Project Workspace)**: `{workspace_root}/.agents/agents/{agent_name}/agent.json`

```json
{
  "name": "security-reviewer",
  "description": "Analyzes code for vulnerabilities before commit",
  "instructions": "Check changes for:\n- OWASP Top 10 vulnerabilities\n- Leakage of API keys or secrets\n- Correctness of firewall/nftables configuration"
}
```

---

## 🔐 Authentication Methods

| Method | Command / Variable | Limitations & Features |
| :--- | :--- | :--- |
| **Google Auth (Browser)** | Automatically on first `agy` | Standard login. Free limit: 60 req/min, 1000 req/day |
| **API Key (Offline)** | `export GEMINI_API_KEY="X"` | Recommended for servers and automation |
| **Vertex AI** | `export GOOGLE_GENAI_USE_VERTEXAI=true` | Enterprise level with Google Cloud cloud infrastructure |
| **Sign Out** | `/logout` | Clearing local session tokens |

---

## 🔧 Command Reference

### Command Line
```bash
agy                              # Start an interactive session
agy -p "Prompt"                  # One-time execution without entering chat
agy -c                           # Continue the last incomplete conversation
agy --conversation <ID>          # Load a session by specific ID
agy --sandbox                    # Run in an isolated Docker container
agy update                       # Update binary to the latest version
agy plugin list                  # List installed plugins
```

### Slash Commands in Chat Interface
*   `/help` — Help on available tools.
*   `/settings` — Interactive settings configuration.
*   `/usage` — Statistics of spent tokens and quota.
*   `/diff` — View current unsaved changes in the project.
*   `/statusline` — Configure terminal status line display.

---

## 🔄 Migration from Gemini CLI

> [!WARNING]
> The original Gemini CLI (`gemini`) is deprecating support for non-enterprise accounts on **June 18, 2026**. Migration to Antigravity CLI is required.

### Steps for Quick Transition
1. Install the new client: `curl -fsSL https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/install.sh | bash`
2. Migrate local custom agent configuration files (e.g. convert custom agents from YAML inside `~/.gemini/agents/` to JSON files at `~/.gemini/antigravity-cli/agents/{agent_name}/agent.json`).
3. Update CI/CD configurations in GitHub Actions, replacing `gemini` calls with `agy`.
4. Uninstall the old library: `npm uninstall -g @google/gemini-cli`

### Comparison Table

| Feature | Gemini CLI (Legacy) | Antigravity CLI (Modern) |
| :--- | :--- | :--- |
| **Development Platform** | Node.js / TypeScript | Go (Native Compiled Binary) |
| **Command Name** | `gemini` | `agy` |
| **Startup Speed** | ~1.2s (Node.js startup) | **~0.05s (instant native startup)** |
| **Configuration File** | `GEMINI.md` | `GEMINI.md` |
| **Auto-update** | Via `npm update` | Built-in self-update mechanism |
| **Support Status** | ⛔ EOL (June 18, 2026) | ✅ Active Development (Upstream) |

---

## 📁 Repository Structure

```
antigravity-cli/
├── install.sh           # Installer for Linux/macOS (offline/online)
├── install.ps1          # Installer for Windows PowerShell (offline/online)
├── install.cmd          # Installer for Windows CMD
├── Makefile             # Automation targets (make install/reinstall/uninstall)
├── GEMINI.md            # Project context file template
├── packages/            # Local offline distribution
│   ├── manifests/       # Version manifests for all platforms
│   └── binaries/        # (Created manually for offline mode)
└── CHANGELOG.md         # Changelog and release log
```

---

## 🤝 Contributing & Community

This repository is an independent community fork of the original [google-antigravity/antigravity-cli](https://github.com/google-antigravity/antigravity-cli) project.

**Our Enhancements:**
*   🌍 Multi-language localization support for docs and guides.
*   📦 Autonomy: offline installation capability without Google API downloads.
*   🛠️ Convenience: added `Makefile` for a simplified tool lifecycle.
*   🛡️ Security: regular bug fixes and improvements to the sandbox environment.

---

## 📜 Legal & Trademark Notice

*   **Official Links**: [Official Documentation Repo](https://github.com/google-antigravity/antigravity-cli) · [Official CLI Codebase](https://github.com/google-gemini/gemini-cli) · [Official Website](https://antigravity.google)
*   **Terms of Use**: [antigravity.google/terms](https://antigravity.google/terms) · [policies.google.com/privacy](https://policies.google.com/privacy)

> [!IMPORTANT]
> **Fork Legal Status:**
> This repository is an independent non-commercial copy (Community Fork) of the original client. It **is not** an official product of Google LLC. Google LLC is not responsible for the performance, modifications, or safety of this fork.
> 
> **Licensing & Copyrights:**
> The original software is distributed under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0). All original code is the intellectual property of **Copyright © 2025 Google LLC**.
> 
> **Trademark Use:**
> The name "Antigravity CLI" and associated logos are used within Customary Use limits solely to describe the origin, compatibility, and functional purpose of the software. This project does not claim ownership of any Google LLC trademarks.
> 
> **Disclaimer of Warranty:**
> The software is provided on an "AS IS" basis, WITHOUT WARRANTIES OF ANY KIND, either express or implied. You assume all responsibility and risks associated with its use.

> [!CAUTION]
> AI coding agents work autonomously. Always carefully review the proposed diff blocks and commands before confirming execution, especially when working with system files or firewall configuration.
