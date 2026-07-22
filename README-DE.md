<p align="center">
  <a href="README.md">English</a> | <a href="README-ZH.md">中文</a> | <a href="README-ES.md">Español</a> | <a href="README-FR.md">Français</a> | <a href="README-PT.md">Português</a> | <a href="README-UA.md">Українська</a> | <b>Deutsch</b>
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/agy-cli-demo.gif" alt="Antigravity CLI Logo" width="600" style="border-radius: 8px; box-shadow: 0 4px 20px rgba(0,0,0,0.25);" />
</p>

<h1 align="center">🚀 Antigravity CLI</h1>

<p align="center">
  <strong>Community-Fork & gehärtete Offline-Version von google-antigravity/antigravity-cli mit automatischer Konfiguration von Statuszeile und Fenstertitel</strong>
</p>

<p align="center">
  <a href="https://github.com/weby-homelab/antigravity-cli"><img src="https://img.shields.io/badge/fork-google--antigravity-8a2be2?style=for-the-badge&logo=github" alt="GitHub Fork" /></a>
  <a href="CHANGELOG.md"><img src="https://img.shields.io/badge/version-1.1.0-success?style=for-the-badge&logo=git" alt="Version" /></a>
  <a href="https://antigravity.google/terms"><img src="https://img.shields.io/badge/license-Apache--2.0-blue?style=for-the-badge" alt="License" /></a>
  <img src="https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows-lightgrey?style=for-the-badge" alt="Supported Platforms" />
</p>

<p align="center">
  🤖 <b>KI-Codierungsagent direkt in Ihrem Terminal</b>. Versteht den Kontext Ihrer Codebasis, erstellt und bearbeitet Dateien, führt sichere Befehle in einer Sandbox aus und löst komplexe architektonische Aufgaben mit einem einzigen Prompt.
</p>

---

## ⚡ Schnellstart

### Sofortige Installation (Offline-first & Zero-dependency)
Dieser Fork lädt vorkompilierte Binärdateien direkt aus den **GitHub Release Assets** herunter (anstatt von Google-API-Servern). Eine vollständig autonome Offline-Installation wird ebenfalls unterstützt, wenn die erforderlichen Archive zuvor in den Ordner `packages/binaries/` heruntergeladen wurden.

#### 🐧 Linux und 🍎 macOS
```bash
# Netzwerkinstallation aus dem Fork-Repository:
curl -fsSL https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/install.sh | bash

# ODER Offline-Installation aus einem lokalen Repository:
git clone https://github.com/weby-homelab/antigravity-cli.git
cd antigravity-cli
# (Optional: Laden Sie Plattform-Archive nach packages/binaries/ herunter)
make install
```

#### 🪟 Windows PowerShell
```powershell
# Netzwerkinstallation:
irm https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/install.ps1 | iex

# ODER Offline-Installation aus einem geklonten Repository:
.\install.ps1
```

#### 🪟 Windows CMD
```cmd
# Netzwerkinstallation:
curl -fsSL https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/install.cmd -o install.cmd && install.cmd && del install.cmd

# ODER Offline-Installation aus einem geklonten Repository:
install.cmd
```

---

## 📋 Hauptfunktionen

> [!NOTE]
> Im Gegensatz zur Originalversion ist dieser Fork für den stabilen Betrieb in Headless-/SSH-Sitzungen und lokalen Home-Labs angepasst.

*   📂 **Bearbeitung mehrerer Dateien** — Bearbeitet mehrere Dateien gleichzeitig in Ihrem Arbeitsbereich mit vorheriger Bestätigung der Änderungen.
*   🔒 **Sichere Shell-Befehle** — Führt beliebige Terminalbefehle im integrierten Docker-Container (Sandbox) oder auf dem Hostsystem aus.
*   🧠 **Mehrstufiges Denken (PAV)** — Erstellt selbstständig einen Plan zur Aufgabenausführung, testet Code und behebt eigene Fehler.
*   💾 **Persistenter Konversationsverlauf** — Speichert den vollständigen Konversationskontext und den Zustand des Arbeitsbereichs zwischen den Sitzungen.
*   🔌 **Plugin-System** — Erweitern Sie die Fähigkeiten des Agenten mit benutzerdefinierten *Skills* und MCP-Servern (Model Context Protocol).

---

## ⚙️ Konfiguration

### 1. Projektkonfiguration (`GEMINI.md`)
Erstellen Sie eine `GEMINI.md`-Datei im Stammverzeichnis Ihres Projekts, um dem KI-Agenten spezifischen Kontext und Entwicklungsregeln bereitzustellen:

```markdown
# Projektkontext

- Dieses Projekt verwendet FastAPI und Pydantic v2.
- Verwenden Sie immer `model_dump()` anstelle des veralteten `dict()`.
- STRIKTE REGEL: Keine fest codierten Passwörter im Code. Importieren Sie alle Geheimnisse aus `.env`.
```

### 2. Globale Einstellungen (`~/.gemini/antigravity-cli/settings.json`)
Die globale Einstellungsdatei steuert Berechtigungen zur Tool-Ausführung, Statuszeilen-/Titel-Skripte und MCP-Server:

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
> Für eine erweiterte, reaktionsschnelle Statuszeile mit Echtzeit-Git-Status, Token-Zählern, Modellquoten und Strom-/Batteriestatus verwenden Sie das Plugin **[Antigravity CLI Statusline (Max Edition)](https://github.com/weby-homelab/antigravity-cli-statusline)**.


### 3. Spezialisierte Agenten
Sie können benutzerdefinierte Rollen und Anweisungen für KI-Agenten im JSON-Format beschreiben. Jeder Agent muss sein eigenes Verzeichnis haben, das eine `agent.json`-Datei enthält:

- **Globale Agenten (Linux/Unix)**: `~/.gemini/antigravity-cli/agents/{agent_name}/agent.json`
- **Globale Agenten (macOS)**: `~/Library/Application Support/antigravity-cli/agents/{agent_name}/agent.json`
- **Globale Agenten (Windows)**: `%APPDATA%\antigravity-cli\agents\{agent_name}\agent.json`
- **Lokale Agenten (Projektarbeitsbereich)**: `{workspace_root}/.agents/agents/{agent_name}/agent.json`

```json
{
  "name": "security-reviewer",
  "description": "Analysiert Code vor dem Commit auf Schwachstellen",
  "instructions": "Änderungen überprüfen auf:\n- OWASP Top 10 Schwachstellen\n- Durchsickern von API-Schlüsseln oder Geheimnissen\n- Richtigkeit der Firewall-/nftables-Konfiguration"
}
```

---

## 🔐 Authentifizierungsmethoden

| Methode | Befehl / Variable | Einschränkungen & Funktionen |
| :--- | :--- | :--- |
| **Google Auth (Browser)** | Automatisch bei der ersten Ausführung von `agy` | Standard-Login. Kostenloses Limit: 60 Anfr./Min., 1000 Anfr./Tag |
| **API-Schlüssel (Offline)** | `export GEMINI_API_KEY="X"` | Empfohlen für Server und Automatisierung |
| **Vertex AI** | `export GOOGLE_GENAI_USE_VERTEXAI=true` | Enterprise-Level mit Google Cloud Cloud-Infrastruktur |
| **Abmelden** | `/logout` | Löschen lokaler Sitzungstoken |

---

## 🔧 Befehlsreferenz

### Befehlszeile
```bash
agy                              # Eine interaktive Sitzung starten
agy -p "Prompt"                  # Einmalige Ausführung ohne Chat-Eingabe
agy -c                           # Letzte unvollständige Konversation fortsetzen
agy --conversation <ID>          # Sitzung mit einer bestimmten ID laden
agy --sandbox                    # In einem isolierten Docker-Container ausführen
agy update                       # Binärdatei auf die neueste Version aktualisieren
agy plugin list                  # Installierte Plugins auflisten
```

### Slash-Befehle in der Chat-Schnittstelle
*   `/help` — Hilfe zu verfügbaren Tools.
*   `/settings` — Interaktive Konfiguration der Einstellungen.
*   `/usage` — Statistik der verbrauchten Token und des Kontingents.
*   `/diff` — Aktuelle ungespeicherte Änderungen im Projekt anzeigen.
*   `/statusline` — Anzeige der Terminal-Statuszeile konfigurieren.

---

## 🔄 Migration von Gemini CLI

> [!WARNING]
> Das ursprüngliche Gemini CLI (`gemini`) stellt die Unterstützung für Nicht-Unternehmenskonten am **18. Juni 2026** ein. Die Migration zu Antigravity CLI ist erforderlich.

### Schritte für einen schnellen Übergang
1. Installieren Sie den neuen Client: `curl -fsSL https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/install.sh | bash`
2. Migrieren Sie lokale benutzerdefinierte Agentenkonfigurationsdateien (konvertieren Sie z. B. benutzerdefinierte Agenten von YAML in `~/.gemini/agents/` in JSON-Dateien unter `~/.gemini/antigravity-cli/agents/{agent_name}/agent.json`).
3. Aktualisieren Sie CI/CD-Konfigurationen in GitHub Actions und ersetzen Sie `gemini`-Aufrufe durch `agy`.
4. Deinstallieren Sie die alte Bibliothek: `npm uninstall -g @google/gemini-cli`

### Vergleichstabelle

| Funktion | Gemini CLI (Veraltet) | Antigravity CLI (Modern) |
| :--- | :--- | :--- |
| **Entwicklungsplattform** | Node.js / TypeScript | Go (Nativ kompilierte Binärdatei) |
| **Befehlsname** | `gemini` | `agy` |
| **Startgeschwindigkeit** | ~1.2s (Node.js-Start) | **~0.05s (sofortiger nativer Start)** |
| **Konfigurationsdatei** | `GEMINI.md` | `GEMINI.md` |
| **Automatische Aktualisierung** | Über `npm update` | Integrierter Selbstaktualisierungsmechanismus |
| **Support-Status** | ⛔ EOL (18. Juni 2026) | ✅ Aktive Entwicklung (Upstream) |

---

## 📁 Repository-Struktur

```
antigravity-cli/
├── install.sh           # Installer für Linux/macOS (offline/online)
├── install.ps1          # Installer für Windows PowerShell (offline/online)
├── install.cmd          # Installer für Windows CMD
├── Makefile             # Automatisierungsziele (make install/reinstall/uninstall)
├── GEMINI.md            # Projektkontext-Dateivorlage
├── packages/            # Lokaler Offline-Vertrieb
│   ├── manifests/       # Versionsmanifeste für alle Plattformen
│   └── binaries/        # (Manuell erstellt für den Offline-Modus)
└── CHANGELOG.md         # Changelog und Release-Protokoll
```

---

## 🤝 Mitwirken & Community

Dieses Repository ist ein unabhängiger Community-Fork des ursprünglichen Projekts [google-antigravity/antigravity-cli](https://github.com/google-antigravity/antigravity-cli).

**Unsere Verbesserungen:**
*   🌍 Mehrsprachige Lokalisierungsunterstützung für Dokumente und Anleitungen.
*   📦 Autonomie: Offline-Installationsmöglichkeit ohne Google-API-Downloads.
*   🛠️ Komfort: `Makefile` für einen vereinfachten Lebenszyklus des Tools hinzugefügt.
*   🛡️ Sicherheit: Regelmäßige Fehlerbehebungen und Verbesserungen an der Sandbox-Umgebung.

---

## 📜 Rechtlicher Hinweis & Markenrecht

*   **Offizielle Links**: [Offizielles Dokumentations-Repo](https://github.com/google-antigravity/antigravity-cli) · [Offizielle CLI-Codebasis](https://github.com/google-gemini/gemini-cli) · [Offizielle Website](https://antigravity.google)
*   **Nutzungsbedingungen**: [antigravity.google/terms](https://antigravity.google/terms) · [policies.google.com/privacy](https://policies.google.com/privacy)

> [!IMPORTANT]
> **Rechtlicher Status des Forks:**
> Dieses Repository ist eine unabhängige, nicht-kommerzielle Kopie (Community Fork) des Original-Clients. Es **ist kein** offizielles Produkt von Google LLC. Google LLC is nicht verantwortlich für die Leistung, Änderungen oder Sicherheit dieses Forks.
> 
> **Lizenzierung & Urheberrechte:**
> Die Original-Software wird unter der [Apache-Lizenz 2.0](https://www.apache.org/licenses/LICENSE-2.0) verbreitet. Der gesamte Originalcode ist das geistige Eigentum von **Copyright © 2025 Google LLC**.
> 
> **Markennutzung:**
> Der Name "Antigravity CLI" und die zugehörigen Logos werden im Rahmen der üblichen Nutzung ausschließlich zur Beschreibung der Herkunft, Kompatibilität und des funktionalen Zwecks der Software verwendet. Dieses Projekt erhebt keinen Anspruch auf Eigentumsrechte an Marken von Google LLC.
> 
> **Gewährleistungsausschluss:**
> Die Software wird "WIE BESEHEN" bereitgestellt, OHNE GEWÄHRLEISTUNGEN JEGLICHER ART, weder ausdrücklich noch stillschweigend. Sie übernehmen die gesamte Verantwortung und alle Risiken im Zusammenhang mit ihrer Verwendung.

> [!CAUTION]
> KI-Codierungsagenten arbeiten autonom. Überprüfen Sie die vorgeschlagenen Diff-Blöcke und Befehle immer sorgfältig, bevor Sie die Ausführung bestätigen, insbesondere wenn Sie mit Systemdateien oder der Firewall-Konfiguration arbeiten.
