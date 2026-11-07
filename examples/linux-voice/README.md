# Linux PipeWire `/voice` Shim & Local STT/TTS Fallback

On modern Linux distributions using **PipeWire 1.0+** (Ubuntu 24.04+, Fedora 40+, Debian 12/13, Arch Linux, NVIDIA DGX OS), the Antigravity CLI `/voice` command invokes `pw-record` with the `--raw` flag. Because PipeWire's `pw-record` binary does not accept `--raw` (unlike PulseAudio's `parec`), `/voice` exits immediately or captures silent/low-gain audio on USB microphones.

This directory provides a zero-dependency Python 3 standard-library shim (`pw-record`) and installer (`install.sh`) that resolves Linux `/voice` capture end-to-end:

1. **Flag Normalization**: Transparently strips the unsupported `--raw` flag before invoking `/usr/bin/pw-record` when streaming raw PCM (`-`) to `agy`.
2. **Automatic Physical Microphone Selection**: Queries `pactl list short sources` to select and unmute active hardware USB/analog microphones while ignoring `.monitor` loopback sinks.
3. **Real-Time DC-Offset Removal & Automatic Gain Control (AGC)**: Uses Python's built-in `array` module to center 16kHz `s16le` PCM frames and normalize quiet microphone levels in real time (`8ms` startup overhead), preventing false `No speech detected` errors.
4. **Optional Offline Faster-Whisper Fallback**: Tees the captured PCM stream to `/tmp/agy_voice_last.raw` and optionally forwards it to a local Faster-Whisper UNIX domain socket (`/run/user/$UID/voice_dictate.sock`) if cloud transcription is unavailable.

## Installation

```bash
bash examples/linux-voice/install.sh
```

Ensure `~/.local/bin` precedes `/usr/bin` in your `PATH`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

### Optional Local STT/TTS Model Bootstrap (`Faster-Whisper` + `Piper` + `Kokoro`)

To keep the Git repository lightweight and free of binary model weights, `install.sh` includes an optional `--with-models` flag that creates an isolated Python virtual environment (`~/.local/share/antigravity-voice/venv`), installs [`requirements.txt`](requirements.txt) (`faster-whisper`, `piper-tts`, `kokoro-onnx`), and downloads the Piper ONNX voice model on demand:

```bash
bash examples/linux-voice/install.sh --with-models
ai-say "Antigravity local voice synthesis is active."
```
