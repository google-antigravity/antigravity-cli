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
>- Installation & Auth

# Installation & auth [link](https://antigravity.google/\#installation-auth)

Install Antigravity CLI, configure enterprise requirements, and establish secure authenticated sessions.

## Installation [link](https://antigravity.google/\#installation-2)

Antigravity CLI runs natively on macOS, Linux, and Windows. Use the platform-specific scripts below to install or upgrade the binary on your system.

### macOS and Linux [link](https://antigravity.google/\#macos-and-linux)

Execute the native installer script to download and install the executable to `~/.local/bin/agy`:

bash

content\_copy

```
            curl -fsSL https://antigravity.google/cli/install.sh | bash

```

### Windows [link](https://antigravity.google/\#windows)

The installation script registers the `agy` binary to your local user directory: `C:\Users\<Username>\AppData\Local\agy\bin` (where `<Username>` represents your active Windows user profile).

**PowerShell**: Open PowerShell and execute the following installation script:

powershell

content\_copy

```
            irm https://antigravity.google/cli/install.ps1 | iex

```

**CMD**: Open a standard Command Prompt and execute:

cmd

content\_copy

```
            curl -fsSL https://antigravity.google/cli/install.cmd -o install.cmd && install.cmd && del install.cmd

```

### Installation flags [link](https://antigravity.google/\#installation-flags)

When executing the installation scripts, you can append the following customization flags:

- `--skip-aliases`: Bypasses shell profile alias purging (prevents the script from purging or updating legacy `agy` or `antigravity` shell aliases).
- `--skip-path`: Bypasses shell profile `PATH` appending (prevents the script from modifying your shell profile's dynamic environment variables).

## Authentication workflows [link](https://antigravity.google/\#authentication-workflows)

Antigravity CLI uses secure credentials and token profiles to communicate with the shared agent harness.

### Local silent keyring sign-in [link](https://antigravity.google/\#local-silent-keyring-sign-in)

When launching `agy` on your local machine, the CLI attempts to access your operating system's native secure keyring (such as Apple Keychain, Linux Secret Service/dbus, or Windows Credential Manager). If a valid token profile is found, the CLI authenticates your session silently without opening a browser.

If no saved session is found:

1. The CLI automatically launches your local default web browser.
2. Sign in using your approved account credentials.

### Remote SSH OAuth flow [link](https://antigravity.google/\#remote-ssh-oauth-flow)

When running over SSH, the CLI detects the remote connection environment. Because it cannot launch a local web browser, the CLI initiates a manual URL loop:

1. Launch `agy` in your remote terminal session.
2. The CLI detects the SSH environment and prints a unique, secure authorization URL.
3. Copy this URL and paste it into a web browser on your local machine.
4. Sign in with your approved credentials and complete the authentication.
5. The browser displays a unique alphanumeric authorization code.
6. Copy this code, return to your remote SSH terminal, and paste it into the prompt.

## Managing your session [link](https://antigravity.google/\#managing-your-session)

Terminating your session clears active credentials and local cache directories.

### Logging out [link](https://antigravity.google/\#logging-out)

To disconnect your account and purge saved authentication profiles from your operating system's keyring, run the following command in the CLI prompt box:

text

content\_copy

```
            /logout

```

## Next steps [link](https://antigravity.google/\#next-steps)

Once you complete installation and authentication, start interacting with your local agent:

- **[Tutorial](https://antigravity.google/docs/cli/tutorial)**: Create and run a basic Python project with an agent.
- **[Prompting & Interaction](https://antigravity.google/docs/cli/prompting)**: Explore multiline text editing, interrupt commands, and terminal media pasting.
- **[Permissions & Sandbox](https://antigravity.google/docs/cli/sandbox)**: Configure secure filesystem directories and command limits.

[Getting Started](https://antigravity.google/docs/cli/getting-started)

[Tutorial](https://antigravity.google/docs/cli/tutorial)

On this Page

- Installation & auth

- Installation

- Authentication workflows

- Managing your session

- Next steps