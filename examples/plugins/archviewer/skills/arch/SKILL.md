---
name: arch
description: Generates a D2 architectural diagram based on the current conversation and opens it.
---

# ArchViewer Generation Skill

When the `/arch` slash command is used or when this skill is invoked:
1. Analyze the current conversation and proposed system architecture.
2. Use the `write_to_file` tool to draft a declarative D2 diagram in `architecture.d2` within the current workspace or artifacts directory.
   - **Important Layout:** Strictly use `direction: down` (vertical) without any exceptions.
   - **Important Styling (Light Background + Max Contrast):** Do not use default colors. Use a modern, light-themed aesthetic with high-contrast accents. Exclusively use this precise color palette:
     - Primary accents (Nodes/Shapes): `#ED1B76` (Vivid Pink) and `#037A76` (Deep Teal)
     - Backgrounds/Containers: `#F4F4F4` (Light Grey) or `#FFFFFF` (White)
     - Strokes/Borders: Must be `#1F1F1F` (Dark Grey/Black) with `stroke-width: 3` for sharp visibility against the light background.
     - Text: MUST explicitly set `font-color: "#FFFFFF"` (Stark White) on the colored nodes, but use `#1F1F1F` (Dark Grey/Black) for text on the light backgrounds or containers.
   - Use shapes like `circle`, `hexagon`, `cylinder`, and `square` where symbolically appropriate. Do not use unsupported shapes (like `triangle` for node shapes).
3. Use the `run_command` tool to compile and open the diagram using the exact path written in step 2:
   `if command -v d2 >/dev/null 2>&1; then d2 --pad 50 "architecture.d2" "architecture.png" && { command -v open >/dev/null && open "architecture.png" || xdg-open "architecture.png"; }; else echo "D2_MISSING"; fi`
4. If the command output includes `D2_MISSING`, inform the user that the D2 compiler is required and provide the installation command: `curl -fsSL https://d2lang.com/install.sh | sh -s --` or `brew install d2`. Do NOT proceed to the next step.
5. Briefly summarize the architecture that was generated.
