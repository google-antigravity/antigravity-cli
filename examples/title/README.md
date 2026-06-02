# Custom Window Title

This directory contains reference implementations for dynamically customizing the terminal window title for the Antigravity CLI across different shell environments:

1. **`title.sh`** (Bash/Zsh - Linux/macOS)
2. **`title.js`** (Node.js - Cross-platform: Windows/Linux/macOS)
3. **`title.ps1`** (PowerShell - Windows PowerShell or PowerShell Core `pwsh`)
4. **`title.fish`** (Fish shell - Linux/macOS)

## Quick Start

### Option 1: Automatic Setup (Recommended for Bash/Zsh)

Run the included setup script from the root of the repository:

```bash
bash examples/title/setup.sh
```

This script will automatically:
1. Copy `title.sh` to your platform's global settings directory (so it stays configured even if you move or delete this repository).
2. Configure and enable it in your global `settings.json` file.

### Option 2: Manual configuration

1. Copy the script corresponding to your shell to a directory of your choice.
2. Edit your `settings.json` file to point `title.command` to the absolute path of the script and set `title.enabled` to `true`:

#### Bash/Zsh (Linux/macOS)
```json
{
  "title": {
    "command": "/absolute/path/to/title.sh",
    "enabled": true
  }
}
```

#### Node.js (Cross-platform)
```json
{
  "title": {
    "command": "node /absolute/path/to/title.js",
    "enabled": true
  }
}
```

#### PowerShell (Windows / pwsh)
```json
{
  "title": {
    "command": "powershell.exe -ExecutionPolicy Bypass -File C:\\absolute\\path\\to\\title.ps1",
    "enabled": true
  }
}
```
*For PowerShell Core, use `pwsh.exe` or `pwsh` instead of `powershell.exe`.*

#### Fish Shell
```json
{
  "title": {
    "command": "/absolute/path/to/title.fish",
    "enabled": true
  }
}
```

**Settings file locations:**

| Platform | Path |
| :--- | :--- |
| Linux | `~/.gemini/antigravity-cli/settings.json` |
| macOS | `~/Library/Application Support/antigravity-cli/settings.json` |
| Windows | `%APPDATA%\antigravity-cli\settings.json` |

> [!IMPORTANT]
> The `command` field must be an **absolute path** to the script. Relative paths and `~` expansion are not supported.

After saving, restart `agy` for changes to take effect.

## How it works

The title script reads a JSON payload from standard input containing the CLI's state. It then:
1. Extracts the `agent_state` and workspace directory path.
2. Parses the current directory to determine a short workspace name.
3. Maps the agent state to a corresponding emoji (e.g., 🤔 for thinking, 🛠️ for tool use, 😴 for idle).
4. Outputs the formatted title string in the format: `[Emoji] [State] | [Workspace]`.

### Prerequisites

- **Bash (`title.sh`) & Fish (`title.fish`)**: Require [`jq`](https://jqlang.org/) to be installed and available in `$PATH`.
- **Node.js (`title.js`) & PowerShell (`title.ps1`)**: Have **zero external dependencies** and work out-of-the-box.

## Examples

### Idle State
![Idle State Title](images/title-idle.png)

### Review Mode
![Review Mode Title](images/title-review.png)

### Tool Confirmation
![Tool Confirmation Title](images/title-tool-confirmation.png)
