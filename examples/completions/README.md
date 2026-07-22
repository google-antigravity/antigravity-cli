# Antigravity CLI Shell Completions

This directory contains autocompletion definitions for `agy` for Bash, Zsh, and Fish.

## 🚀 Quick Setup

### 1. Zsh Setup
Place `agy.zsh` into your `$fpath` (or `~/.zsh/completions/`):
```zsh
mkdir -p ~/.zsh/completions
cp examples/completions/agy.zsh ~/.zsh/completions/_agy
chmod 755 ~/.zsh/completions
chmod 644 ~/.zsh/completions/_agy
```

Add the following to your `~/.zshrc`:
```zsh
fpath=(~/.zsh/completions $fpath)
autoload -Uz compinit && compinit
```

> **Note on Zsh "Insecure Directories" error:**
> Ensure directory permissions are restrictive (`chmod 755 ~/.zsh/completions` and `chmod 644 ~/.zsh/completions/_agy`).

---

### 2. Bash Setup
Source `agy.bash` in your `~/.bashrc`:
```bash
mkdir -p ~/.local/share/bash-completion/completions
cp examples/completions/agy.bash ~/.local/share/bash-completion/completions/agy
```

Or append to `~/.bashrc`:
```bash
source /path/to/examples/completions/agy.bash
```

---

### 3. Fish Setup
Copy `agy.fish` to `~/.config/fish/completions/`:
```fish
mkdir -p ~/.config/fish/completions
cp examples/completions/agy.fish ~/.config/fish/completions/agy.fish
```
