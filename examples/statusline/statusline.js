#!/usr/bin/env node
const fs = require('fs');
const path = require('path');
const os = require('os');
const execSync = require('child_process').execSync;

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
  // Output a clear error message in the statusline to help debugging
  console.log(`\x1b[31m● ERROR: Invalid JSON input to statusline.js (${e.message})\x1b[0m`);
  process.exit(0);
}

// ─── ANSI Helpers (Standard 16-color palette only) ───────────────────────────
const R = "\x1b[0m";         // Reset
const B = "\x1b[1m";         // Bold
const D = "\x1b[2m";         // Dim
const I = "\x1b[3m";         // Italic

// Foreground accents (Standard 16 colors)
const FG_BLACK = "\x1b[30m";
const FG_RED = "\x1b[31m";
const FG_GREEN = "\x1b[32m";
const FG_YELLOW = "\x1b[33m";
const FG_BLUE = "\x1b[34m";
const FG_MAGENTA = "\x1b[35m";
const FG_CYAN = "\x1b[36m";
const FG_WHITE = "\x1b[37m";

const FG_GRAY = "\x1b[90m";
const FG_BRIGHT_RED = "\x1b[91m";
const FG_BRIGHT_GREEN = "\x1b[92m";
const FG_BRIGHT_YELLOW = "\x1b[93m";
const FG_BRIGHT_BLUE = "\x1b[94m";
const FG_BRIGHT_MAGENTA = "\x1b[95m";
const FG_BRIGHT_CYAN = "\x1b[96m";
const FG_BRIGHT_WHITE = "\x1b[97m";

const NUM_COLOR = FG_BRIGHT_WHITE + B;

// ─── Extract fields with fallbacks ───────────────────────────────────────────
const state = data.agent_state || "idle";
const usedPct = (data.context_window && typeof data.context_window.used_percentage === 'number') ? data.context_window.used_percentage : 0;
let vcsBranch = (data.vcs && data.vcs.branch) ? data.vcs.branch : "";
let vcsDirty = (data.vcs && data.vcs.dirty) ? data.vcs.dirty : false;
let vcsType = (data.vcs && data.vcs.type) ? data.vcs.type : "";
const sandboxEnabled = (data.sandbox && data.sandbox.enabled) ? data.sandbox.enabled : false;
const sandboxNet = (data.sandbox && data.sandbox.allow_network) ? data.sandbox.allow_network : false;
const artifactCount = data.artifact_count || 0;
const subagentsCount = Array.isArray(data.subagents) ? data.subagents.length : 0;
const taskCount = data.task_count || 0;
const modelId = (data.model && data.model.id) ? data.model.id : "";
const modelName = (data.model && data.model.display_name) ? data.model.display_name : "";
const cols = data.terminal_width || 80;
const cwd = data.cwd || "";
const convId = data.conversation_id || "";
const inputTokens = (data.context_window && data.context_window.total_input_tokens) ? data.context_window.total_input_tokens : 0;
const outputTokens = (data.context_window && data.context_window.total_output_tokens) ? data.context_window.total_output_tokens : 0;
const ctxLimit = (data.context_window && data.context_window.context_window_size) ? data.context_window.context_window_size : 0;
const ctxUsed = inputTokens + outputTokens;

const gemini5h = (data.quota && data.quota["gemini-5h"] && typeof data.quota["gemini-5h"].remaining_fraction === 'number') ? data.quota["gemini-5h"].remaining_fraction * 100 : -1;
const geminiWk = (data.quota && data.quota["gemini-weekly"] && typeof data.quota["gemini-weekly"].remaining_fraction === 'number') ? data.quota["gemini-weekly"].remaining_fraction * 100 : -1;
const tp5h = (data.quota && data.quota["3p-5h"] && typeof data.quota["3p-5h"].remaining_fraction === 'number') ? data.quota["3p-5h"].remaining_fraction * 100 : -1;
const tpWk = (data.quota && data.quota["3p-weekly"] && typeof data.quota["3p-weekly"].remaining_fraction === 'number') ? data.quota["3p-weekly"].remaining_fraction * 100 : -1;

const gemini5hReset = (data.quota && data.quota["gemini-5h"] && typeof data.quota["gemini-5h"].reset_in_seconds === 'number') ? data.quota["gemini-5h"].reset_in_seconds : -1;
const geminiWkReset = (data.quota && data.quota["gemini-weekly"] && typeof data.quota["gemini-weekly"].reset_in_seconds === 'number') ? data.quota["gemini-weekly"].reset_in_seconds : -1;
const tp5hReset = (data.quota && data.quota["3p-5h"] && typeof data.quota["3p-5h"].reset_in_seconds === 'number') ? data.quota["3p-5h"].reset_in_seconds : -1;
const tpWkReset = (data.quota && data.quota["3p-weekly"] && typeof data.quota["3p-weekly"].reset_in_seconds === 'number') ? data.quota["3p-weekly"].reset_in_seconds : -1;

// ─── VCS directly from git (bypasses JSON parsing entirely for accuracy) ──────
try {
  const gitDir = cwd || ".";
  const branch = execSync(`git -C "${gitDir}" rev-parse --abbrev-ref HEAD 2>/dev/null`, { encoding: 'utf8' }).trim();
  if (branch) {
    vcsBranch = branch;
    vcsType = "git";
    const status = execSync(`git -C "${gitDir}" status --porcelain 2>/dev/null`, { encoding: 'utf8' }).trim();
    vcsDirty = status.length > 0;
  }
} catch (e) {
  // Ignore git errors
}

// ─── Helper Formatting Functions ─────────────────────────────────────────────
function humanFormat(num) {
  if (!num || isNaN(num) || num === 0) return "0";
  if (num >= 1000000) {
    return (num / 1000000).toFixed(1).replace(/\.0$/, '') + "M";
  }
  if (num >= 1000) {
    return (num / 1000).toFixed(1).replace(/\.0$/, '') + "K";
  }
  return num.toString();
}

function shortenPath(p) {
  if (!p) return "";
  const home = os.homedir();
  if (p.startsWith(home)) {
    p = "~" + p.slice(home.length);
  }
  if (p.length > 25) {
    return "..." + path.basename(p);
  }
  return p;
}

const cwdShort = shortenPath(cwd);

// ─── Strip ANSI escapes to measure visible length ────────────────────────────
function visibleLen(str) {
  return str.replace(/\x1b\[[0-9;]*m/g, '').length;
}

// ─── Right-align helper ──────────────────────────────────────────────────────
function printRightAligned(left, right, totalCols) {
  const leftVis = visibleLen(left);
  const rightVis = visibleLen(right);
  let pad = totalCols - leftVis - rightVis;
  if (pad < 1) pad = 1;
  console.log(left + " ".repeat(pad) + right);
}

// ─── State Indicator ─────────────────────────────────────────────────────────
let S = "";
switch (state) {
  case 'idle':
    S = `${FG_BRIGHT_GREEN}${B}  READY${R}`;
    break;
  case 'thinking':
    S = `${FG_BRIGHT_YELLOW}${B} 󰟷 THINKING${R}`;
    break;
  case 'working':
    S = `${FG_BRIGHT_CYAN}${B}  WORKING${R}`;
    break;
  case 'tool_use':
    S = `${FG_BRIGHT_MAGENTA}${B}  TOOL${R}`;
    break;
  default:
    S = `${FG_WHITE}${B}  ${state.toUpperCase()}${R}`;
}

// ─── Separators ──────────────────────────────────────────────────────────────
const dot = `${FG_GRAY} | ${R}`;

// ─── VCS Branch & Type ───────────────────────────────────────────────────────
let V = "";
if (vcsBranch) {
  if (vcsDirty || vcsDirty === "true") {
    V = `${dot}${R}${FG_BRIGHT_RED} ${vcsBranch}${FG_BRIGHT_YELLOW}*${R}`;
  } else {
    V = `${dot}${R}${FG_BRIGHT_BLUE} ${vcsBranch}${R}`;
  }
}

// ─── Model ───────────────────────────────────────────────────────────────────
const modelDisp = modelName || modelId;
let M = "";
if (modelDisp) {
  M = `${FG_GRAY}${dot}${FG_BRIGHT_MAGENTA}${I} ${R}${modelDisp}${R}`;
}

// ─── Sandbox Badge ───────────────────────────────────────────────────────────
let SB = "";
if (sandboxEnabled || sandboxEnabled === "true") {
  if (sandboxNet || sandboxNet === "true") {
    SB = `${FG_GREEN}󰒙 ${FG_BRIGHT_GREEN}${B}ON (net)${R}`;
  } else {
    SB = `${FG_GREEN}󰴴 ${FG_BRIGHT_GREEN}${B}ON (no-net)${R}`;
  }
} else {
  SB = `${FG_RED}󰦜 ${FG_BRIGHT_RED}${B}OFF${R}`;
}

// ─── Context Bar (20 segments) ───────────────────────────────────────────────
const barLen = 20;
const pctInt = Math.floor(usedPct);
const filled = Math.floor((pctInt * barLen) / 100);
const remainder = (pctInt * barLen) % 100;

let barColor = FG_YELLOW;
if (pctInt >= 90) {
  barColor = FG_BRIGHT_RED;
} else if (pctInt >= 60) {
  barColor = FG_BRIGHT_YELLOW;
}

let bar = "";
for (let i = 0; i < barLen; i++) {
  if (i < filled) {
    bar += "█";
  } else if (i === filled) {
    if (remainder >= 75) {
      bar += "▓";
    } else if (remainder >= 50) {
      bar += "▒";
    } else if (remainder >= 25) {
      bar += "░";
    } else {
      bar += "·";
    }
  } else {
    bar += "·";
  }
}

// ─── Stats & Metadata formatting ─────────────────────────────────────────────
const pctFmt = usedPct.toFixed(1);
const ctxBar = `${FG_YELLOW}󱍏  ${R}${barColor}${bar}${R} ${NUM_COLOR}${pctFmt}%${R}`;
const artFmt = `${FG_BLUE} ${NUM_COLOR}${artifactCount}${R}`;
const subFmt = `${FG_CYAN}󱙺 ${NUM_COLOR}${subagentsCount}${R}`;
const bgFmt = `${FG_MAGENTA} ${NUM_COLOR}${taskCount}${R}`;

let dirFmt = "";
if (cwdShort) {
  dirFmt = `${FG_GRAY}${dot}${FG_CYAN} ${R}${cwdShort}${R}`;
}

let convFmt = "";
if (convId) {
  convFmt = `${FG_GRAY}${dot}${FG_GRAY}󰍪 ${convId.slice(0, 8)}${R}`;
}

let tokDetails = "";
if (ctxUsed > 0) {
  tokDetails = ` (${humanFormat(ctxUsed)}/${humanFormat(ctxLimit)})`;
}

// ─── Quota formatting ────────────────────────────────────────────────────────
function formatResetTime(sec) {
  if (sec === undefined || sec === null || sec <= 0) return "";
  const days = Math.floor(sec / 86400);
  const rem = sec % 86400;
  const hours = Math.floor(rem / 3600);
  const mins = Math.floor((rem % 3600) / 60);

  if (days > 0) {
    return hours > 0 ? `${days}d ${hours}h` : `${days}d`;
  } else if (hours > 0) {
    return mins > 0 ? `${hours}h ${mins}m` : `${hours}h`;
  } else if (mins > 0) {
    return `${mins}m`;
  } else {
    return "<1m";
  }
}

function makeQuotaBar(val, label, barColor, resetSec) {
  if (val === undefined || val === null || val < 0) {
    return `${FG_GRAY}| ${R}${FG_BRIGHT_WHITE}${B}${label}${R} ${FG_GRAY}${"░".repeat(20)} N/A${R}`;
  }
  let color = FG_BRIGHT_GREEN;
  if (val < 20) {
    color = FG_BRIGHT_RED;
  } else if (val < 50) {
    color = FG_BRIGHT_YELLOW;
  }

  const barLen = 20;
  const pctInt = Math.floor(val);
  const filled = Math.floor((pctInt * barLen) / 100);
  const remainder = (pctInt * barLen) % 100;

  let bar = "";
  for (let i = 0; i < barLen; i++) {
    if (i < filled) {
      bar += "█";
    } else if (i === filled) {
      if (remainder >= 75) {
        bar += "▓";
      } else if (remainder >= 50) {
        bar += "▒";
      } else if (remainder >= 25) {
        bar += "░";
      } else {
        bar += "░";
      }
    } else {
      bar += "░";
    }
  }

  let coloredBar = "";
  let inColor = false;
  for (let i = 0; i < barLen; i++) {
    const char = bar[i];
    if (char === "█" || char === "▓" || char === "▒") {
      if (!inColor) {
        coloredBar += barColor;
        inColor = true;
      }
      coloredBar += char;
    } else {
      if (inColor) {
        coloredBar += R;
        inColor = false;
      }
      coloredBar += `${FG_GRAY}${char}${R}`;
    }
  }
  if (inColor) {
    coloredBar += R;
  }

  const valFmt = val.toFixed(1).replace(/\.0$/, '');
  const resetStr = resetSec > 0 ? ` ⌛️ ${formatResetTime(resetSec)}` : "";
  return `${FG_GRAY}| ${R}${FG_BRIGHT_WHITE}${B}${label}${R} ${coloredBar} ${color}${valFmt}%${R}${resetStr}`;
}

const isGemini = (modelDisp || "").toLowerCase().includes("gemini");
const q5h = isGemini ? gemini5h : tp5h;
const qWk = isGemini ? geminiWk : tpWk;
const q5hReset = isGemini ? gemini5hReset : tp5hReset;
const qWkReset = isGemini ? geminiWkReset : tpWkReset;

const quotaFmt = (q5h >= 0 || qWk >= 0) ? `${makeQuotaBar(q5h, "5H", FG_BRIGHT_CYAN, q5hReset)} ${makeQuotaBar(qWk, "7D", FG_BRIGHT_MAGENTA, qWkReset)}` : "";

// ─── Output Assembly ──────────────────────────────────────────────────────────
if (cols >= 180) {
  let line1 = `${S}${M}${dirFmt}${V}${convFmt}`;
  if (ctxUsed > 0) {
    tokDetails = ` (${humanFormat(ctxUsed)}/${humanFormat(ctxLimit)})${dot}${FG_YELLOW} ${R} (${humanFormat(inputTokens)} in/${humanFormat(outputTokens)} out)`;
  }
  let line2 = `${artFmt}${dot}${subFmt}${dot}${bgFmt}${dot}${SB}${dot}${ctxBar}${tokDetails}${dot}${quotaFmt}`;
  printRightAligned(line1, line2, cols);
} else if (cols >= 90) {
  let line1 = `${S}${M}${dirFmt}${V}`;
  let line2 = ` ${ctxBar}${tokDetails}${dot}${artFmt}${dot}${subFmt}${dot}${bgFmt}${dot}${SB}${dot}${quotaFmt}`;
  console.log(`${FG_GRAY}╭─${R}${line1}`);
  console.log(`${FG_GRAY}╰─${R}${line2}`);
} else {
  let mShort = "";
  if (modelDisp) {
    mShort = `${FG_GRAY} ╱ ${FG_BRIGHT_MAGENTA}${modelDisp}${R}`;
  }
  console.log(`${S}${mShort}`);
  console.log(`${ctxBar}${dot}${bgFmt}${dot}${quotaFmt}`);
}
