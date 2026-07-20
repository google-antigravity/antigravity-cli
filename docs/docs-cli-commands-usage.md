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
>- Commands
>- Model Quotas (/usage, /quota)

# Model Quotas (/usage) [link](https://antigravity.google/\#model-quotas-usage)

View your active model quota usage and refresh your configuration.

## Overview [link](https://antigravity.google/\#overview)

Antigravity CLI provides the `/usage` command (alias `/quota`) to help you monitor your resource consumption. When run, the command refreshes your model configuration and quota status from the backend and opens an interactive TUI panel.

## Viewing your usage [link](https://antigravity.google/\#viewing-your-usage)

To open the Model Quotas panel:

1. Type `/usage` (or `/quota`) in the prompt box.
2. Press `Enter`.

text

content\_copy

```
            /usage

```

![Quota & Credits TUI](https://antigravity.google/assets/image/docs/cli/usage-tui.png)

### Interactive Panel Features [link](https://antigravity.google/\#interactive-panel-features)

The panel displays:

- **Model Quotas**: A breakdown of your usage limits and remaining requests/tokens for each supported model (e.g., Gemini 3.5 Flash, Gemini 3.1 Pro).
- **Active Refresh**: The CLI automatically triggers a fresh check of your quotas on disk and from the backend service when you open this panel.

### Navigation Controls [link](https://antigravity.google/\#navigation-controls)

Use the following keyboard shortcuts to navigate the panel:

| Key | Action |
| --- | --- |
| `↑` / `↓` (or `j` / `k`) | Scroll up or down by one line. |
| `PgUp` / `PgDn` | Scroll up or down by one page. |
| `g` / `G` | Jump to the top or bottom of the list. |
| `Esc` (or `q`) | Close the panel and return to the prompt. |

## Next steps [link](https://antigravity.google/\#next-steps)

- **[CLI Reference](https://antigravity.google/docs/cli/reference)**: See all available slash commands and keybindings.
- **[Settings & Rendering](https://antigravity.google/docs/cli/settings)**: Configure your default models and credit usage preferences.

[Window Title Command (/title)](https://antigravity.google/docs/cli/commands/title)

[Best Practices](https://antigravity.google/docs/cli/best-practices)

On this Page

- Model Quotas (/usage)

- Overview

- Viewing your usage

- Next steps