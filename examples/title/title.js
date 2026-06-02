#!/usr/bin/env node
const fs = require('fs');
const path = require('path');

// ─── Read JSON from stdin ────────────────────────────────────────────────────
let rawData = '';
try {
  rawData = fs.readFileSync(0, 'utf-8');
} catch (e) {
  // Silence read errors
}

let data = {};
try {
  data = JSON.parse(rawData || '{}');
} catch (e) {
  console.log(`🤖 ERROR: Invalid JSON (${e.message})`);
  process.exit(0);
}

const state = data.agent_state || "idle";
const cwd = (data.workspace && data.workspace.current_dir) || data.cwd || "";

let workspace = "unknown";
if (cwd) {
  const match = cwd.match(/\/google\/src\/cloud\/[^/]+\/([^/]+)/);
  if (match) {
    workspace = match[1];
  } else {
    workspace = path.basename(cwd);
  }
}

// Map state to emoji
let emoji = "🤖";
switch (state) {
  case 'initializing':
    emoji = "🚀";
    break;
  case 'idle':
    emoji = "😴";
    break;
  case 'thinking':
    emoji = "🤔";
    break;
  case 'working':
    emoji = "🏃";
    break;
  case 'tool_use':
    emoji = "🛠️";
    break;
}

console.log(`${emoji} ${state} | ${workspace}`);
