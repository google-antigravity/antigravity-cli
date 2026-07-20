[Google Antigravity](https://www.antigravity.google/)

Products keyboard\_arrow\_down

Use Cases keyboard\_arrow\_down

Pricing

Blog

Resources keyboard\_arrow\_down

Download download

menu

Products keyboard\_arrow\_down

Explore our next generation products

[See overview](https://www.antigravity.google/product)

Products

[antigravity Antigravity 2.0](https://www.antigravity.google/product/antigravity-2) [terminal Antigravity CLI](https://www.antigravity.google/product/antigravity-cli) [code Antigravity IDE](https://www.antigravity.google/product/antigravity-ide) [sdk Antigravity SDK](https://www.antigravity.google/product/antigravity-sdk)

Use Cases keyboard\_arrow\_down

Built for developers in the agent-first era

[See overview](https://www.antigravity.google/use-cases)

[Enterprise](https://www.antigravity.google/use-cases/enterprise) [Frontend](https://www.antigravity.google/use-cases/frontend) [Fullstack](https://www.antigravity.google/use-cases/fullstack) [Science](https://www.antigravity.google/use-cases/science) [Marketer](https://www.antigravity.google/use-cases/marketer)

Pricing  Blog  Resources keyboard\_arrow\_down

Everything you need to stay up-to-date and get help

[Documentation keyboard\_arrow\_right](https://www.antigravity.google/docs) [Changelog](https://www.antigravity.google/changelog) [Support](https://www.antigravity.google/support) [Press](https://www.antigravity.google/press) [Releases](https://www.antigravity.google/releases)

[Home](https://www.antigravity.google/docs/home)

Antigravity 2.0 expand\_more

[Overview](https://www.antigravity.google/docs/overview)

[Getting Started](https://www.antigravity.google/docs/getting-started)

[Build with Google](https://www.antigravity.google/docs/build-with-google)

[Feature Overview](https://www.antigravity.google/docs/features)

[Models](https://www.antigravity.google/docs/models)

[Projects](https://www.antigravity.google/docs/projects)

Settings chevron\_right

Customizations chevron\_right

Agent Capabilities chevron\_right

Artifacts chevron\_right

Antigravity CLI chevron\_right

Antigravity SDK chevron\_right

Antigravity IDE chevron\_right

Migration chevron\_right

[Enterprise](https://www.antigravity.google/docs/enterprise)

[Plans](https://www.antigravity.google/docs/plans)

[FAQ](https://www.antigravity.google/docs/faq)

- side\_navigation
- Antigravity 2.0
>- Getting Started

# Getting Started with Antigravity 2.0 [link](https://www.antigravity.google/\#getting-started-with-antigravity-20)

### Download [link](https://www.antigravity.google/\#download)

Visit [antigravity.google/download](https://antigravity.google/download) to download Google Antigravity 2.0.

- **macOS**: macOS versions with Apple security update support. This is typically the current and two previous versions. Min Version 12 (Monterey), X86 is not supported.
- **Windows**: Windows 10 (64 bit)
- **Linux**: glibc >= 2.28, glibcxx >= 3.4.25 (e.g. Ubuntu 20, Debian 10, Fedora 36, RHEL 8)

### Installation [link](https://www.antigravity.google/\#installation)

You may get a notification asking whether you want to “Keep Both” or “Replace” Antigravity, select “Replace.” You will be prompted to re-install the IDE during installation, should you choose to. If you do not install it now and would like to re-download it later, you can do so [here](https://www.antigravity.google/download).

### Creating a Project [link](https://www.antigravity.google/\#creating-a-project)

Agents work within Projects, which define the boundaries of the folders and repositories they can access.

1. Click the **folder with a "+" icon** in the **left sidebar**.
2. Click on **"New Project"**.
3. Click **Add Folder** to associate one or more local folders or Git repositories. Adding multiple folders provides your agent with full cross-repository context.
4. Click **Create**.
5. _(Optional)_ Configure your Project's settings. Each Project maintains its own isolated settings and security policies that the agent respects.

### Starting an Agent [link](https://www.antigravity.google/\#starting-an-agent)

Once your Project is created, you can spawn an agent to start working on tasks.

1. Type your goal or instruction in the chat input (e.g., "Help me add a new feature") and press **Enter**.
2. Choose a **Mode** in the setup modal to boot up your agent:

- **Local Mode**: The agent operates directly in your active folders.
- **New Worktree Mode**: The agent operates in an isolated Git worktree.

### Basic Navigation [link](https://www.antigravity.google/\#basic-navigation)

| Action | macOS | Windows / Linux |
| --- | --- | --- |
| **Open Conversation Picker** | `⌘K` | `Ctrl + K` |
| **Open File Search** | `⌘P` | `Ctrl + P` |
| **Focus Input** | `⌘L` | `Ctrl + L` |
| **New Conversation** | `⌘N` | `Ctrl + N` |
| **Next/Previous Conversation** | `⌥ Up / Down` | `Alt + Up / Down` |

### Slash Commands [link](https://www.antigravity.google/\#slash-commands)

- `/goal`: Run until the specified task is completely finished, not asking for intermediate input from the user.
- `/grill-me`: Before starting to implement, ask questions back to align on the specific details of the plan.
- `/schedule`: Run an instruction as a one-time timer in the future or on some recurring schedule (via Scheduled Tasks)
- `/browser`: We heard the feedback that the agents were still not capable enough to determine exactly when to be using the browser. So for now, we’ve made it such that an explicit slash command controls these behaviors. When used, the agent diligently uses the browser primitives. This requires both Google Chrome and the user to provide permission in Google Chrome to start a debugging session.

[Overview](https://www.antigravity.google/docs/overview)

[Build with Google](https://www.antigravity.google/docs/build-with-google)

On this Page

- Getting Started with Antigravity 2.0