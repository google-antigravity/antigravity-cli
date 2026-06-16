<p align="center">
  <a href="README.md">English</a> | <a href="README-ZH.md">中文</a> | <b>Español</b> | <a href="README-FR.md">Français</a> | <a href="README-PT.md">Português</a> | <a href="README-UA.md">Українська</a> | <a href="README-DE.md">Deutsch</a>
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/agy-cli-demo.gif" alt="Antigravity CLI Logo" width="600" style="border-radius: 8px; box-shadow: 0 4px 20px rgba(0,0,0,0.25);" />
</p>

<h1 align="center">🚀 Antigravity CLI</h1>

<p align="center">
  <strong>Bifurcación de la comunidad y versión fuera de línea de google-antigravity/antigravity-cli con configuración automática de statusline y título de ventana</strong>
</p>

<p align="center">
  <a href="https://github.com/weby-homelab/antigravity-cli"><img src="https://img.shields.io/badge/fork-google--antigravity-8a2be2?style=for-the-badge&logo=github" alt="GitHub Fork" /></a>
  <a href="CHANGELOG.md"><img src="https://img.shields.io/badge/version-1.0.8-success?style=for-the-badge&logo=git" alt="Version" /></a>
  <a href="https://antigravity.google/terms"><img src="https://img.shields.io/badge/license-Apache--2.0-blue?style=for-the-badge" alt="License" /></a>
  <img src="https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows-lightgrey?style=for-the-badge" alt="Supported Platforms" />
</p>

<p align="center">
  🤖 <b>Agente de codificación de IA directamente en su terminal</b>. Comprende el contexto de su código base, crea y edita archivos, ejecuta comandos seguros en un entorno aislado y resuelve tareas arquitectónicas complejas en una sola instrucción.
</p>

---

## ⚡ Inicio rápido

### Instalación instantánea (Primero fuera de línea y sin dependencias)
Esta bifurcación descarga archivos binarios precompilados directamente desde los **activos de lanzamiento de GitHub (GitHub Release Assets)** (en lugar de los servidores de la API de Google). También se admite la instalación completamente fuera de línea (offline) si los archivos requeridos se cargaron previamente en la carpeta `packages/binaries/`.

#### 🐧 Linux y 🍎 macOS
```bash
# Instalación a través de la red desde el repositorio de la bifurcación:
curl -fsSL https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/install.sh | bash

# O instalación fuera de línea desde un repositorio local:
git clone https://github.com/weby-homelab/antigravity-cli.git
cd antigravity-cli
# (Opcional: descargue los archivos de la plataforma en packages/binaries/)
make install
```

#### 🪟 Windows PowerShell
```powershell
# Instalación a través de la red:
irm https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/install.ps1 | iex

# O instalación fuera de línea desde un repositorio clonado:
.\install.ps1
```

#### 🪟 Windows CMD
```cmd
# Instalación a través de la red:
curl -fsSL https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/install.cmd -o install.cmd && install.cmd && del install.cmd

# O instalación fuera de línea desde un repositorio clonado:
install.cmd
```

---

## 📋 Características principales

> [!NOTE]
> A diferencia de la versión original, esta bifurcación está adaptada para un funcionamiento estable en sesiones sin interfaz gráfica (headless)/SSH y laboratorios domésticos locales.

*   📂 **Edición de archivos múltiples** — Edita varios archivos simultáneamente en su espacio de trabajo con confirmación previa de los cambios.
*   🔒 **Comandos de shell seguros** — Ejecuta cualquier comando de terminal en el contenedor Docker incorporado (entorno aislado/sandbox) o en el sistema host.
*   🧠 **Razonamiento de múltiples pasos (PAV)** — Construye de forma independiente un plan de ejecución de tareas, prueba el código y depura sus propios errores.
*   💾 **Historial de conversación persistente** — Guarda el contexto completo de la conversación y el estado del espacio de trabajo entre sesiones.
*   🔌 **Sistema de complementos** — Amplíe las capacidades del agente con *habilidades (Skills)* personalizadas y servidores MCP (Model Context Protocol).

---

## ⚙️ Configuración

### 1. Configuración del proyecto (`GEMINI.md`)
Cree un archivo `GEMINI.md` en la raíz de su proyecto para proporcionar un contexto específico y reglas de desarrollo al agente de IA:

```markdown
# Contexto del proyecto

- Este proyecto utiliza FastAPI y Pydantic v2.
- Utilice siempre `model_dump()` en lugar del obsoleto `dict()`.
- REGLA ESTRICTA: No use contraseñas hardcoded en el código. Importe todos los secretos desde `.env`.
```

### 2. Configuración global (`~/.gemini/antigravity-cli/settings.json`)
El archivo de configuración global controla los permisos de ejecución de herramientas, los scripts de statusline/título y los servidores MCP:

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
> Para obtener una línea de estado avanzada y adaptable con seguimiento de estado de Git en tiempo real, contadores de tokens, cuotas de modelos y estado de energía/batería, use el complemento **[Antigravity CLI Statusline (Max Edition)](https://github.com/weby-homelab/antigravity-cli-statusline)**.


### 3. Agentes especializados
Puede describir roles e instrucciones personalizados para agentes de IA en formato JSON. Cada agente debe tener su propio directorio que contenga un archivo `agent.json`:

- **Agentes Globales (Linux/Unix)**: `~/.gemini/antigravity-cli/agents/{agent_name}/agent.json`
- **Agentes Globales (macOS)**: `~/Library/Application Support/antigravity-cli/agents/{agent_name}/agent.json`
- **Agentes Globales (Windows)**: `%APPDATA%\antigravity-cli\agents\{agent_name}\agent.json`
- **Agentes Locales (Espacio de Trabajo)**: `{workspace_root}/.agents/agents/{agent_name}/agent.json`

```json
{
  "name": "security-reviewer",
  "description": "Analiza el código en busca de vulnerabilidades antes de confirmar",
  "instructions": "Buscar en los cambios:\n- Vulnerabilidades OWASP Top 10\n- Filtración de claves de API o secretos\n- Corrección de la configuración del firewall/nftables"
}
```

---

## 🔐 Métodos de autenticación

| Método | Comando / Variable | Limitaciones y características |
| :--- | :--- | :--- |
| **Autenticación de Google (Navegador)** | Automáticamente en el primer `agy` | Inicio de sesión estándar. Límite gratuito: 60 sol./min, 1000 sol./día |
| **Clave de API (Fuera de línea)** | `export GEMINI_API_KEY="X"` | Recomendado para servidores y automatización |
| **Vertex AI** | `export GOOGLE_GENAI_USE_VERTEXAI=true` | Nivel empresarial con la infraestructura en la nube de Google Cloud |
| **Cerrar sesión** | `/logout` | Borrado de tokens de sesión local |

---

## 🔧 Referencia de comandos

### Línea de comandos
```bash
agy                              # Iniciar una sesión interactiva
agy -p "Mensaje de petición"     # Ejecución única sin ingresar al chat
agy -c                           # Continuar la última conversación incompleta
agy --conversation <ID>          # Cargar una sesión por un ID específico
agy --sandbox                    # Ejecutar en un contenedor Docker aislado
agy update                       # Actualizar el binario a la última versión
agy plugin list                  # Listar los complementos instalados
```

### Comandos de barra diagonal (Slash Commands) en la interfaz de chat
*   `/help` — Ayuda sobre las herramientas disponibles.
*   `/settings` — Configuración interactiva de los ajustes.
*   `/usage` — Estadísticas de tokens utilizados y cuota.
*   `/diff` — Ver los cambios actuales no guardados en el proyecto.
*   `/statusline` — Configurar la visualización de la línea de estado del terminal.

---

## 🔄 Migración desde Gemini CLI

> [!WARNING]
> La interfaz de línea de comandos original Gemini CLI (`gemini`) dejará de admitir cuentas que no sean empresariales el **18 de junio de 2026**. Se requiere la migración a Antigravity CLI.

### Pasos para una transición rápida
1. Instale el nuevo cliente: `curl -fsSL https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/install.sh | bash`
2. Migre los archivos de configuración de agentes personalizados locales (por ejemplo, convierta agentes personalizados de YAML dentro de `~/.gemini/agents/` a archivos JSON en `~/.gemini/antigravity-cli/agents/{agent_name}/agent.json`).
3. Actualice las configuraciones de CI/CD en GitHub Actions, reemplazando las llamadas a `gemini` por `agy`.
4. Desinstale la biblioteca antigua: `npm uninstall -g @google/gemini-cli`

### Tabla de comparación

| Característica | Gemini CLI (Obsoleto) | Antigravity CLI (Moderno) |
| :--- | :--- | :--- |
| **Plataforma de desarrollo** | Node.js / TypeScript | Go (Binario compilado nativo) |
| **Nombre del comando** | `gemini` | `agy` |
| **Velocidad de inicio** | ~1.2s (inicio de Node.js) | **~0.05s (inicio nativo instantáneo)** |
| **Archivo de configuración** | `GEMINI.md` | `GEMINI.md` |
| **Actualización automática** | A través de `npm update` | Mecanismo de auto-actualización incorporado |
| **Estado del soporte** | ⛔ Fin de la vida útil (18 de junio de 2026) | ✅ Desarrollo activo (Upstream) |

---

## 📁 Estructura del repositorio

```
antigravity-cli/
├── install.sh           # Instalador para Linux/macOS (fuera de línea/en línea)
├── install.ps1          # Instalador para Windows PowerShell (fuera de línea/en línea)
├── install.cmd          # Instalador para Windows CMD
├── Makefile             # Destinos de automatización (make install/reinstall/uninstall)
├── GEMINI.md            # Plantilla de archivo de contexto del proyecto
├── packages/            # Distribución local fuera de línea
│   ├── manifests/       # Manifiestos de versión para todas las plataformas
│   └── binaries/        # (Creado manualmente para el modo fuera de línea)
└── CHANGELOG.md         # Registro de cambios y registro de lanzamientos
```

---

## 🤝 Contribuir y Comunidad

Este repositorio es una bifurcación comunitaria independiente del proyecto original [google-antigravity/antigravity-cli](https://github.com/google-antigravity/antigravity-cli).

**Nuestras mejoras:**
*   🌍 Soporte de localización en múltiples idiomas para documentos y guías.
*   📦 Autonomía: capacidad de instalación fuera de línea sin descargas de la API de Google.
*   🛠️ Conveniencia: se agregó `Makefile` para un ciclo de vida simplificado de la herramienta.
*   🛡️ Seguridad: corrección periódica de errores y mejoras en el entorno aislado (sandbox).

---

## 📜 Aviso legal y de marca registrada

*   **Enlaces oficiales**: [Repositorio de documentación oficial](https://github.com/google-antigravity/antigravity-cli) · [Código base oficial de la CLI](https://github.com/google-gemini/gemini-cli) · [Sitio web oficial](https://antigravity.google)
*   **Condiciones de uso**: [antigravity.google/terms](https://antigravity.google/terms) · [policies.google.com/privacy](https://policies.google.com/privacy)

> [!IMPORTANT]
> **Estado legal de la bifurcación:**
> Este repositorio es una copia independiente no comercial (Bifurcación de la comunidad) del cliente original. **No es** un producto oficial de Google LLC. Google LLC no se hace responsable del rendimiento, las modificaciones o la seguridad de esta bifurcación.
> 
> **Licencias y derechos de autor:**
> El software original se distribuye bajo la [Licencia Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0). Todo el código original es propiedad intelectual de **Copyright © 2025 Google LLC**.
> 
> **Uso de marcas registradas:**
> El nombre "Antigravity CLI" y los logotipos asociados se utilizan dentro de los límites del uso consuetudinario únicamente para describir el origen, la compatibilidad y el propósito funcional del software. Este proyecto no reclama la propiedad de ninguna marca registrada de Google LLC.
> 
> **Renuncia de garantía:**
> El software se proporciona "TAL CUAL", SIN GARANTÍAS DE NINGÚN TIPO, ya sean expresas o implícitas. Usted asume toda la responsabilidad y los riesgos asociados con su uso.

> [!CAUTION]
> Los agentes de codificación de IA funcionan de forma autónoma. Revise siempre con cuidado los bloques de diferencias (diff) y los comandos propuestos antes de confirmar la ejecución, especialmente cuando trabaje con archivos del sistema o la configuración del firewall.
