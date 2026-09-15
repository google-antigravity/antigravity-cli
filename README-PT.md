# Antigravity CLI

**Idiomas / Languages:** [English](./README.md) · [中文](./README-ZH.md) · [Español](./README-ES.md) · [Français](./README-FR.md) · [Português](./README-PT.md) · [Русский](./README-RU.md) · [Deutsch](./README-DE.md)

Antigravity CLI entende sua base de código, faz edições com sua permissão e executa comandos — diretamente do seu terminal.

- **Documentação oficial**: [antigravity.google/docs/cli-overview](https://antigravity.google/docs/cli-overview)
- **Site oficial**: [antigravity.google/product/antigravity-cli](https://antigravity.google/product/antigravity-cli)

![Antigravity CLI Demo](agy-cli-demo.gif)

---

Antigravity CLI traz as capacidades principais do Antigravity 2.0 (raciocínio em várias etapas, edição de múltiplos arquivos, chamadas de ferramentas e histórico persistente) diretamente para o seu terminal. É otimizado para fluxos de trabalho orientados ao teclado e sessões SSH remotas com consumo mínimo de recursos.

---

## Recursos em resumo

| Recurso | Antigravity CLI | Antigravity 2.0 |
| :--- | :--- | :--- |
| **Foco principal** | Velocidade, eficiência com teclado, baixo consumo | Abrangência, orquestração visual, gestão de projetos |
| **Interface** | Interface de usuário de terminal (TUI) | Aplicativo GUI completo |
| **Fluxos de trabalho** | Sessões SSH/remotas, teclado em primeiro lugar | Espaços de trabalho locais, orquestração intensiva |
| **Motor de agentes** | Motor de agentes central compartilhado | Motor de agentes central compartilhado |

---

## Integração

- **Motor de agentes compartilhado**: Ambas as interfaces rodam no mesmo motor de agentes central. Melhorias se aplicam automaticamente a ambas.
- **Configurações compartilhadas**: Preferências e permissões sincronizam bidirecionalmente.
- **Exportação de sessões**: Exporte sessões de terminal para a GUI do Antigravity 2.0 para continuar trabalhando.

---

## Instalação

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

## Autenticação

A CLI autentica via keyring do sistema, com fallback para Google Sign-In se não houver sessão ativa.

- **Local**: Abre automaticamente seu navegador padrão.
- **Remoto / SSH**: Detecta sessões SSH e imprime uma URL de autorização para concluir o login localmente.
- **Sair**: Execute `/logout` para limpar credenciais salvas.

> [!NOTE]
> Para acesso empresarial, conecte seu projeto GCP durante o onboarding. Consulte a página Enterprise para detalhes.

---

## Termos de serviço e uso de dados

> [!WARNING]
> Agentes de codificação com IA apresentam riscos de segurança conhecidos, incluindo execução autônoma de código, exfiltração de dados, injeção de prompts e riscos de cadeia de suprimentos. Certifique-se de monitorar e verificar todas as ações realizadas pelo agente.

Ao usar Antigravity CLI, você concorda em ajudar a melhorar o produto permitindo que o Google colete e use seus dados de interação, sujeitos aos Termos de Serviço do Google e à Política de Privacidade do Google. Você pode optar por sair a qualquer momento nas configurações.

### Links legais e de privacidade

- **Termos de serviço**: [antigravity.google/terms](https://antigravity.google/terms)
- **Política de privacidade**: [policies.google.com/privacy](https://policies.google.com/privacy)
