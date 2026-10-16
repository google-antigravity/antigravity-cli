#!/usr/bin/env python3
import os
import argparse
from pathlib import Path
import re

def slugify(value):
    """Convert string to lowercase, replace spaces with hyphens, and remove non-alphanumeric chars."""
    value = re.sub(r'[^\w\s-]', '', value).strip().lower()
    return re.sub(r'[-\s]+', '-', value)

def generate_skill(name, description, output_dir):
    skill_slug = slugify(name)
    skill_dir = Path(output_dir) / "skills" / skill_slug

    if skill_dir.exists():
        print(f"Error: Skill directory '{skill_dir}' already exists.")
        return False

    print(f"Generating skill '{skill_slug}' at {skill_dir}...")

    # Create directories
    directories = [
        "",
        "scripts",
        "examples",
        "resources",
        "references"
    ]
    
    for d in directories:
        dir_path = skill_dir / d
        dir_path.mkdir(parents=True, exist_ok=True)
        # Add a .keep file to empty directories
        if d:
            (dir_path / ".keep").touch()

    # Create SKILL.md template
    skill_md_content = f"""---
name: {skill_slug}
description: >-
  {description}
---

# {name}

Provide clear, step-by-step instructions for the agent here.

## Overview
Briefly explain what this skill does and when the agent should use it.

## Steps

1.  **First Step**: Describe the first action.
    - If there are helper scripts, link them: [script.sh](./scripts/script.sh)
2.  **Second Step**: Describe the next action.
3.  **Verification**: Describe how to verify the task was successful.

## Resources
* [References](./references/) - Place detailed manuals here.
* [Examples](./examples/) - Place reference implementations here.
"""
    
    with open(skill_dir / "SKILL.md", "w") as f:
        f.write(skill_md_content)

    print(f"✅ Successfully generated Antigravity Skill '{skill_slug}'")
    print(f"Location: {skill_dir}")
    print("Next steps:")
    print(f"1. Edit {skill_dir / 'SKILL.md'} to define the agent's instructions.")
    print(f"2. Add any helper scripts to {skill_dir / 'scripts/'}.")
    print(f"3. Add reference materials to {skill_dir / 'references/'}.")
    return True

def main():
    parser = argparse.ArgumentParser(description="Antigravity Skill Generator - Scaffolds a new AI agent skill.")
    parser.add_argument("name", nargs="?", help="The name of the skill (e.g., 'Deploy to GCP Cloud Run')")
    parser.add_argument("-d", "--description", help="Description of when the agent should use this skill")
    parser.add_argument("-o", "--output", default=".agents", help="Output directory root (default: .agents)")
    parser.add_argument("-i", "--interactive", action="store_true", help="Run in interactive mode")

    args = parser.parse_args()

    # Interactive prompt if needed
    if args.interactive or not args.name or not args.description:
        print("🤖 Antigravity Skill Generator (Interactive Mode)")
        name = args.name or input("Skill Name (e.g., 'Database Backup'): ").strip()
        while not name:
            print("Skill Name is required.")
            name = input("Skill Name: ").strip()

        description = args.description or input("Description (When should the agent use this?): ").strip()
        while not description:
            print("Description is required.")
            description = input("Description: ").strip()
            
        output_dir = args.output
    else:
        name = args.name
        description = args.description
        output_dir = args.output

    generate_skill(name, description, output_dir)

if __name__ == "__main__":
    main()
