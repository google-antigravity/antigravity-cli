#!/usr/bin/env bash
# Add to ~/.bashrc or ~/.zshrc to drain buffered PTY stdin prior to BubbleTea TUI startup

agy() {
  if [ -t 0 ]; then
    python3 -c 'import sys, termios; termios.tcflush(sys.stdin.fileno(), termios.TCIFLUSH)' 2>/dev/null || true
    if [ $# -eq 0 ]; then
      (sleep 0.08; python3 -c 'import termios; fd=open("/dev/tty"); termios.tcflush(fd.fileno(), termios.TCIFLUSH)' 2>/dev/null || true) &
    fi
  fi
  command "${AGY_BIN:-$HOME/.local/bin/agy}" "$@"
}
