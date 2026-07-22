<p align="center">
  <a href="README.md">English</a> | <a href="README-ZH.md">中文</a> | <a href="README-ES.md">Español</a> | <a href="README-FR.md">Français</a> | <b>Português</b> | <a href="README-UA.md">Українська</a> | <a href="README-DE.md">Deutsch</a>
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/agy-cli-demo.gif" alt="Antigravity CLI Logo" width="600" style="border-radius: 8px; box-shadow: 0 4px 20px rgba(0,0,0,0.25);" />
</p>

<h1 align="center">🚀 Antigravity CLI</h1>

<p align="center">
  <strong>Fork da comunidade e versão offline de google-antigravity/antigravity-cli com configuração automática de statusline e título de janela</strong>
</p>

<p align="center">
  <a href="https://github.com/weby-homelab/antigravity-cli"><img src="https://img.shields.io/badge/fork-google--antigravity-8a2be2?style=for-the-badge&logo=github" alt="GitHub Fork" /></a>
  <a href="CHANGELOG.md"><img src="https://img.shields.io/badge/version-1.1.0-success?style=for-the-badge&logo=git" alt="Version" /></a>
  <a href="https://antigravity.google/terms"><img src="https://img.shields.io/badge/license-Apache--2.0-blue?style=for-the-badge" alt="License" /></a>
  <img src="https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows-lightgrey?style=for-the-badge" alt="Supported Platforms" />
</p>

<p align="center">
  🤖 <b>Agente de codificação de IA diretamente no seu terminal</b>. Compreende o contexto da sua base de código, cria e edita arquivos, executa comandos seguros em uma sandbox e resolve tarefas arquitetônicas complexas em um único prompt.
</p>

---

## ⚡ Início Rápido

### Instalação Instantânea (Foco em Offline e Sem Dependências)
Este fork faz o download de binários pré-compilados diretamente dos **GitHub Release Assets** (em vez dos servidores de API da Google). A instalação totalmente offline também é suportada se os arquivos necessários tiverem sido previamente carregados na pasta `packages/binaries/`.

#### 🐧 Linux e 🍎 macOS
```bash
# Instalação via rede a partir do repositório do fork:
curl -fsSL https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/install.sh | bash

# OU instalação offline a partir de um repositório local:
git clone https://github.com/weby-homelab/antigravity-cli.git
cd antigravity-cli
# (Opcional: baixe os arquivos da plataforma em packages/binaries/)
make install
```

#### 🪟 Windows PowerShell
```powershell
# Instalação via rede:
irm https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/install.ps1 | iex

# OU instalação offline a partir de um repositório clonado:
.\install.ps1
```

#### 🪟 Windows CMD
```cmd
# Instalação via rede:
curl -fsSL https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/install.cmd -o install.cmd && install.cmd && del install.cmd

# OU instalação offline a partir de um repositório clonado:
install.cmd
```

---

## 📋 Recursos Principais

> [!NOTE]
> Ao contrário da versão original, este fork é adaptado para uma operação estável em sessões headless/SSH e laboratórios domésticos locais.

*   📂 **Edição de Múltiplos Arquivos** — Edita vários arquivos simultaneamente no seu espaço de trabalho com confirmação prévia das alterações.
*   🔒 **Comandos de Shell Seguros** — Executa qualquer comando de terminal no container Docker integrado (sandbox) ou no sistema host.
*   🧠 **Raciocínio em Várias Etapas (PAV)** — Constrói de forma independente um plano de execução de tarefas, testa o código e depura os seus próprios erros.
*   💾 **Histórico de Conversa Persistente** — Salva o contexto completo da conversa e o estado do espaço de trabalho entre as sessões.
*   🔌 **Sistema de Plugins** — Estenda as capacidades do agente com *habilidades (Skills)* personalizadas e servidores MCP (Model Context Protocol).

---

## ⚙️ Configuração

### 1. Configuração do Projeto (`GEMINI.md`)
Crie um arquivo `GEMINI.md` na raiz do seu projeto para fornecer contexto específico e regras de desenvolvimento ao agente de IA:

```markdown
# Contexto do Projeto

- Este projeto usa FastAPI e Pydantic v2.
- Sempre use `model_dump()` em vez do obsoleto `dict()`.
- REGRA ESTRITA: Sem senhas expostas no código (hardcoded). Importe todos os segredos do `.env`.
```

### 2. Configurações Globais (`~/.gemini/antigravity-cli/settings.json`)
O arquivo de configuração global controla as permissões de execução de ferramentas, scripts de statusline/título e servidores MCP:

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
> Para obter uma linha de status avançada e responsiva com rastreamento de status Git em tempo real, medidores de tokens, cotas de modelos e estado de energia/batería, use o plugin **[Antigravity CLI Statusline (Max Edition)](https://github.com/weby-homelab/antigravity-cli-statusline)**.


### 3. Agentes Especializados
Você pode descrever funções e instruções personalizadas para agentes de IA no formato JSON. Cada agente deve ter seu próprio diretório contendo um arquivo `agent.json`:

- **Agentes Globais (Linux/Unix)**: `~/.gemini/antigravity-cli/agents/{agent_name}/agent.json`
- **Agentes Globais (macOS)**: `~/Library/Application Support/antigravity-cli/agents/{agent_name}/agent.json`
- **Agentes Globais (Windows)**: `%APPDATA%\antigravity-cli\agents\{agent_name}\agent.json`
- **Agentes Locais (Espaço de Trabalho)**: `{workspace_root}/.agents/agents/{agent_name}/agent.json`

```json
{
  "name": "security-reviewer",
  "description": "Analisa o código em busca de vulnerabilidades antes do commit",
  "instructions": "Verificar alterações para:\n- Vulnerabilidades OWASP Top 10\n- Vazamento de chaves de API ou segredos\n- Correção da configuração do firewall/nftables"
}
```

---

## 🔐 Métodos de Autenticação

| Método | Comando / Variável | Limitações e Recursos |
| :--- | :--- | :--- |
| **Google Auth (Navegador)** | Automaticamente no primeiro `agy` | Login padrão. Limite gratuito: 60 req/min, 1000 req/dia |
| **Chave de API (Offline)** | `export GEMINI_API_KEY="X"` | Recomendado para servidores e automação |
| **Vertex AI** | `export GOOGLE_GENAI_USE_VERTEXAI=true` | Nível corporativo com infraestrutura em nuvem do Google Cloud |
| **Sair (Sign Out)** | `/logout` | Limpeza de tokens de sessão local |

---

## 🔧 Referência de Comandos

### Linha de Comando
```bash
agy                              # Iniciar uma sessão interativa
agy -p "Prompt"                  # Execução única sem entrar no chat
agy -c                           # Continuar a última conversa incompleta
agy --conversation <ID>          # Carregar uma sessão por um ID específico
agy --sandbox                    # Executar em um container Docker isolado
agy update                       # Atualizar o binário para a versão mais recente
agy plugin list                  # Listar os plugins instalados
```

### Comandos de Barra (Slash Commands) na Interface de Chat
*   `/help` — Ajuda sobre ferramentas disponíveis.
*   `/settings` — Configuração interativa de definições.
*   `/usage` — Estatísticas de tokens gastos e cota.
*   `/diff` — Visualizar as alterações atuais não salvas no projeto.
*   `/statusline` — Configurar a exibição da linha de status do terminal.

---

## 🔄 Migração do Gemini CLI

> [!WARNING]
> A interface de linha de comando original Gemini CLI (`gemini`) deixará de oferecer suporte para contas não corporativas em **18 de junho de 2026**. A migração para o Antigravity CLI é necessária.

### Passos para Transição Rápida
1. Instale o novo cliente: `curl -fsSL https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/install.sh | bash`
2. Migre os arquivos de configuração de agentes personalizados locais (por exemplo, converta agentes personalizados de YAML dentro de `~/.gemini/agents/` em arquivos JSON em `~/.gemini/antigravity-cli/agents/{agent_name}/agent.json`).
3. Atualize as configurações de CI/CD no GitHub Actions, substituindo as chamadas de `gemini` por `agy`.
4. Desinstale a biblioteca antiga: `npm uninstall -g @google/gemini-cli`

### Tabela de Comparação

| Recurso | Gemini CLI (Legado) | Antigravity CLI (Moderno) |
| :--- | :--- | :--- |
| **Plataforma de Desenvolvimento** | Node.js / TypeScript | Go (Binário Nativo Compilado) |
| **Nome do Comando** | `gemini` | `agy` |
| **Velocidade de Inicialização** | ~1.2s (inicialização do Node.js) | **~0.05s (inicialização nativa instantânea)** |
| **Arquivo de Configuração** | `GEMINI.md` | `GEMINI.md` |
| **Atualização Automática** | Via `npm update` | Mecanismo de auto-atualização integrado |
| **Status do Suporte** | ⛔ Fim da vida útil (18 de junho de 2026) | ✅ Desenvolvimento Ativo (Upstream) |

---

## 📁 Estrutura do Repositório

```
antigravity-cli/
├── install.sh           # Instalador para Linux/macOS (offline/online)
├── install.ps1          # Instalador para Windows PowerShell (offline/online)
├── install.cmd          # Instalador para Windows CMD
├── Makefile             # Metas de automação (make install/reinstall/uninstall)
├── GEMINI.md            # Modelo de arquivo de contexto de projeto
├── packages/            # Distribuição offline local
│   ├── manifests/       # Manifestes de versão para todas as plataformas
│   └── binaries/        # (Criado manualmente para o modo offline)
└── CHANGELOG.md         # Registro de alterações e lançamentos
```

---

## 🤝 Contribuição & Comunidade

Este repositório é um fork da comunidade independente do projeto original [google-antigravity/antigravity-cli](https://github.com/google-antigravity/antigravity-cli).

**Nossas Melhorias:**
*   🌍 Suporte de localização em vários idiomas para documentos e guias.
*   📦 Autonomia: capacidade de instalação offline sem downloads da API da Google.
*   🛠️ Conveniência: adicionado `Makefile` para um ciclo de vida simplificado da ferramenta.
*   🛡️ Segurança: correções regulares de bugs e melhorias no ambiente de sandbox.

---

## 📜 Aviso Legal & Marcas Registradas

*   **Links Oficiais**: [Repositório Oficial de Documentação](https://github.com/google-antigravity/antigravity-cli) · [Base de Código Oficial do CLI](https://github.com/google-gemini/gemini-cli) · [Website Oficial](https://antigravity.google)
*   **Termos de Uso**: [antigravity.google/terms](https://antigravity.google/terms) · [policies.google.com/privacy](https://policies.google.com/privacy)

> [!IMPORTANT]
> **Status Legal do Fork:**
> Este repositório é uma cópia independente não comercial (Fork da Comunidade) do cliente original. Ele **não é** um produto oficial da Google LLC. A Google LLC não se responsabiliza pelo desempenho, modificações ou segurança deste fork.
> 
> **Licenciamento & Direitos Autorais:**
> O software original é distribuído sob a [Licença Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0). Todo o código original é propriedade intelectual de **Copyright © 2025 Google LLC**.
> 
> **Uso de Marca Registrada:**
> O nome "Antigravity CLI" e os logotipos associados são usados dentro dos limites do Uso Habitual exclusivamente para descrever a origem, compatibilidade e propósito funcional do software. Este projeto não reivindica a propriedade de nenhuma marca registrada da Google LLC.
> 
> **Isenção de Garantia:**
> O software é fornecido "COMO ESTÁ", SEM GARANTIAS DE QUALQUER TIPO, expressas ou implícitas. Você assume toda a responsabilidade e riscos associados ao seu uso.

> [!CAUTION]
> Os agentes de codificação de IA operam de forma autônoma. Sempre revise cuidadosamente os blocos de diff propostos e os comandos antes de confirmar a execução, especialmente ao trabalhar com arquivos do sistema ou configuração do firewall.
