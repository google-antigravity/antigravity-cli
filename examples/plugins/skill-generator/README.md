# ⚡ Antigravity Skill Generator Plugin

**Skill Generator** is an interactive AI-powered scaffolding tool for [Google Antigravity](https://github.com/google-antigravity/antigravity-cli).

It allows developers to bootstrap production-ready Antigravity skills following official ecosystem standards—either through an interactive terminal UI (TUI) or headless CLI commands.

---

## 🌟 Features

* **Interactive Terminal UI**: Built with Textual, featuring zero-hassle credential discovery, clean native terminal theming, and keyboard shortcuts (`Enter` to generate, `Esc` to exit).
* **Automated Credential Discovery**: Automatically finds `GEMINI_API_KEY` from process environment, repo `.env`, `.env.local`, or user global configs (`~/.gemini/env`).
* **Official Skill Architecture**: Automatically scaffolds:
  * YAML frontmatter with strict `name:` and `description:` schemas.
  * Phased execution procedures (Pre-flight checks, Core action, Verification).
  * Standard folder hierarchy (`scripts/`, `references/`, `examples/`, `resources/`).
* **Headless CLI Support**: Scriptable for CI/CD pipelines and developer terminal workflows.

---

## 📦 Installation

Ensure you have Python 3.10+ and `uv` installed.

### Option 1: Workspace Installation
Copy or symlink this directory into your project's `.agents/plugins/`:
```bash
mkdir -p .agents/plugins
cp -r skill-generator .agents/plugins/
```

### Option 2: Global Installation
Copy or symlink into your global Antigravity plugins directory:
```bash
ln -sfn /path/to/skill-generator ~/.gemini/config/plugins/skill-generator
```

---

## 🚀 Usage

### 1. Launching the Interactive TUI
```bash
uv run --with textual --with google-genai python skill_generator_tui.py
```
* **Enter Skill Goal**: Type your desired skill (e.g., `deploy-to-gcp`, `sync-jira-issues`, `docker-cleanup`).
* **Select Pattern**: Choose CLI, API, Workflow, or Audit.
* **Press Enter**: Automatically scaffolds the full skill structure.

### 2. Command-Line Scaffolding
```bash
python skill_generator.py "deploy-to-gcp" -d "Deploy applications to GCP Cloud Run with automated pre-flight checks" -o skills
```
