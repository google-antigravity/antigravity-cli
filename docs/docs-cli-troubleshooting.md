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
>- Troubleshooting

# Troubleshooting [link](https://antigravity.google/\#troubleshooting)

Diagnose and resolve common anomalies with installation PATHs, local self-updating locks, keyring access permissions, and SSH clipboard forwarding.

## Quick reference [link](https://antigravity.google/\#quick-reference)

Scan the lookup table below to identify symptoms and access immediate solutions:

| Error Symptom | Potential Cause | Target Resolution |
| --- | --- | --- |
| **`agy: command not found`** | Binary directory missing from shell environments. | [Configure your shell PATH](https://antigravity.google/#configure-your-shell-path) |
| **`keyring: secure lock out`** | Missing system service permissions or active lockouts. | [Authorize keyring permissions](https://antigravity.google/#authorize-keyring-permissions) |
| **`SSH Clipboard paste failures`** | Protocol streams blocked or missing forward configurations. | [Enable emulator clipboard forwarding](https://antigravity.google/#enable-emulator-clipboard-forwarding) |
| **`Advisory lock / update failures`** | Locked self-updater thread or read-only directory paths. | [Resolve self-updater locks and failures](https://antigravity.google/#resolve-self-updater-locks-and-failures) |

\-\-\-

## Configure your shell PATH [link](https://antigravity.google/\#configure-your-shell-path)

### Symptom [link](https://antigravity.google/\#symptom)

Executing `agy` returns a shell terminal error:

bash

content\_copy

```
            bash: agy: command not found

```

### Cause [link](https://antigravity.google/\#cause)

The installation utility downloads the binary to `~/.local/bin` (or `C:\Users\<Username>\AppData\Local\agy\bin`), but your shell's active `$PATH` environment does not index this directory.

### Resolution [link](https://antigravity.google/\#resolution)

Ensure your terminal session loads the binary path.

**macOS & Linux**:

1. Open your shell configuration file (`~/.bashrc` or `~/.zshrc`).
2. Verify or append the following line at the end of the file:

content\_copy

```
                export PATH="~/.local/bin:$PATH"

```

1. Reload your profile configurations:

content\_copy

```
                source ~/.zshrc

```

**Windows (PowerShell)**:

1. Open a PowerShell terminal as an Administrator and execute:

content\_copy

```
                [System.Environment]::SetEnvironmentVariable("Path", [System.Environment]::GetEnvironmentVariable("Path", "User") + ";C:\Program Files\Google\antigravity-cli", "User")

```

1. Restart your terminal emulator for the system registry environment to refresh.

\-\-\-

## Authorize keyring permissions [link](https://antigravity.google/\#authorize-keyring-permissions)

### Symptom [link](https://antigravity.google/\#symptom-2)

When launching, the CLI hangs, prints DBUS warnings, or throws keyring access exceptions:

text

content\_copy

```
            Error: failed to retrieve token: secret keyring is locked

```

### Cause [link](https://antigravity.google/\#cause-2)

Antigravity CLI utilizes secure keychain libraries (Apple Keychain, Linux secret-service via dbus, or Windows Credential Manager) to encrypt your session tokens. If the background daemon is locked or headless, the CLI cannot read credentials.

### Resolution [link](https://antigravity.google/\#resolution-2)

**macOS**:

1. Open **Keychain Access** app.
2. Search for the `Antigravity CLI` security item.
3. Right-click, select **Get Info**, choose the **Access Control** tab, and verify that `agy` is on the allowed applications list.
4. If running inside a headless SSH session on Mac, run the following unlock sequence:

content\_copy

```
                security unlock-keychain -p "your_keychain_password" login.keychain

```

**Linux**:

Ensure your system keyring (such as GNOME Keyring or KWallet) is unlocked and accessible.

If you are running in a headless environment or over SSH, ensure that a D-Bus session is active and that your keyring daemon is running. You can typically initialize a D-Bus session by running:

bash

content\_copy

```
            export $(dbus-launch)

```

If you still experience access issues, ensure your user account has the necessary permissions to access the keyring service or reach out to support.

\-\-\-

## Enable emulator clipboard forwarding [link](https://antigravity.google/\#enable-emulator-clipboard-forwarding)

### Symptom [link](https://antigravity.google/\#symptom-3)

Pasting screenshots or media files via `Ctrl+V` within an SSH terminal returns a failure notification:

text

content\_copy

```
            Error: local pasteboard is empty or unreachable over SSH connection

```

### Cause [link](https://antigravity.google/\#cause-3)

Standard SSH streams do not forward graphical clipboards. Graphic uploads require specific terminal multiplexer protocols.

### Resolution [link](https://antigravity.google/\#resolution-3)

Verify that you are utilizing supported terminal emulators and configurations.

1. **Use iTerm2 or Ghostty**: These emulators support advanced clip channels.
2. **Configure iTerm2 Forwarding**:

- Open iTerm2 Preferences (`Cmd+,`).
- Go to the **General** tab, select **Selection** submenu.
- Check **Applications in terminal may access clipboard** (enabling OSC 52 write channels).

1. **Bypass Multiplexers**: If running inside `tmux`, ensure your active configuration maps standard paste clips correctly:

content\_copy

```
                set -s set-clipboard on

```

\-\-\-

## Resolve self-updater locks and failures [link](https://antigravity.google/\#resolve-self-updater-locks-and-failures)

### Symptom [link](https://antigravity.google/\#symptom-4)

Launching `agy` hangs, fails to apply upgrades, or returns an advisory lock warning:

text

content\_copy

```
            Warning: another background updater process is already active (update.lock)

```

### Cause [link](https://antigravity.google/\#cause-4)

Antigravity CLI contains a native, statically linked self-updater that runs in the background. It uses a 15-minute Time-To-Live (TTL) debounce marker (`last_check.timestamp`) and an advisory lock (`update.lock`) inside `~/.gemini/antigravity-cli/updater/` to prevent concurrent process collisions. If a background updater process hangs, crashes without releasing the lock, or has insufficient user filesystem permissions inside the executable directory, subsequent updates are blocked.

### Resolution [link](https://antigravity.google/\#resolution-4)

- **Release the advisory lock**: Purge the background lock file manually:

content\_copy

```
                rm -f ~/.gemini/antigravity-cli/updater/update.lock

```

- **Opt-out/Disable auto-updates**: Set the `AGY_CLI_DISABLE_AUTO_UPDATE` environment variable to `true` inside your shell profile (`~/.bashrc` or `~/.zshrc`):

content\_copy

```
                export AGY_CLI_DISABLE_AUTO_UPDATE=true

```

- **Verify directory write permissions**: Ensure your user profile owns and has write permissions inside the target installation directory (`~/.local/bin/` on Unix, or `%LOCALAPPDATA%\agy\bin` on Windows).

\-\-\-

## Next steps [link](https://antigravity.google/\#next-steps)

Access our quick reference sheets or configure advanced permissions:

- **[CLI Reference](https://antigravity.google/docs/cli/reference)**: Dense tables listing all slash commands and visual settings keys.
- **[Permissions](https://antigravity.google/docs/cli/permissions)**: Configure fine-grained allowed and denied action policies.
- **[Sandbox](https://antigravity.google/docs/cli/sandbox)**: Enforce OS-level container isolation boundaries.
- **[Plugins & Skills](https://antigravity.google/docs/cli/plugins)**: Create your own custom skills.

[Best Practices](https://antigravity.google/docs/cli/best-practices)

[CLI Reference](https://antigravity.google/docs/cli/reference)

On this Page

- Troubleshooting

- Quick reference

- Configure your shell PATH

- Authorize keyring permissions

- Enable emulator clipboard forwarding

- Resolve self-updater locks and failures

- Next steps