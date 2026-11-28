# Auto-continue after quota reset

This directory contains a `Stop` hook (`auto-continue.sh`) that keeps a session going when it runs out of quota. Instead of stopping on

```
⚠ Individual quota reached. Please upgrade your subscription to increase your limits. Resets in 2h11m50s.
```

the session waits until the quota window resets and then continues the task where it left off. No retyping, no `/resume`.

Related: [#1900](https://github.com/google-antigravity/antigravity-cli/issues/1900), [#966](https://github.com/google-antigravity/antigravity-cli/issues/966), [#1024](https://github.com/google-antigravity/antigravity-cli/issues/1024).

For more details on hooks, see the official documentation: [https://antigravity.google/docs/hooks](https://antigravity.google/docs/hooks)

## How it works

1. A turn that hits the quota ends with a `Stop` hook call whose input has `"terminationReason": "ERROR"` and an `error` containing `Individual quota reached ... Resets in 2h11m50s`.
2. The script parses the reset duration and waits until 30 seconds past it. It checks the wall clock every 15 seconds, so a laptop that sleeps through the reset still resumes on time.
3. It returns `{"decision": "continue", "reason": "..."}`. The agent resumes the same conversation, with the reason injected as a system message.
4. If the quota is still exhausted, the next `Stop` call carries a fresh reset time and the script waits again.

Every other stop (a normal finish, any other error, a reset further away than the maximum wait) is let through immediately with `{"decision": "stop"}`.

## Setup

Requires `bash` and `jq`.

1. Save `auto-continue.sh` somewhere permanent and make it executable:

   ```bash
   cp auto-continue.sh ~/.gemini/config/auto-continue.sh
   chmod +x ~/.gemini/config/auto-continue.sh
   ```

2. Register it in `~/.gemini/config/hooks.json` (all sessions) or `<workspace>/.agents/hooks.json` (one project):

   ```json
   {
     "auto-continue": {
       "Stop": [
         {
           "type": "command",
           "command": "~/.gemini/config/auto-continue.sh",
           "timeout": 18300
         }
       ]
     }
   }
   ```

   `timeout` is in seconds and must be longer than the wait. The default of 30 seconds would kill the hook before the quota resets.

3. Restart `agy` and check that `/hooks` lists `auto-continue`.

## Configuration

| Variable | Default | Meaning |
| :--- | :--- | :--- |
| `AGY_AUTO_CONTINUE_MAX_WAIT` | `18000` (5 hours) | Longest reset, in seconds, the hook waits for. A longer one, such as the weekly quota, stops the turn as usual. |

Set it in the environment `agy` starts from, or inline in the hook command:

```json
"command": "AGY_AUTO_CONTINUE_MAX_WAIT=3600 ~/.gemini/config/auto-continue.sh"
```

Keep `timeout` at least 60 seconds above `AGY_AUTO_CONTINUE_MAX_WAIT`.

## What you see while it waits

- **TUI**: the turn stays on `Working...` until the reset. `Esc` cancels the wait and ends the turn.
- **Headless (`agy -p`)**: the run blocks until the reset and then finishes the task. A `--print-timeout` shorter than the wait cuts it off.
