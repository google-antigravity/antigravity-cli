#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "$HOME/.local/bin" "$HOME/.gemini/antigravity-cli/bin"

install -m 0755 "$SCRIPT_DIR/pw-record" "$HOME/.local/bin/pw-record"
install -m 0755 "$SCRIPT_DIR/pw-record" "$HOME/.gemini/antigravity-cli/bin/pw-record"
install -m 0755 "$SCRIPT_DIR/ai-say" "$HOME/.local/bin/ai-say"

echo "Installed PipeWire /voice shim and ai-say wrapper to ~/.local/bin"

if [ "${1:-}" = "--with-models" ]; then
  VOICE_DIR="${AGY_VOICE_DIR:-$HOME/.local/share/antigravity-voice}"
  mkdir -p "$VOICE_DIR/models"
  echo "Bootstrapping isolated Python venv in $VOICE_DIR/venv..."
  python3 -m venv "$VOICE_DIR/venv"
  "$VOICE_DIR/venv/bin/pip" install --upgrade pip
  "$VOICE_DIR/venv/bin/pip" install -r "$SCRIPT_DIR/requirements.txt"

  PIPER_URL_BASE="https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_GB/alan/medium"
  if [ ! -f "$VOICE_DIR/models/en_GB-alan-medium.onnx" ]; then
    echo "Downloading Piper TTS voice model (en_GB-alan-medium.onnx)..."
    curl -fL "$PIPER_URL_BASE/en_GB-alan-medium.onnx" -o "$VOICE_DIR/models/en_GB-alan-medium.onnx"
    curl -fL "$PIPER_URL_BASE/en_GB-alan-medium.onnx.json" -o "$VOICE_DIR/models/en_GB-alan-medium.onnx.json"
  fi
  echo "Local STT/TTS environment ready in $VOICE_DIR"
else
  echo "Tip: Run 'bash examples/linux-voice/install.sh --with-models' to auto-install Faster-Whisper, Piper TTS, and Kokoro into an isolated venv."
fi
