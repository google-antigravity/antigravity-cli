---
name: headless-vector-pdf
description: Compile Markdown documents and Graphviz DOT diagrams into publication-grade vector PDFs and high-resolution PNGs using headless Chrome or Chromium without root packages.
---

# Headless Vector PDF & Diagram Compiler

Use this skill when generating printable technical reports, manuals, or architectural diagrams in environments without LaTeX or root package installation privileges.

## 1. Markdown / HTML to Vector PDF

Wrap the rendered HTML body in print-media CSS rules and invoke headless Chrome/Chromium:

```css
@page { size: letter; margin: 18mm 16mm 20mm 16mm; }
body { font-family: Georgia, serif; line-height: 1.65; color: #111; }
pre, code { font-family: monospace; white-space: pre-wrap; word-wrap: break-word; }
```

```bash
google-chrome --headless=new --disable-gpu --no-sandbox --print-to-pdf=output.pdf document.html
```

## 2. Graphviz DOT to High-Resolution PNG Fallback

If `dot -Tpng` fails due to missing Cairo/Pango plugins in user-space, output standard SVG first and rasterize via headless Chrome:

```bash
dot -Tsvg architecture.dot -o architecture.svg
google-chrome --headless=new --disable-gpu --no-sandbox --screenshot=architecture.png --window-size=1600,1000 architecture.svg
```
