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
>- AI Credits

# Managing AI Credits & Quotas [link](https://antigravity.google/\#managing-ai-credits-quotas)

The Antigravity CLI integrates with your subscription to monitor and manage your AI Premium credits and usage quotas.

For a detailed explanation of baseline quotas, how credits are consumed, and plan eligibility, please refer to the main **[Plans](https://antigravity.google/docs/plans)** page.

## Quota Tracking [link](https://antigravity.google/\#quota-tracking)

You can monitor your active quota and credit consumption directly inside the CLI:

- **Statusline Indicator**: The right side of the CLI statusline displays your remaining credit count (e.g., `AI Credits: 42`).
- **Low Quota Alert**: When your remaining AI credits drop below the warning threshold, the statusline indicator highlights to warn you that your limits are near.

## Slash Commands & Managing Balance [link](https://antigravity.google/\#slash-commands-managing-balance)

You can query your credits or buy additional quota directly from the CLI:

- **Query Balance**: Run the **[AI Credits Command](https://antigravity.google/docs/cli/commands/credits)** to open the dedicated credits panel. This panel displays your detailed credit usage statistics.
- **Managing Credits**: You can easily purchase AI credits or upgrade your subscription, which opens a panel containing direct pricing and subscription portal links.

## Settings Configuration [link](https://antigravity.google/\#settings-configuration)

To control when and how your AI credits are used, you can toggle credit settings in your `settings.json` file:

json

content\_copy

```
            {
  "useG1Credits": true
}

```

- **Use AI Credits Option**: Run `/config` or `/settings` to open the CLI settings panel. Set the **Use G1 Credits** field to **on** to allow the CLI to use your personal credits when plan quotas are exhausted, or set it to **off** to restrict fallback billing. (To learn more, see the **[Plans](https://antigravity.google/docs/plans#overages)** overages section).

## See also [link](https://antigravity.google/\#see-also)

- **[AI Credits Command](https://antigravity.google/docs/cli/commands/credits)**: View and manage your credits interactively in the TUI.
- **[Model Quotas Command](https://antigravity.google/docs/cli/commands/usage)**: Monitor your model-specific API quotas.

[Settings, Rendering & Keybindings](https://antigravity.google/docs/cli/settings)

[MCP](https://antigravity.google/docs/mcp)

On this Page

- Managing AI Credits & Quotas

- Quota Tracking

- Slash Commands & Managing Balance

- Settings Configuration

- See also