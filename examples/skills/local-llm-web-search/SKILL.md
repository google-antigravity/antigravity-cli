---
name: local-llm-web-search
description: Augment local Ollama or OpenAI-compatible models (127.0.0.1:11434) with live web search and parallel article extraction without external search API keys.
---

# Local LLM Web Search Skill (`ollama-web`)

Use this skill when the user wants to run a local model via Ollama (`127.0.0.1:11434`) grounded with live, up-to-date web search results and full-text page extraction.

## Workflow

1. **Discover Local Models Dynamically**:
   Query `http://127.0.0.1:11434/api/tags` to list installed Ollama models rather than hardcoding model tags.
2. **Execute Grounded Query**:
   Run `ollama_web_cli.py` with the target query and optional `--model`:
   ```bash
   python3 ~/.agents/skills/local-llm-web-search/ollama_web_cli.py "Latest Linux kernel 6.14 ARM64 features"
   ```
3. **Interactive Mode**:
   Launch an interactive grounded REPL session:
   ```bash
   python3 ~/.agents/skills/local-llm-web-search/ollama_web_cli.py -i
   ```
