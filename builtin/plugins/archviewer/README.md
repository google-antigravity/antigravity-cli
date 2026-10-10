# 👷‍♂️ Antigravity ArchViewer Plugin

**ArchViewer** is a zero-token, privacy-first architectural diagram generator for [Google Antigravity](https://github.com/google/antigravity).

It intelligently watches your agentic brainstorming sessions and, the moment an architecture plan is solidified, autonomously drafts and renders a professional, full-color system topology map using [D2 (Declarative Diagramming)](https://d2lang.com/)—without spending a single LLM token on image generation.

## 🌟 Value Proposition for the Developer Community

1. **Zero-Token High-Fidelity Rendering**: Spare yourself from wasting expensive image-generation tokens or dealing with messy text generation. The agent drafts a deterministic D2 file, and local rendering takes over.
2. **Absolute Data Privacy**: Sensitive cloud topologies and node relationships never leave your machine to be rendered by third-party web services.
3. **Diagrams-as-Code (GitOps Ready)**: The intermediate `architecture.d2` means the layout is natively version-controllable. Manually tweak the file, PR the changes, and generate diffs in your CI/CD pipelines.
4. **Frictionless Portability**: Works out of the box locally provided the `d2` compiler is installed.

## 📦 Installation

Ensure you have D2 installed on your system (e.g., `brew install d2` on macOS).

Copy this directory structure into your workspace's `.agents` or your global `~/.gemini/config` directory:

```text
.agents/plugins/archviewer/
├── plugin.json
├── README.md
├── architecture.d2       (Auto-generated)
├── logo.svg              (Official Chat Logo)
├── rules/
│   └── AGENTS.md           (Agent instructions)
└── skills/
    └── arch/
        └── SKILL.md        (Slash command definition)
```

## 🚀 How it Works

When chatting with Antigravity:
1. Brainstorm your architecture.
2. When the plan is **solidified** (e.g., you say "Looks good, let's build it"), Antigravity automatically outputs an `architecture.d2` file.
3. Antigravity runs the D2 compiler to generate an `architecture.png` file and automatically opens it.
4. Type `/arch` in the chat at any time to instantly pop open the latest generated diagram on your OS.
