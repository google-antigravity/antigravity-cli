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
- Antigravity SDK
>- Overview + Quick Start

# Google Antigravity SDK [link](https://antigravity.google/\#google-antigravity-sdk)

The Antigravity SDK is a programmatic Python framework designed to build, test, and run autonomous AI agents. It extends the same core agent harness that powers the Antigravity CLI and Antigravity 2.0, allowing you to integrate advanced agentic capabilities directly into your own applications and workflows.

The SDK decouples your agent's logic from where it runs, allowing you to focus on what the agent does; the SDK handles how and where it executes.

## Quick Start [link](https://antigravity.google/\#quick-start)

Install the SDK using pip:

bash

content\_copy

```
            pip install google-antigravity

```

### Hello World Example [link](https://antigravity.google/\#hello-world-example)

A functional agent that can interact with your local environment in under 15 lines of Python:

python

content\_copy

```
            import asyncio
from google.antigravity import Agent, LocalAgentConfig

async def main():
    config = LocalAgentConfig()
    async with Agent(config) as agent:
        response = await agent.chat("What files are in the current directory?")
        print(await response.text())

if __name__ == "__main__":
    asyncio.run(main())

```

## Core Pillars [link](https://antigravity.google/\#core-pillars)

**1\. Governed Extensibility (Tools)** Every agent starts with a built-in toolset (file I/O, code editing, shell execution, directory search) and can be extended using four types of tools under a unified execution pipeline:

- **Built-in Tools:** Core file and system manipulation capabilities.
- **Custom Python Functions:** Register any Python callable as an agent tool.
- **MCP Servers:** Connect any Model Context Protocol (MCP) server (stdio, SSE, or HTTP). See the [MCP Documentation](https://antigravity.google/docs/mcp).
- **Agent Skills:** Load reusable packages of instructions and tools.

**2\. Declarative Safety Policies** Configure agent permissions using a declarative "deny by default" policy system to control when and how tools are executed:

python

content\_copy

```
            from google.antigravity.hooks.policy import deny, allow, ask_user

policies = [\
    deny("*"),                                         # Block all tools by default\
    allow("view_file"),                                # Allow reading files silently\
    ask_user("run_command", handler=my_handler),       # Require human approval for shell execution\
]

```

**3\. Lifecycle Hooks** Gain granular control over agent execution with three categories of hooks across nine concrete lifecycle points (e.g., session start, pre/post turn, pre/post tool call):

- **Inspect** (Read-Only, Non-Blocking): For logging, audit trails, and metrics.
- **Decide** (Read-Only, Blocking): For custom approval/denial logic (policies).
- **Transform** (Modifying, Blocking): For sanitizing data in transit or recovering from tool errors.

\-\-\-

### Key Capabilities [link](https://antigravity.google/\#key-capabilities)

- **Streaming:** Access live model reasoning and output chunks as they are generated.
- **Multimodal Input:** Pass images, PDFs, audio, and video natively using `from_file()`.
- **Sub-agents:** Spawn child agents with independent tools and contexts to build multi-agent teams.
- **Structured Output:** Define schemas using Pydantic models to return validated, typed data directly.
- **Human-in-the-Loop:** Pause execution to ask structured questions and branch based on user input.
- **Observability:** Track per-turn and cumulative token usage and access thinking traces.

To use the SDK more easily within Antigravity 2.0, use the Antigravity SDK Skill. To learn more about the Antigravity SDK and see more examples of how to use it, visit [**the GitHub repository**](https://github.com/google-antigravity/antigravity-sdk-python)

[CLI Reference](https://antigravity.google/docs/cli/reference)

[MCP](https://antigravity.google/docs/mcp)

On this Page

- Google Antigravity SDK

- Quick Start

- Core Pillars