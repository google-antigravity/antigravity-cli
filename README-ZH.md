# Antigravity CLI

**语言 / Languages:** [English](./README.md) · [中文](./README-ZH.md) · [Español](./README-ES.md) · [Français](./README-FR.md) · [Português](./README-PT.md) · [Русский](./README-RU.md) · [Deutsch](./README-DE.md)

Antigravity CLI 理解你的代码库，在你授权下进行编辑并执行命令——一切尽在终端中完成。

- **官方文档**：[antigravity.google/docs/cli-overview](https://antigravity.google/docs/cli-overview)
- **官方网站**：[antigravity.google/product/antigravity-cli](https://antigravity.google/product/antigravity-cli)

![Antigravity CLI Demo](agy-cli-demo.gif)

---

Antigravity CLI 将 Antigravity 2.0 的核心能力（多步推理、多文件编辑、工具调用和持久化历史）直接带入终端。它针对键盘驱动的工作流程和远程 SSH 会话进行了优化，资源开销极低。

---

## 功能概览

| 功能 | Antigravity CLI | Antigravity 2.0 |
| :--- | :--- | :--- |
| **主要定位** | 速度、键盘效率、低开销 | 全面性、可视化编排、项目管理 |
| **界面** | 终端用户界面 (TUI) | 完整富 GUI 应用 |
| **工作流** | SSH/远程会话、键盘优先 | 本地工作区、重度编排 |
| **Agent 引擎** | 共享核心 Agent 引擎 | 共享核心 Agent 引擎 |

---

## 集成

- **共享 Agent 引擎**：两种界面运行在同一核心 Agent 引擎上，改进会自动应用到两者。
- **共享设置**：偏好和权限双向同步。
- **会话导出**：将终端会话导出到 Antigravity 2.0 GUI 以继续工作。

---

## 安装

### macOS / Linux
```bash
curl -fsSL https://antigravity.google/cli/install.sh | bash
```

### Windows PowerShell
```powershell
irm https://antigravity.google/cli/install.ps1 | iex
```

### Windows CMD
```cmd
curl -fsSL https://antigravity.google/cli/install.cmd -o install.cmd && install.cmd && del install.cmd
```

---

## 身份验证

CLI 通过系统密钥环进行身份验证，若不存在活跃会话则回退到 Google 登录。

- **本地**：自动打开默认浏览器。
- **远程 / SSH**：检测 SSH 会话并打印授权 URL，以便在本地完成登录。
- **退出登录**：运行 `/logout` 清除已保存的凭据。

> [!NOTE]
> 如需企业访问，请在 onboarding 期间连接你的 GCP 项目。详见 Enterprise 页面。

---

## 服务条款与数据使用

> [!WARNING]
> AI 编程 Agent 存在已知的安全风险，包括自主代码执行、数据外泄、提示注入和供应链风险。请确保监控并验证 Agent 执行的所有操作。

使用 Antigravity CLI 即表示你同意通过允许 Google 根据 Google 服务条款和 Google 隐私政策收集和使用你的交互数据来帮助改进产品。你可以随时在设置中选择退出。

### 法律与隐私链接

- **服务条款**：[antigravity.google/terms](https://antigravity.google/terms)
- **隐私政策**：[policies.google.com/privacy](https://policies.google.com/privacy)
