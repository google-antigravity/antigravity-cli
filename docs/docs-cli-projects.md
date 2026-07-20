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
>- Projects

# Projects [link](https://antigravity.google/\#projects)

Manage projects and organize conversation sessions in the Antigravity CLI.

## Launching sessions with projects [link](https://antigravity.google/\#launching-sessions-with-projects)

### 1\. Default project execution [link](https://antigravity.google/\#1-default-project-execution)

When starting the CLI without any project flags, all conversations in the session will be in the `default-cli-project`:

bash

content\_copy

```
            agy

```

### 2\. Opening a session in a specific project [link](https://antigravity.google/\#2-opening-a-session-in-a-specific-project)

If you want to open a session attached to a specific existing project, pass the `--project` flag with the target project ID:

bash

content\_copy

```
            agy --project=<project_id>

```

### 3\. Creating a new project on startup [link](https://antigravity.google/\#3-creating-a-new-project-on-startup)

If you want to create a brand new project and initialize your CLI session inside it, pass the `--new-project` flag:

bash

content\_copy

```
            agy --new-project

```

### 4\. Resuming an existing conversation [link](https://antigravity.google/\#4-resuming-an-existing-conversation)

If you resume a conversation (whether on startup via `--conversation=<conv_id>` or during a session using `/resume`), the conversation's associated project will automatically be used.

## Moving conversations between projects (\`/fork\`) [link](https://antigravity.google/\#moving-conversations-between-projects-fork)

While interacting in an active session, you can copy and continue your current conversation to a different project using the `/fork` slash command:

text

content\_copy

```
            /fork <project_id>

```

When executed, the CLI forks your current conversation and associates the newly created conversation with `<project_id>`.

[Choose an execution mode](https://antigravity.google/docs/cli/modes)

[Background Tasks & Subagents](https://antigravity.google/docs/cli/subagents)

On this Page

- Projects

- Launching sessions with projects

- Moving conversations between projects (\`/fork\`)