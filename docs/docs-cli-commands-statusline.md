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
>- Status Line (/statusline)

# Status Line Command (/statusline) [link](https://antigravity.google/\#status-line-command-statusline)

Toggle the TUI status line or configure a custom rendering command.

## Overview [link](https://antigravity.google/\#overview)

The `/statusline` command allows you to quickly enable or disable the status line at the bottom of your TUI, or configure a custom shell command to render it dynamically, without manually editing your settings file.

For details on how to write custom status line scripts and the JSON state payload schema, see the conceptual **[Status Line Customization Guide](https://antigravity.google/docs/cli/statusline)**.

## Usage [link](https://antigravity.google/\#usage)

Run the `/statusline` command with the following arguments to control its behavior:

### Toggle Status Line [link](https://antigravity.google/\#toggle-status-line)

Type `/statusline` with no arguments to toggle the status line on and off:

text

content\_copy

```
            /statusline

```

### Enable or Disable Explicitly [link](https://antigravity.google/\#enable-or-disable-explicitly)

You can explicitly enable or disable the status line:

- **Enable**: `/statusline on` or `/statusline enable`
- **Disable**: `/statusline off` or `/statusline disable`

bash

content\_copy

```
            /statusline off

```

### Configure a Custom Command [link](https://antigravity.google/\#configure-a-custom-command)

To route the agent state JSON payload to a custom script and render its output in the status line, pass the command as an argument:

bash

content\_copy

```
            /statusline ~/.gemini/antigravity-cli/statusline.sh

```

This immediately updates your settings and starts running the script to render the status line.

### Revert to Default [link](https://antigravity.google/\#revert-to-default)

To delete your custom command configuration and revert to the built-in default status line:

bash

content\_copy

```
            /statusline delete

```

_(Note: `/statusline reset` is also supported)._

### Show Help [link](https://antigravity.google/\#show-help)

To view the quick command reference:

bash

content\_copy

```
            /statusline help

```

## Next steps [link](https://antigravity.google/\#next-steps)

- **[Status Line Guide](https://antigravity.google/docs/cli/statusline)**: Learn how to write custom scripts and handle the JSON payload.
- **[Window Title Command](https://antigravity.google/docs/cli/commands/title)**: Configure dynamic terminal window titles.
- **[CLI Reference](https://antigravity.google/docs/cli/reference)**: See all available slash commands.

[Resume Command (/resume)](https://antigravity.google/docs/cli/commands/resume)

[Window Title Command (/title)](https://antigravity.google/docs/cli/commands/title)

On this Page

- Status Line Command (/statusline)

- Overview

- Usage

- Next steps