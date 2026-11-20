# /// script
# requires-python = ">=3.10"
# dependencies = [
#     "textual",
#     "google-genai",
# ]
# ///
import os
import re
from pathlib import Path
from textual.app import App, ComposeResult
from textual.containers import Container, Horizontal, Vertical
from textual.widgets import Header, Footer, Input, Button, Label, Static, TextArea, Select

def slugify(value):
    """Convert string to lowercase, replace spaces with hyphens, and remove non-alphanumeric chars."""
    value = re.sub(r'[^\w\s-]', '', value).strip().lower()
    return re.sub(r'[-\s]+', '-', value)

def parse_env_file(path: Path) -> dict:
    """Parse key=value pairs from a .env file."""
    if not path.is_file():
        return {}
    env_vars = {}
    try:
        with open(path, "r", encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith("#"):
                    continue
                if "=" in line:
                    k, v = line.split("=", 1)
                    k = k.strip()
                    v = v.strip().strip("'\"")
                    if k and v:
                        env_vars[k] = v
    except Exception:
        pass
    return env_vars

def discover_gemini_key():
    """
    Auto-discovers Gemini / Google API key without prompting the user.
    Order of discovery:
    1. os.environ ('GEMINI_API_KEY' or 'GOOGLE_API_KEY')
    2. Local .env / .env.local in current directory or git root
    3. User global configs (~/.gemini/env, ~/.config/gemini/env, ~/.env)
    Returns: (api_key, source_description) or (None, None)
    """
    for var in ("GEMINI_API_KEY", "GOOGLE_API_KEY"):
        val = os.environ.get(var)
        if val and val.strip():
            return val.strip(), f"environment (${var})"

    cwd = Path.cwd()
    search_dirs = [cwd]
    curr = cwd
    for _ in range(3):
        curr = curr.parent
        if curr == curr.parent:
            break
        search_dirs.append(curr)

    for d in search_dirs:
        for fname in (".env.local", ".env"):
            env_file = d / fname
            if env_file.is_file():
                parsed = parse_env_file(env_file)
                for var in ("GEMINI_API_KEY", "GOOGLE_API_KEY"):
                    if var in parsed:
                        rel = env_file.relative_to(cwd) if env_file.is_relative_to(cwd) else env_file.name
                        return parsed[var], str(rel)

    home = Path.home()
    for global_file in (home / ".gemini" / "env", home / ".config" / "gemini" / "env", home / ".env"):
        if global_file.is_file():
            parsed = parse_env_file(global_file)
            for var in ("GEMINI_API_KEY", "GOOGLE_API_KEY"):
                if var in parsed:
                    return parsed[var], f"~/{global_file.relative_to(home)}"

    return None, None

def detect_template_type(prompt: str, selected_type: str) -> str:
    if selected_type and selected_type != "auto":
        return selected_type
    p = prompt.lower()
    if any(k in p for k in ("api", "endpoint", "http", "rest", "fetch", "json", "token", "curl", "webhook")):
        return "api"
    if any(k in p for k in ("cli", "bash", "command", "flag", "binary", "docker", "git", "terminal", "tool")):
        return "cli"
    if any(k in p for k in ("refactor", "audit", "lint", "test", "review", "check", "clean", "fix", "coverage")):
        return "audit"
    return "workflow"


class SkillGeneratorTUI(App):
    """Textual App to generate Antigravity Skills."""
    
    CSS = """
    Screen {
        align: center middle;
    }
    #main_card {
        width: 74;
        height: auto;
        border: round $primary;
        background: $surface;
        padding: 1 2;
    }
    #title_header {
        width: 100%;
        text-align: center;
        text-style: bold;
        color: $accent;
        margin-bottom: 1;
    }
    #status_notice {
        margin-bottom: 1;
        padding: 0 1;
        background: $panel;
    }
    Label {
        color: $text;
        text-style: bold;
        margin-top: 1;
    }
    Select {
        margin-bottom: 0;
    }
    Input {
        margin-bottom: 0;
    }
    #button_row {
        height: auto;
        margin-top: 1;
    }
    #submit_btn {
        width: 72%;
        margin-right: 1;
    }
    #quit_btn {
        width: 26%;
    }
    #result_log {
        margin-top: 1;
        padding: 1;
        background: $panel;
        display: none;
    }
    #result_log.visible {
        display: block;
    }
    """

    BINDINGS = [
        ("enter", "submit", "Generate"),
        ("escape", "quit", "Quit / Exit"),
        ("ctrl+c", "quit", "Quit"),
        ("ctrl+q", "quit", "Quit"),
        ("q", "quit", "Quit"),
        ("d", "toggle_dark", "Toggle dark mode"),
    ]

    def __init__(self):
        super().__init__()
        self.api_key, self.key_source = discover_gemini_key()

    def on_mount(self) -> None:
        """Autofocus the skill name input on launch."""
        self.query_one("#skill_name", Input).focus()

    async def action_submit(self) -> None:
        """Global Enter key action to trigger generation."""
        await self.trigger_generation()

    def compose(self) -> ComposeResult:
        yield Header(show_clock=True)
        with Vertical(id="main_card"):
            yield Static("✨ Antigravity Skill Generator", id="title_header")
            if self.api_key:
                notice_text = f"[green]●[/green] AI generation ready [dim]({self.key_source})[/dim]"
                btn_label = "Generate Skill"
                btn_variant = "success"
            else:
                notice_text = "[bold red]●[/bold red] GEMINI_API_KEY required [dim](add to .env)[/dim]"
                btn_label = "API Key Required"
                btn_variant = "default"

            yield Static(notice_text, id="status_notice")

            yield Label("Skill Type:")
            yield Select(
                options=[
                    ("Auto (Detect from goal)", "auto"),
                    ("CLI / Command Runner", "cli"),
                    ("API / Web Service", "api"),
                    ("Workflow / Multi-Step", "workflow"),
                    ("Code Quality / Audit", "audit"),
                ],
                value="auto",
                id="template_type"
            )

            yield Label("Skill Name / Goal:")
            yield Input(placeholder="e.g. deploy-to-gcp, backup-db, sync-issues", id="skill_name")
            
            yield Label("Output Directory:")
            yield Input(value="skills", id="output_dir")
            
            with Horizontal(id="button_row"):
                yield Button(btn_label, variant=btn_variant, id="submit_btn")
                yield Button("Quit", variant="error", id="quit_btn")
            yield Static("", id="result_log")
        yield Footer()

    async def on_input_submitted(self, event: Input.Submitted) -> None:
        """Allow pressing Enter inside input fields to generate."""
        await self.trigger_generation()

    async def on_button_pressed(self, event: Button.Pressed) -> None:
        if event.button.id == "quit_btn":
            self.exit()
            return

        if event.button.id == "submit_btn":
            await self.trigger_generation()

    async def trigger_generation(self) -> None:
        name_input = self.query_one("#skill_name", Input)
        out_dir_input = self.query_one("#output_dir", Input)
        type_select = self.query_one("#template_type", Select)
        log = self.query_one("#result_log", Static)
        
        name = name_input.value.strip() or "my-agent-skill"
        out_dir = out_dir_input.value.strip() or "skills"
        template_type = type_select.value
        
        if not self.api_key:
            log.add_class("visible")
            log.update("[bold red]❌ Cannot generate: GEMINI_API_KEY is missing.[/bold red]\n[dim]Please add GEMINI_API_KEY to your .env file or environment.[/dim]")
            self.notify(
                "Please add GEMINI_API_KEY to your .env file to generate skills.",
                title="API Key Required",
                severity="error",
                timeout=6.0
            )
            return

        log.add_class("visible")
        log.update("[yellow]⏳ Designing skill with Gemini AI...[/yellow]")

        import asyncio
        success, path_or_msg = await asyncio.to_thread(self.generate_ai_skill, self.api_key, name, out_dir, template_type)

        if success:
            log.add_class("visible")
            log.update(
                f"[bold green]✔ Skill Created Successfully[/bold green]\n"
                f"[bold white]Location:[/] [cyan underline]{path_or_msg}[/]\n"
                f"[bold white]Manifest:[/] [dim]{path_or_msg}/SKILL.md[/dim]"
            )
            self.notify(
                f"{path_or_msg}",
                title="Skill Generated",
                severity="information",
                timeout=6.0
            )
            name_input.value = ""
        else:
            log.add_class("visible")
            log.update(f"[bold red]❌ {path_or_msg}[/bold red]")
            self.notify(
                path_or_msg,
                title="Generation Failed",
                severity="error",
                timeout=6.0
            )

    def generate_ai_skill(self, api_key: str, prompt: str, output_dir: str, template_type: str):
        try:
            from google import genai
            client = genai.Client(api_key=api_key)
            system_prompt = f"""You are a world-class AI agent architect creating an Antigravity Agent Skill.
User's Skill Request: {prompt}
Chosen Category / Pattern: {template_type}

Generate the complete, production-grade Markdown content for `SKILL.md`.
The skill MUST be exhaustive, realistic, and highly practical.

Requirements:
1. YAML frontmatter:
   ---
   name: <concise-slug>
   description: >-
     <clear explanation of what the skill does, when to use it, and trigger conditions>
   ---
2. Title: `# <Clear Title>`
3. `## Overview`: Purpose, capabilities, and trigger conditions.
4. `## Prerequisites & Tools`: Environment variables, CLI binaries, permissions, or dependencies required.
5. `## Step-by-Step Instructions`: Detailed phases (e.g., Phase 1: Context & Validation, Phase 2: Core Execution, Phase 3: Verification & Edge Cases). Include concrete commands, structured issue formats, code snippets, or checklists tailored directly to "{prompt}".
6. `## Error Handling & Recovery`: Specific failure scenarios and how the agent recovers.
7. `## Resources`: Relative links to `./scripts/`, `./references/`, and `./examples/`.

Output ONLY the raw markdown content. Do not wrap the entire output in markdown code fences unless wrapping individual code snippets inside the document.
"""
            response = client.models.generate_content(
                model="gemini-2.5-flash",
                contents=system_prompt
            )
            content = response.text
            if content.startswith("```markdown"):
                content = content[11:]
                if content.endswith("```"):
                    content = content[:-3]
            elif content.startswith("```"):
                content = content[3:]
                if content.endswith("```"):
                    content = content[:-3]
            content = content.strip()
        except Exception as e:
            return False, f"AI Generation Failed: {str(e)}"
            
        slug_match = re.search(r'^name:\s*([a-zA-Z0-9_-]+)', content, re.MULTILINE)
        if slug_match:
            skill_slug = slug_match.group(1).strip()
        else:
            skill_slug = slugify(prompt[:15])
            
        skill_dir = Path(output_dir) / skill_slug

        if skill_dir.exists():
            return False, f"Directory '{skill_dir.resolve()}' already exists."

        # Create directories
        directories = ["", "scripts", "examples", "resources", "references"]
        for d in directories:
            dir_path = skill_dir / d
            dir_path.mkdir(parents=True, exist_ok=True)
            if d:
                (dir_path / ".keep").touch()
        
        with open(skill_dir / "SKILL.md", "w") as f:
            f.write(content)

        return True, str(skill_dir.resolve())


if __name__ == "__main__":
    app = SkillGeneratorTUI()
    app.run()




