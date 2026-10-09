# Antigravity CLI

**Sprachen / Languages:** [English](./README.md) · [中文](./README-ZH.md) · [Español](./README-ES.md) · [Français](./README-FR.md) · [Português](./README-PT.md) · [Русский](./README-RU.md) · [Deutsch](./README-DE.md)

Antigravity CLI versteht Ihre Codebasis, nimmt mit Ihrer Erlaubnis Änderungen vor und führt Befehle aus — direkt aus Ihrem Terminal.

- **Offizielle Dokumentation**: [antigravity.google/docs/cli-overview](https://antigravity.google/docs/cli-overview)
- **Offizielle Website**: [antigravity.google/product/antigravity-cli](https://antigravity.google/product/antigravity-cli)

![Antigravity CLI Demo](agy-cli-demo.gif)

---

Antigravity CLI bringt die Kernfunktionen von Antigravity 2.0 (mehrstufiges Reasoning, Multi-Datei-Bearbeitung, Tool-Aufrufe und persistente Historie) direkt in Ihr Terminal. Optimiert für tastaturgesteuerte Workflows und Remote-SSH-Sitzungen mit minimalem Ressourcenverbrauch.

---

## Funktionen auf einen Blick

| Funktion | Antigravity CLI | Antigravity 2.0 |
| :--- | :--- | :--- |
| **Hauptfokus** | Geschwindigkeit, Tastatureffizienz, geringer Overhead | Umfassendheit, visuelle Orchestrierung, Projektmanagement |
| **Oberfläche** | Terminal-Benutzeroberfläche (TUI) | Vollständige GUI-Anwendung |
| **Workflows** | SSH/Remote-Sitzungen, Tastatur zuerst | Lokale Arbeitsbereiche, intensive Orchestrierung |
| **Agent-Engine** | Gemeinsame zentrale Agent-Engine | Gemeinsame zentrale Agent-Engine |

---

## Integration

- **Gemeinsame Agent-Engine**: Beide Oberflächen laufen auf derselben zentralen Agent-Engine. Verbesserungen gelten automatisch für beide.
- **Gemeinsame Einstellungen**: Präferenzen und Berechtigungen synchronisieren sich bidirektional.
- **Sitzungsexport**: Exportieren Sie Terminal-Sitzungen in die Antigravity 2.0 GUI, um weiterzuarbeiten.

---

## Installation

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

## Authentifizierung

Die CLI authentifiziert sich über den System-Keyring, mit Fallback auf Google Sign-In, wenn keine aktive Sitzung existiert.

- **Lokal**: Öffnet automatisch Ihren Standardbrowser.
- **Remote / SSH**: Erkennt SSH-Sitzungen und gibt eine Autorisierungs-URL aus, um die Anmeldung lokal abzuschließen.
- **Abmelden**: Führen Sie `/logout` aus, um gespeicherte Anmeldedaten zu löschen.

> [!NOTE]
> Für Unternehmenszugang verbinden Sie Ihr GCP-Projekt während des Onboardings. Details finden Sie auf der Enterprise-Seite.

---

## Nutzungsbedingungen und Datennutzung

> [!WARNING]
> KI-Coding-Agenten haben bekannte Sicherheitsrisiken, einschließlich autonomer Codeausführung, Datenexfiltration, Prompt-Injection und Lieferkettenrisiken. Stellen Sie sicher, dass Sie alle vom Agenten durchgeführten Aktionen überwachen und verifizieren.

Durch die Nutzung von Antigravity CLI stimmen Sie zu, das Produkt zu verbessern, indem Sie Google erlauben, Ihre Interaktionsdaten gemäß den Google-Nutzungsbedingungen und der Google-Datenschutzrichtlinie zu erfassen und zu verwenden. Sie können sich jederzeit in den Einstellungen abmelden.

### Rechtliche Links und Datenschutz

- **Nutzungsbedingungen**: [antigravity.google/terms](https://antigravity.google/terms)
- **Datenschutzrichtlinie**: [policies.google.com/privacy](https://policies.google.com/privacy)
