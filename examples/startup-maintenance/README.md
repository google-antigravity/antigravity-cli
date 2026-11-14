# Startup Stdin Drain & Trajectory Store Maintenance

On workstations that frequently spawn subagents, `~/.gemini/antigravity-cli/conversations/` accumulates internal subagent trajectory SQLite databases (`trajectory_type = 22`) alongside primary user conversation databases (`trajectory_type = 4`).

Because `reconcile_summaries.go` scans all `*.db` files in `conversations/` during initialization, large numbers of `trajectory_type = 22` files cause `manager_created` to stall for several seconds before `tui_init_start` places the terminal (`/dev/pts/*`) into raw mode. Any buffered `agy\n` bytes in the PTY input queue during this window can bleed directly into `input_loop.go:HandleUserInput` as the session's first prompt ([Issue #1465](https://github.com/google-antigravity/antigravity-cli/issues/1465)).

## Components

1. **`agy-store-maintain.py`**:
   - Moves non-user `trajectory_type = 22` databases out of `~/.gemini/antigravity-cli/conversations/` into `~/.gemini/antigravity-cli/subagent_trajectories_archive/`.
   - Audits `~/.agents/rules/*.md` and `~/.agents/skills/*/SKILL.md` for missing YAML frontmatter (`trigger: always_on`, `name`, `description`) that would otherwise log `CORTEX_MEMORY_TRIGGER_UNSPECIFIED` errors during startup.
2. **`agy-tty-wrapper.sh`**:
   - Shell wrapper function for `~/.bashrc` or `~/.zshrc` that calls `termios.tcflush(sys.stdin, termios.TCIFLUSH)` before TUI initialization so pre-startup keystrokes never leak into prompt `#0`.

## Usage

```bash
python3 examples/startup-maintenance/agy-store-maintain.py
source examples/startup-maintenance/agy-tty-wrapper.sh
```
