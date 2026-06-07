# Proposal: Per-Subagent Model Selection

**Status:** Draft  
**Author:** MattBetancourt  
**Related issue:** (link after opening)

---

## Summary

Add an optional `Model` string parameter to the `invoke_subagent` and
`define_subagent` tools, allowing callers to specify which model a subagent
should run on rather than always inheriting the session-level model.

---

## Motivation

Since v1.0.5, users can choose a model at session start (`--model`) or switch
it mid-session (`/model`). Subagents, however, have no equivalent — they always
inherit whatever model the parent session is currently using.

This creates friction for several practical agent architectures:

1. **Cost-optimised orchestration.** An orchestrator reasonably runs on a
   capable model (e.g. `gemini-2.5-pro`), but research and file-scanning
   subagents only need a fast, cheap model (e.g. `gemini-2.0-flash`). There is
   currently no way to express this split without the user manually switching
   models between invocations.

2. **Capability-differentiated pipelines.** Some subtasks benefit from extended
   thinking (e.g. adversarial security review, complex planning). Spawning one
   subagent with `claude-sonnet-4-6-thinking` while keeping others on a standard
   model requires either separate sessions or awkward workarounds.

3. **Model benchmarking.** Running the same prompt against two subagents using
   different models — for comparison or quality-assurance purposes — is
   impossible today in a single session.

---

## Proposed API Changes

### `invoke_subagent`

Add an optional `Model` field (same identifiers accepted by `--model` / `/model`):

```diff
 {
   "TypeName": "string (required)",
   "Role": "string (required)",
   "Prompt": "string (required)",
-  "Workspace": "inherit | branch | share  (optional, default: inherit)"
+  "Workspace": "inherit | branch | share  (optional, default: inherit)",
+  "Model": "string (optional) — model identifier, e.g. \"gemini-2.0-flash\""
 }
```

### `define_subagent`

Add an optional `Model` field that sets the default model for all invocations of
that subagent type:

```diff
 {
   "name": "string (required)",
   "description": "string (required)",
   "system_prompt": "string (required)",
   "enable_mcp_tools": "bool (optional)",
   "enable_subagent_tools": "bool (optional)",
-  "enable_write_tools": "bool (optional)"
+  "enable_write_tools": "bool (optional)",
+  "Model": "string (optional) — default model for this subagent type"
 }
```

---

## Behaviour Spec

| Scenario | Expected result |
|---|---|
| `Model` omitted from both `define_subagent` and `invoke_subagent` | Subagent inherits the parent session's current model (no regression) |
| `Model` set only in `define_subagent` | All invocations of that type use the specified model |
| `Model` set only in `invoke_subagent` | That specific invocation uses the specified model |
| `Model` set in both | `invoke_subagent.Model` takes precedence over `define_subagent.Model` |
| Invalid/unavailable `Model` value | Fail-fast with a clear error before the subagent starts |
| Parent session model changes mid-conversation | Subagents without an explicit `Model` inherit the updated session model |
| `self`-type subagent with `Model` set | Spawns with the specified model, not the parent's |

**Override chain (lowest → highest precedence):**

```
session default  →  define_subagent.Model  →  invoke_subagent.Model
```

---

## Example Usage

```jsonc
// Orchestrator (running on Gemini 3.1 Pro) spawns two concurrent subagents:
// one fast and cheap, one with extended thinking for security analysis.
{
  "Subagents": [
    {
      "TypeName": "research",
      "Role": "Quick File Scanner",
      "Prompt": "List all Python files that import the requests library",
      "Workspace": "inherit",
      "Model": "Gemini 3.5 Flash (Low)"
    },
    {
      "TypeName": "self",
      "Role": "Security Reviewer",
      "Prompt": "Perform an adversarial OWASP-style security review of the auth module",
      "Workspace": "branch",
      "Model": "Claude Sonnet 4.6 (Thinking)"
    }
  ]
}
```

---

## Statusline

No changes are needed to the statusline schema. The existing
`.model.display_name` field in the statusline payload is already populated
per-conversation. Subagent conversations will naturally reflect their own model
in that field when the feature is implemented.

---

## Backwards Compatibility

`Model` is entirely optional. All existing `invoke_subagent` and
`define_subagent` calls without it continue to behave exactly as today. There
are no breaking changes.

---

## Out of Scope (follow-up candidates)

- **Capability validation**: checking that the chosen model supports tool-calling
  before assigning it to a subagent with `enable_write_tools: true`.
- **TUI surface**: a picker UI for subagent model selection inside the
  interactive session.
- **Cost estimation**: pre-launch cost hints when a non-default model is
  requested.
