#!/bin/bash
# setup.sh - Installs and enables the custom statusline for Antigravity CLI

set -euo pipefail

# 1. Determine the settings directory
OS="$(uname -s)"
case "${OS}" in
  Darwin*)
    CONFIG_DIR="$HOME/Library/Application Support/antigravity-cli"
    ;;
  Linux*)
    CONFIG_DIR="$HOME/.gemini/antigravity-cli"
    ;;
  CYGWIN*|MINGW*|MSYS*)
    # Windows environments (Git Bash, MSYS)
    if [ -n "${APPDATA:-}" ]; then
      CONFIG_DIR="${APPDATA}/antigravity-cli"
    else
      CONFIG_DIR="$HOME/AppData/Roaming/antigravity-cli"
    fi
    ;;
  *)
    # Default fallback to Linux path
    CONFIG_DIR="$HOME/.gemini/antigravity-cli"
    ;;
esac

# Convert config dir to absolute path if needed
mkdir -p "$CONFIG_DIR"
CONFIG_DIR="$(cd "$CONFIG_DIR" && pwd)"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_SCRIPT="$SCRIPT_DIR/statusline.sh"
TARGET_SCRIPT="$CONFIG_DIR/statusline.sh"

echo "Installing statusline script to: $TARGET_SCRIPT"
cp "$SOURCE_SCRIPT" "$TARGET_SCRIPT"
chmod +x "$TARGET_SCRIPT"

SETTINGS_FILE="$CONFIG_DIR/settings.json"
echo "Configuring settings file at: $SETTINGS_FILE"

# Make sure settings.json exists
if [ ! -f "$SETTINGS_FILE" ]; then
  echo "{}" > "$SETTINGS_FILE"
fi

# Update settings.json using python if available, otherwise fallback to jq
if command -v python3 >/dev/null 2>&1; then
  python3 -c '
import json, sys
file_path, script_path = sys.argv[1], sys.argv[2]
try:
    with open(file_path, "r") as f:
        data = json.load(f)
except Exception:
    data = {}
if "statusLine" not in data or not isinstance(data["statusLine"], dict):
    data["statusLine"] = {}
data["statusLine"]["command"] = script_path
data["statusLine"]["enabled"] = True
with open(file_path, "w") as f:
    json.dump(data, f, indent=2)
' "$SETTINGS_FILE" "$TARGET_SCRIPT"
elif command -v python >/dev/null 2>&1; then
  python -c '
import json, sys
file_path, script_path = sys.argv[1], sys.argv[2]
try:
    with open(file_path, "r") as f:
        data = json.load(f)
except Exception:
    data = {}
if "statusLine" not in data or not isinstance(data["statusLine"], dict):
    data["statusLine"] = {}
data["statusLine"]["command"] = script_path
data["statusLine"]["enabled"] = True
with open(file_path, "w") as f:
    json.dump(data, f, indent=2)
' "$SETTINGS_FILE" "$TARGET_SCRIPT"
elif command -v jq >/dev/null 2>&1; then
  TEMP_FILE=$(mktemp)
  jq --arg cmd "$TARGET_SCRIPT" '.statusLine = ((.statusLine // {}) + {command: $cmd, enabled: true})' "$SETTINGS_FILE" > "$TEMP_FILE"
  mv "$TEMP_FILE" "$SETTINGS_FILE"
else
  echo "Error: Neither python3, python, nor jq is installed. Please manually add the following to your $SETTINGS_FILE:"
  echo "{"
  echo "  \"statusLine\": {"
  echo "    \"command\": \"$TARGET_SCRIPT\","
  echo "    \"enabled\": true"
  echo "  }"
  echo "}"
  exit 1
fi

echo "Status line successfully installed and enabled!"
echo "Please restart Antigravity CLI (agy) to see the changes."
