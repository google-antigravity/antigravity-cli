<p align="center">
  <a href="README.md">English</a> | <b>中文</b> | <a href="README-ES.md">Español</a> | <a href="README-FR.md">Français</a> | <a href="README-PT.md">Português</a> | <a href="README-UA.md">Українська</a> | <a href="README-DE.md">Deutsch</a>
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/agy-cli-demo.gif" alt="Antigravity CLI Logo" width="600" style="border-radius: 8px; box-shadow: 0 4px 20px rgba(0,0,0,0.25);" />
</p>

<h1 align="center">🚀 Antigravity CLI</h1>

<p align="center">
  <strong>社区分叉与硬化离线版 google-antigravity/antigravity-cli，支持状态栏和窗口标题的自动设置</strong>
</p>

<p align="center">
  <a href="https://github.com/weby-homelab/antigravity-cli"><img src="https://img.shields.io/badge/fork-google--antigravity-8a2be2?style=for-the-badge&logo=github" alt="GitHub Fork" /></a>
  <a href="CHANGELOG.md"><img src="https://img.shields.io/badge/version-1.1.0-success?style=for-the-badge&logo=git" alt="Version" /></a>
  <a href="https://antigravity.google/terms"><img src="https://img.shields.io/badge/license-Apache--2.0-blue?style=for-the-badge" alt="License" /></a>
  <img src="https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows-lightgrey?style=for-the-badge" alt="Supported Platforms" />
</p>

<p align="center">
  🤖 <b>直接在您的终端中运行 of AI 编码智能体</b>。理解您的代码库上下文，创建和编辑文件，在沙箱中执行安全命令，并在单个提示词中解决复杂的架构任务。
</p>

---

## ⚡ 快速开始

### 即时安装（离线优先与零依赖）
此分叉版本直接从 **GitHub Release Assets**（而不是 Google API 服务器）下载预编译的二进制文件。如果预先将所需的归档文件加载到 `packages/binaries/` 文件夹中，则同样支持完全自治的离线安装。

#### 🐧 Linux 和 🍎 macOS
```bash
# 从分叉存储库进行网络安装：
curl -fsSL https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/install.sh | bash

# 或者从本地存储库进行离线安装：
git clone https://github.com/weby-homelab/antigravity-cli.git
cd antigravity-cli
# （可选：将对应平台的归档文件下载到 packages/binaries/ 中）
make install
```

#### 🪟 Windows PowerShell
```powershell
# 网络安装：
irm https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/install.ps1 | iex

# 或者从克隆的存储库进行离线安装：
.\install.ps1
```

#### 🪟 Windows CMD
```cmd
# 网络安装：
curl -fsSL https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/install.cmd -o install.cmd && install.cmd && del install.cmd

# 或者从克隆的存储库进行离线安装：
install.cmd
```

---

## 📋 核心功能

> [!NOTE]
> 与原始版本不同，此分叉版本经过特别优化，适用于无头（headless）环境、SSH 会话以及本地家庭实验室（Home Labs）中的稳定运行。

*   📂 **多文件编辑** — 在您的工作区中同时编辑多个文件，并在应用更改前进行确认。
*   🔒 **安全 Shell 命令** — 在内置的 Docker 容器（沙箱）或主机系统上执行任意终端命令。
*   🧠 **多步推理 (PAV)** — 独立构建任务执行计划，测试代码并调试自身的错误。
*   💾 **持久化会话历史记录** — 在会话之间保存完整的对话上下文和工作区状态。
*   🔌 **插件系统** — 使用自定义 *技能 (Skills)* 和 MCP（Model Context Protocol，模型上下文协议）服务器扩展智能体的能力。

---

## ⚙️ 配置方式

### 1. 项目配置 (`GEMINI.md`)
在项目的根目录下创建一个 `GEMINI.md` 文件，为 AI 智能体提供特定的项目上下文和开发规则：

```markdown
# 项目上下文

- 本项目使用 FastAPI 和 Pydantic v2。
- 请始终使用 `model_dump()` 代替已废弃的 `dict()`。
- 严格规则：严禁在代码中硬编码任何密码。所有机密信息必须从 `.env` 文件导入。
```

### 2. 全局设置 (`~/.gemini/antigravity-cli/settings.json`)
全局配置文件控制工具执行权限、状态栏/窗口标题脚本以及 MCP 服务器：

- **Linux/Unix**: `~/.gemini/antigravity-cli/settings.json`
- **macOS**: `~/Library/Application Support/antigravity-cli/settings.json`
- **Windows**: `%APPDATA%\antigravity-cli\settings.json`

```json
{
  "toolPermission": "always-proceed",
  "statusLine": {
    "enabled": true,
    "command": "/home/user/.gemini/antigravity-cli/statusline.sh"
  },
  "title": {
    "enabled": true,
    "command": "/home/user/.gemini/antigravity-cli/title.sh"
  },
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"]
    }
  }
}
```

> [!TIP]
> 如需具有实时 Git 状态跟踪、Token 计数器、模型配额以及电源/电池状态的高级响应式状态栏，请使用 **[Antigravity CLI Statusline (Max Edition)](https://github.com/weby-homelab/antigravity-cli-statusline)** 插件。


### 3. 专业智能体
您可以使用 JSON 格式定义 AI 智能体的自定义角色和说明。每个智能体必须有自己的目录，其中包含一个 `agent.json` 文件：

- **全局智能体 (Linux/Unix)**: `~/.gemini/antigravity-cli/agents/{agent_name}/agent.json`
- **全局智能体 (macOS)**: `~/Library/Application Support/antigravity-cli/agents/{agent_name}/agent.json`
- **全局智能体 (Windows)**: `%APPDATA%\antigravity-cli\agents\{agent_name}\agent.json`
- **本地智能体 (项目工作区)**: `{workspace_root}/.agents/agents/{agent_name}/agent.json`

```json
{
  "name": "security-reviewer",
  "description": "在提交前分析代码漏洞",
  "instructions": "检查更改内容：\n- OWASP Top 10 漏洞\n- API 密钥或凭证泄露\n- 防火墙/nftables 配置正确性"
}
```

---

## 🔐 身份验证方式

| 方法 | 命令 / 环境变量 | 限制与特点 |
| :--- | :--- | :--- |
| **Google 身份验证（浏览器）** | 首次运行 `agy` 时自动触发 | 标准登录。免费限制：60 次请求/分钟，1000 次请求/天 |
| **API 密钥（离线）** | `export GEMINI_API_KEY="X"` | 推荐用于服务器环境和自动化工作流 |
| **Vertex AI** | `export GOOGLE_GENAI_USE_VERTEXAI=true` | 企业级方案，使用 Google Cloud 云基础设施 |
| **注销登录** | `/logout` | 清除本地会话令牌 |

---

## 🔧 常用命令参考

### 命令行工具
```bash
agy                              # 启动交互式会话
agy -p "提示词"                  # 单次执行，不进入聊天界面
agy -c                           # 继续上一次未完成的对话
agy --conversation <ID>          # 通过特定 ID 加载会话
agy --sandbox                    # 在隔离的 Docker 容器中运行
agy update                       # 更新二进制文件到最新版本
agy plugin list                  # 列出已安装的插件
```

### 聊天界面中的斜杠命令 (Slash Commands)
*   `/help` — 获取可用工具的帮助信息。
*   `/settings` — 交互式配置设置项。
*   `/usage` — 消耗的令牌（Token）数量和配额统计。
*   `/diff` — 查看项目中当前未保存的更改。
*   `/statusline` — 配置终端状态栏的显示。

---

## 🔄 从 Gemini CLI 迁移

> [!WARNING]
> 原始的 Gemini CLI (`gemini`) 将于 **2026 年 6 月 18 日**起停止对非企业账户的支持。请及时迁移到 Antigravity CLI。

### 快速迁移步骤
1. 安装新客户端：`curl -fsSL https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/install.sh | bash`
2. 迁移本地自定义智能体配置文件（例如，将 `~/.gemini/agents/` 下的 YAML 格式自定义智能体转换为 `~/.gemini/antigravity-cli/agents/{agent_name}/agent.json` 下的 JSON 文件）。
3. 更新 GitHub Actions 中的 CI/CD 配置，将所有的 `gemini` 调用替换为 `agy`。
4. 卸载旧的依赖库：`npm uninstall -g @google/gemini-cli`

### 对比表

| 功能 / 属性 | Gemini CLI (旧版) | Antigravity CLI (新版) |
| :--- | :--- | :--- |
| **开发语言/平台** | Node.js / TypeScript | Go (原生编译的二进制文件) |
| **执行命令** | `gemini` | `agy` |
| **启动速度** | ~1.2秒 (Node.js 启动延迟) | **~0.05秒 (原生瞬间启动)** |
| **项目配置文件** | `GEMINI.md` | `GEMINI.md` |
| **自动更新** | 通过 `npm update` | 内置的自我更新机制 |
| **维护状态** | ⛔ 已停止支持 (2026年6月18日) | ✅ 持续活跃开发 (上游支持) |

---

## 📁 存储库结构

```
antigravity-cli/
├── install.sh           # Linux/macOS 安装程序 (离线/在线)
├── install.ps1          # Windows PowerShell 安装程序 (离线/在线)
├── install.cmd          # Windows CMD 安装程序
├── Makefile             # 自动化目标 (make install/reinstall/uninstall)
├── GEMINI.md            # 项目上下文模板文件
├── packages/            # 本地离线分发包
│   ├── manifests/       # 适用于所有平台的版本清单
│   └── binaries/        # (离线模式下需手动创建)
└── CHANGELOG.md         # 变更日志和发布记录
```

---

## 🤝 参与贡献与社区

本仓库是原始上游项目 [google-antigravity/antigravity-cli](https://github.com/google-antigravity/antigravity-cli) 的独立社区分叉版本。

**我们的改进：**
*   🌍 支持文档和指南的多语言本地化。
*   📦 自主性：具备完全离线安装能力，无需从 Google API 服务器下载。
*   🛠️ 便利性：添加了 `Makefile`，简化工具生命周期管理。
*   🛡️ 安全性：针对沙箱环境进行持续的安全改进和漏洞修复。

---

## 📜 法律声明与商标说明

*   **官方链接**: [官方文档仓库](https://github.com/google-antigravity/antigravity-cli) · [官方 CLI 代码库](https://github.com/google-gemini/gemini-cli) · [官方网站](https://antigravity.google)
*   **使用条款**: [antigravity.google/terms](https://antigravity.google/terms) · [policies.google.com/privacy](https://policies.google.com/privacy)

> [!IMPORTANT]
> **分叉版法律地位:**
> 本存储库是原始客户端的独立非商业副本（社区分叉版本）。它**不是** Google LLC 的官方产品。Google LLC 对此分叉版本的性能、修改或安全性不承担任何责任。
> 
> **许可与版权信息:**
> 原始软件基于 [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0) 协议分发。所有原始代码的知识产权均归 **Copyright © 2025 Google LLC** 所有。
> 
> **商标使用说明:**
> "Antigravity CLI" 名称及相关徽标仅在合理使用（Customary Use）限制范围内使用，以描述软件的来源、兼容性和功能用途。本分叉项目不声称拥有 Google LLC 任何商标的所有权。
> 
> **免责声明:**
> 本软件按“原样”提供，不提供任何明示或暗示的保证。您需自行承担使用该软件的所有责任和风险。

> [!CAUTION]
> AI 编码智能体运行具有自主性。在确认执行前，请务必仔细检查其建议的 diff 代码块和执行命令，尤其是在处理系统文件或防火墙配置时。
