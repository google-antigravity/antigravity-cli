---
name: skill-generator
description: >-
  Interactive AI-powered skill generator and scaffolding tool for Google Antigravity. Use when asked to generate, create, design, or scaffold a new Antigravity agent skill, or when asked to launch the skill generator TUI.
---

# Antigravity Skill Generator

Generates, scaffolds, and configures new Google Antigravity agent skills using Gemini AI.

## Overview

This skill allows agents and users to rapidly bootstrap production-ready skills following the official Google Antigravity Skill specification. It supports:
1. **Interactive TUI**: A clean Textual terminal interface with automated credential discovery and instant status notifications.
2. **Headless / CLI Mode**: Automated scaffolding from terminal commands or scripts.

## Prerequisites

* **Python 3.10+** with `uv` installed.
* **GEMINI_API_KEY**: Required for AI-powered skill generation. Can be set in `.env`, `.env.local`, or the shell environment.

## Usage

### 1. Launching the Interactive TUI
To open the interactive TUI generator:
```bash
uv run --with textual --with google-genai python skill_generator_tui.py
```

### 2. Command-Line Scaffolding
To scaffold directly from the command line:
```bash
python skill_generator.py "My Skill Name" -d "Description of when the agent should use this skill" -o skills
```

## Generated Skill Structure

Every generated skill produces:
```text
skills/<skill-slug>/
├── SKILL.md            # Frontmatter, overview, phased steps, and verification
├── scripts/            # Executable helper scripts and tool wrappers
├── references/         # API specs, manuals, and deep documentation
├── examples/           # Sample invocations and before/after references
└── resources/          # Templates and data assets
```
