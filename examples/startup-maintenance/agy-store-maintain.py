#!/usr/bin/env python3
"""
Antigravity CLI Trajectory Store & Rule Frontmatter Maintenance Utility.
1. Separates internal subagent trajectories (trajectory_type = 22) from user
   conversations (trajectory_type = 4) to prevent startup summary reconciliation stalls.
2. Ensures custom rules (~/.agents/rules/*.md) and skills (~/.agents/skills/*/SKILL.md)
   contain valid YAML frontmatter.
"""

import argparse
import glob
import os
import shutil
import sqlite3


def maintain_trajectory_store(dry_run: bool = False) -> int:
    conv_dir = os.path.expanduser("~/.gemini/antigravity-cli/conversations")
    archive_dir = os.path.expanduser("~/.gemini/antigravity-cli/subagent_trajectories_archive")
    if not os.path.isdir(conv_dir):
        print(f"Conversations directory not found: {conv_dir}")
        return 0

    if not dry_run:
        os.makedirs(archive_dir, exist_ok=True)
        os.makedirs(os.path.expanduser("~/.gemini/antigravity/conversations"), exist_ok=True)

    moved = 0
    for db_path in sorted(glob.glob(os.path.join(conv_dir, "*.db"))):
        try:
            conn = sqlite3.connect(db_path)
            row = conn.execute("SELECT trajectory_type FROM trajectory_meta").fetchone()
            conn.close()
            if row and row[0] == 22:
                base = os.path.basename(db_path)[:-3]
                if not dry_run:
                    for ext in (".db", ".db-wal", ".db-shm"):
                        src = os.path.join(conv_dir, base + ext)
                        if os.path.exists(src):
                            shutil.move(src, os.path.join(archive_dir, base + ext))
                moved += 1
        except Exception as exc:
            print(f"Skipping {os.path.basename(db_path)}: {exc}")

    action = "Would archive" if dry_run else "Archived"
    print(f"{action} {moved} subagent trajectory_type=22 database(s) -> {archive_dir}")
    return moved


def audit_rule_frontmatter(fix: bool = False) -> int:
    rules_dir = os.path.expanduser("~/.agents/rules")
    if not os.path.isdir(rules_dir):
        return 0

    fixed = 0
    for rule_path in sorted(glob.glob(os.path.join(rules_dir, "*.md"))):
        with open(rule_path, "r", encoding="utf-8") as f:
            content = f.read()
        if not content.startswith("---\n"):
            fixed += 1
            if fix:
                lines = [l.strip("# ").strip() for l in content.splitlines() if l.strip()]
                desc = (lines[0] if lines else os.path.basename(rule_path)).replace('"', "'")
                header = f'---\ntrigger: always_on\ndescription: "{desc}"\n---\n\n'
                with open(rule_path, "w", encoding="utf-8") as f:
                    f.write(header + content)
                print(f"Added YAML frontmatter to: {os.path.basename(rule_path)}")
            else:
                print(f"Missing YAML frontmatter: {os.path.basename(rule_path)}")
    return fixed


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Maintain Antigravity CLI trajectory store and rules.")
    parser.add_argument("--dry-run", action="store_true", help="Report actions without moving files.")
    parser.add_argument("--fix-rules", action="store_true", help="Add missing trigger frontmatter to ~/.agents/rules/*.md.")
    args = parser.parse_args()

    maintain_trajectory_store(dry_run=args.dry_run)
    audit_rule_frontmatter(fix=args.fix_rules and not args.dry_run)
