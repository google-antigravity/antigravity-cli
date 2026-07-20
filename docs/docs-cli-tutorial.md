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
>- Tutorial

# Antigravity CLI Tutorial [link](https://antigravity.google/\#antigravity-cli-tutorial)

Learn how to launch Antigravity CLI, collaborate with an autonomous local agent, review generated files, and execute terminal test commands.

## Overview [link](https://antigravity.google/\#overview)

This guide walks you through a rapid onboarding exercise. You will direct an autonomous agent to create a Python utility script, review the changes, and verify its execution.

## Step-by-step [link](https://antigravity.google/\#step-by-step)

1. Create a clean project directory and launch the Antigravity TUI

content\_copy

```
                mkdir agy-demo && cd agy-demo
    agy

```

info

**First Launch**: If running `agy` for the first time, follow the terminal instructions to complete silent authentication. See [Installation & Auth](https://antigravity.google/docs/cli/install) for troubleshooting details.

1. Prompt the agent to generate a Python scraping script

Type the following instruction in the prompt box at the bottom of your screen and press `Enter`:

content\_copy

```
                Write a simple python script to fetch web page text

```

The agent reads the workspace, determines that no files exist, and formulates a plan to create a script. You will see real-time updates as the agent performs reasoning and schedules actions.

1. Open the artifact review screen to inspect the proposed code

Once the agent finishes generating the file, a notification appears. Press `ctrl+r` to enter the **Artifact Review** screen.

- Navigate to the newly created `main.py` using `↑`/`↓`.
- Review the complete file content and diff.
- Press `y` to approve the creation of `main.py`.
- Press `Esc` to close the review panel and return to the primary prompt.

1. Execute a test command with the agent to verify the output

Direct the agent to run the Python script to verify its behavior. Type the following command in the prompt box and press `Enter`:

content\_copy

```
                Run the python script and show me the output

```

The agent proposes to run `python3 main.py`. Press `y` to confirm and execute the command. The agent runs the script locally and streams the standard output directly into your terminal screen.

1. Exit the Antigravity session

Once you complete your task, press `ctrl+d` (or type `/exit`) in the prompt box to close the TUI and restore your original shell session.

## Next steps [link](https://antigravity.google/\#next-steps)

Now that you have executed your first agent-assisted workflow, learn how to configure the CLI and master core concepts:

- **[Installation & Auth](https://antigravity.google/docs/cli/install)**: Detailed instructions on installing `agy` and setting up SSH profiles.
- **[Prompting & Interaction](https://antigravity.google/docs/cli/prompting)**: Best practices for multiline inputs, pasting media files, and active interrupt controls.
- **[Reviewing Artifacts](https://antigravity.google/docs/cli/artifacts)**: Deep dive into the "Trust through Transparency" architectural pattern.

[Installation & Auth](https://antigravity.google/docs/cli/install)

[Using AGY CLI](https://antigravity.google/docs/cli/using)

On this Page

- Antigravity CLI Tutorial

- Overview

- Step-by-step

- Next steps