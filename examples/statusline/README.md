# CLI Statusline Example

This directory contains an example script (`statusline.sh`) that demonstrates how to create a custom, dynamic statusline for the Antigravity CLI. 

For more details on how to use and configure the statusline script, please refer to the official public documentation:
[https://antigravity.google/docs/cli-statusline](https://antigravity.google/docs/cli-statusline)

## How it works

The `statusline.sh` script reads a JSON payload from standard input, containing various state information from the CLI. It then:
1. Extracts multiple fields like `agent_state`, `vcs` info, context usage, and terminal dimensions using `jq`.
2. Computes visual indicators, such as a Unicode progress bar for context window usage.
3. Formats the data with standard ANSI 16-color codes for visual distinction.
4. Dynamically adjusts the layout to be 1 or 2 lines based on the available terminal width.

## Examples

### Default Statusline
![Default Statusline](images/statusline-default.png)

### Review Mode
![Review Mode Statusline](images/statusline-review.png)

### Tool Execution
![Tool Execution Statusline](images/statusline-tool.png)
