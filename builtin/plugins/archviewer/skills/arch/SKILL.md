---
name: arch
description: Generates a D2 architectural diagram based on the current conversation and opens it.
---

# ArchViewer Generation Skill

When the `/arch` slash command is used or when this skill is invoked:
1. Analyze the current conversation and proposed system architecture.
2. Use the `write_to_file` tool to draft a declarative D2 diagram in a timestamped file, e.g., `architecture_$(date +%s).d2`, within a temporary or artifacts directory (or current workspace root if none exists) to prevent overwriting existing files.
   - **Important Layout:** Strictly use `direction: down` (vertical) without any exceptions.
   - **Important Styling (Light Background + Max Contrast):** Do not use default colors. Use a modern, light-themed aesthetic with high-contrast accents. Exclusively use this precise color palette:
     - Primary accents (Nodes/Shapes): `#ED1B76` (Vivid Pink) and `#037A76` (Deep Teal)
     - Backgrounds/Containers: `#F4F4F4` (Light Grey) or `#FFFFFF` (White)
     - Strokes/Borders: Must be `#1F1F1F` (Dark Grey/Black) with `stroke-width: 3` for sharp visibility against the light background.
     - Text: MUST explicitly set `font-color: "#FFFFFF"` (Stark White) on the colored nodes, but use `#1F1F1F` (Dark Grey/Black) for text on the light backgrounds or containers.
   - Use shapes like `circle`, `hexagon`, `cylinder`, and `square` where symbolically appropriate. Do not use unsupported shapes (like `triangle` for node shapes).
3. Use the `run_command` tool to compile and open the diagram:
   `FILE_PREFIX="architecture_$(date +%s)"; if command -v d2 >/dev/null 2>&1; then d2 --pad 50 "${FILE_PREFIX}.d2" "${FILE_PREFIX}.png" && { command -v open >/dev/null && open "${FILE_PREFIX}.png" || xdg-open "${FILE_PREFIX}.png"; }; else echo "D2_MISSING"; fi`
4. If the command output includes `D2_MISSING`, inform the user that the D2 compiler is required and provide the installation command: `curl -fsSL https://d2lang.com/install.sh | sh -s --` or `brew install d2`. Do NOT proceed to the next step.
5. Output the official SVG logo by printing this exact markdown (DO NOT wrap it in backticks or code blocks, it must be raw markdown to render the image). Use the relative path to the plugin's logo via the agent's app data directory (do not hardcode the user's home directory):
   `![ArchViewer Logo](file://~/.gemini/config/plugins/archviewer/logo.svg)`
   *(Note: The agent will resolve the tilde to the absolute path at runtime).*
6. Briefly summarize the architecture that was generated.
