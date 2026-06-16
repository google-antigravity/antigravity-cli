<p align="center">
  <a href="README.md">English</a> | <a href="README-ZH.md">中文</a> | <a href="README-ES.md">Español</a> | <b>Français</b> | <a href="README-PT.md">Português</a> | <a href="README-UA.md">Українська</a> | <a href="README-DE.md">Deutsch</a>
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/agy-cli-demo.gif" alt="Antigravity CLI Logo" width="600" style="border-radius: 8px; box-shadow: 0 4px 20px rgba(0,0,0,0.25);" />
</p>

<h1 align="center">🚀 Antigravity CLI</h1>

<p align="center">
  <strong>Fork communautaire et version hors ligne renforcée de google-antigravity/antigravity-cli avec configuration automatique de la ligne d'état et du titre de la fenêtre</strong>
</p>

<p align="center">
  <a href="https://github.com/weby-homelab/antigravity-cli"><img src="https://img.shields.io/badge/fork-google--antigravity-8a2be2?style=for-the-badge&logo=github" alt="GitHub Fork" /></a>
  <a href="CHANGELOG.md"><img src="https://img.shields.io/badge/version-1.0.8-success?style=for-the-badge&logo=git" alt="Version" /></a>
  <a href="https://antigravity.google/terms"><img src="https://img.shields.io/badge/license-Apache--2.0-blue?style=for-the-badge" alt="License" /></a>
  <img src="https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows-lightgrey?style=for-the-badge" alt="Supported Platforms" />
</p>

<p align="center">
  🤖 <b>Agent de codage IA directement dans votre terminal</b>. Comprend le contexte de votre base de code, crée et modifie des fichiers, exécute des commandes sécurisées dans un bac à sable et résout des tâches architecturales complexes en un seul prompt.
</p>

---

## ⚡ Démarrage rapide

### Installation instantanée (Hors ligne d'abord & Sans dépendance)
Ce fork télécharge des fichiers binaires précompilés directement depuis les **GitHub Release Assets** (au lieu des serveurs de l'API Google). Une installation complètement hors ligne est également prise en charge si les archives requises ont été préalablement chargées dans le dossier `packages/binaries/`.

#### 🐧 Linux et 🍎 macOS
```bash
# Installation réseau à partir du dépôt du fork :
curl -fsSL https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/install.sh | bash

# OU installation hors ligne à partir d'un dépôt local :
git clone https://github.com/weby-homelab/antigravity-cli.git
cd antigravity-cli
# (Optionnel : téléchargez les archives de la plateforme dans packages/binaries/)
make install
```

#### 🪟 Windows PowerShell
```powershell
# Installation réseau :
irm https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/install.ps1 | iex

# OU installation hors ligne à partir d'un dépôt cloné :
.\install.ps1
```

#### 🪟 Windows CMD
```cmd
# Installation réseau :
curl -fsSL https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/install.cmd -o install.cmd && install.cmd && del install.cmd

# OU installation hors ligne à partir d'un dépôt cloné :
install.cmd
```

---

## 📋 Principales fonctionnalités

> [!NOTE]
> Contrairement à la version originale, ce fork est adapté pour un fonctionnement stable dans les sessions sans écran (headless)/SSH et les laboratoires locaux.

*   📂 **Édition multi-fichiers** — Modifie plusieurs fichiers simultanément dans votre espace de travail avec confirmation préalable des modifications.
*   🔒 **Commandes shell sécurisées** — Exécute toutes les commandes du terminal dans le conteneur Docker intégré (bac à sable/sandbox) ou sur le système hôte.
*   🧠 **Raisonnement en plusieurs étapes (PAV)** — Construit de manière indépendante un plan d'exécution des tâches, teste le code et débogue ses propres erreurs.
*   💾 **Historique persistant des conversations** — Enregistre le contexte complet de la conversation et l'état de l'espace de travail entre les sessions.
*   🔌 **Système de plug-ins** — Étendez les capacités de l'agent avec des *compétences (Skills)* personnalisées et des serveurs MCP (Model Context Protocol).

---

## ⚙️ Configuration

### 1. Configuration du projet (`GEMINI.md`)
Créez un fichier `GEMINI.md` à la racine de votre projet pour fournir un contexte spécifique et des règles de développement à l'agent IA :

```markdown
# Contexte du projet

- Ce projet utilise FastAPI et Pydantic v2.
- Utilisez toujours `model_dump()` à la place de la méthode obsolète `dict()`.
- RÈGLE STRICTE : Pas de mots de passe codés en dur dans le code. Importez tous les secrets depuis le fichier `.env`.
```

### 2. Paramètres globaux (`~/.gemini/antigravity-cli/settings.json`)
Le fichier de configuration globale contrôle les autorisations d'exécution des outils, les scripts de statusline/titre et les serveurs MCP :

- **Linux/Unix** : `~/.gemini/antigravity-cli/settings.json`
- **macOS** : `~/Library/Application Support/antigravity-cli/settings.json`
- **Windows** : `%APPDATA%\antigravity-cli\settings.json`

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
> Pour une ligne de statut avancée et réactive avec suivi du statut Git en temps réel, compteurs de jetons, quotas de modèles et état d'alimentation/batterie, utilisez le plugin **[Antigravity CLI Statusline (Max Edition)](https://github.com/weby-homelab/antigravity-cli-statusline)**.


### 3. Agents spécialisés
Vous pouvez décrire des rôles et des instructions personnalisés pour les agents IA au format JSON. Chaque agent doit avoir son propre répertoire contenant un fichier `agent.json` :

- **Agents Globaux (Linux/Unix)** : `~/.gemini/antigravity-cli/agents/{agent_name}/agent.json`
- **Agents Globaux (macOS)** : `~/Library/Application Support/antigravity-cli/agents/{agent_name}/agent.json`
- **Agents Globaux (Windows)** : `%APPDATA%\antigravity-cli\agents\{agent_name}\agent.json`
- **Agents Locaux (Espace de Travail)** : `{workspace_root}/.agents/agents/{agent_name}/agent.json`

```json
{
  "name": "security-reviewer",
  "description": "Analyse le code à la recherche de vulnérabilités avant le commit",
  "instructions": "Vérifier les modifications pour :\n- Les 10 vulnérabilités majeures de l'OWASP\n- Les fuites de clés API ou de secrets\n- L'exactitude de la configuration du pare-feu/nftables"
}
```

---

## 🔐 Méthodes d'authentification

| Méthode | Commande / Variable | Limites et fonctionnalités |
| :--- | :--- | :--- |
| **Authentification Google (Navigateur)** | Automatiquement lors du premier `agy` | Connexion standard. Limite gratuite : 60 requêtes/minute, 1000 requêtes/jour |
| **Clé API (Hors ligne)** | `export GEMINI_API_KEY="X"` | Recommandé pour les serveurs et l'automatisation |
| **Vertex AI** | `export GOOGLE_GENAI_USE_VERTEXAI=true` | Niveau entreprise avec l'infrastructure cloud Google Cloud |
| **Déconnexion** | `/logout` | Effacement des jetons de session locale |

---

## 🔧 Référence des commandes

### Ligne de commande
```bash
agy                              # Démarrer une session interactive
agy -p "Prompt"                  # Exécution unique sans entrer dans le chat
agy -c                           # Continuer la dernière conversation incomplète
agy --conversation <ID>          # Charger une session par un ID spécifique
agy --sandbox                    # Exécuter dans un conteneur Docker isolé
agy update                       # Mettre à jour le binaire vers la dernière version
agy plugin list                  # Lister les plug-ins installés
```

### Commandes slash dans l'interface de chat
*   `/help` — Aide sur les outils disponibles.
*   `/settings` — Configuration interactive des paramètres.
*   `/usage` — Statistiques des jetons consommés et quota.
*   `/diff` — Afficher les modifications actuelles non sauvegardées dans le projet.
*   `/statusline` — Configurer l'affichage de la ligne d'état du terminal.

---

## 🔄 Migration depuis Gemini CLI

> [!WARNING]
> L'interface de ligne de commande originale Gemini CLI (`gemini`) abandonnera le support pour les comptes non professionnels le **18 juin 2026**. La migration vers Antigravity CLI est requise.

### Étapes pour une transition rapide
1. Installez le nouveau client : `curl -fsSL https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/install.sh | bash`
2. Migrez les fichiers de configuration des agents personnalisés locaux (par exemple, convertissez les agents personnalisés de YAML dans `~/.gemini/agents/` en fichiers JSON sous `~/.gemini/antigravity-cli/agents/{agent_name}/agent.json`).
3. Mettez à jour les configurations CI/CD dans GitHub Actions, en remplaçant les appels `gemini` par `agy`.
4. Désinstallez l'ancienne bibliothèque : `npm uninstall -g @google/gemini-cli`

### Tableau comparatif

| Fonctionnalité | Gemini CLI (Obsolète) | Antigravity CLI (Moderne) |
| :--- | :--- | :--- |
| **Plateforme de développement** | Node.js / TypeScript | Go (Binaire natif compilé) |
| **Nom de la commande** | `gemini` | `agy` |
| **Vitesse de démarrage** | ~1.2s (démarrage Node.js) | **~0.05s (démarrage natif instantané)** |
| **Fichier de configuration** | `GEMINI.md` | `GEMINI.md` |
| **Mise à jour automatique** | Via `npm update` | Mécanisme d'auto-mise à jour intégré |
| **Statut du support** | ⛔ EOL (18 juin 2026) | ✅ Développement actif (Upstream) |

---

## 📁 Structure du dépôt

```
antigravity-cli/
├── install.sh           # Programme d'installation pour Linux/macOS (hors ligne/en ligne)
├── install.ps1          # Programme d'installation pour Windows PowerShell (hors ligne/en ligne)
├── install.cmd          # Programme d'installation pour Windows CMD
├── Makefile             # Cibles d'automatisation (make install/reinstall/uninstall)
├── GEMINI.md            # Modèle de fichier de contexte de projet
├── packages/            # Distribution hors ligne locale
│   ├── manifests/       # Manifestes de version pour toutes les plateformes
│   └── binaries/        # (Créé manuellement pour le mode hors ligne)
└── CHANGELOG.md         # Journal des modifications et des versions
```

---

## 🤝 Contribution & Communauté

Ce dépôt est un fork communautaire indépendant du projet original [google-antigravity/antigravity-cli](https://github.com/google-antigravity/antigravity-cli).

**Nos améliorations :**
*   🌍 Prise en charge de la localisation multilingue pour la documentation et les guides.
*   📦 Autonomie : capacité d'installation hors ligne sans téléchargements depuis les API Google.
*   🛠️ Praticité : ajout d'un `Makefile` pour un cycle de vie simplifié de l'outil.
*   🛡️ Sécurité : corrections régulières de bogues et améliorations de l'environnement de bac à sable.

---

## 📜 Avis légal & Propriété intellectuelle

*   **Liens officiels** : [Dépôt de documentation officiel](https://github.com/google-antigravity/antigravity-cli) · [Base de code officielle de la CLI](https://github.com/google-gemini/gemini-cli) · [Site officiel](https://antigravity.google)
*   **Conditions d'utilisation** : [antigravity.google/terms](https://antigravity.google/terms) · [policies.google.com/privacy](https://policies.google.com/privacy)

> [!IMPORTANT]
> **Statut juridique du fork :**
> Ce dépôt est une copie indépendante non commerciale (Community Fork) du client d'origine. Ce **n'est pas** un produit officiel de Google LLC. Google LLC n'est pas responsable des performances, des modifications ou de la sécurité de ce fork.
> 
> **Licences et droits d'auteur :**
> Le logiciel d'origine est distribué sous la [Licence Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0). Tout le code d'origine est la propriété intellectuelle de **Copyright © 2025 Google LLC**.
> 
> **Utilisation de la marque :**
> Le nom "Antigravity CLI" et les logos associés sont utilisés dans les limites de l'usage coutumier uniquement pour décrire l'origine, la compatibilité et le but fonctionnel du logiciel. Ce projet ne revendique aucun droit de propriété sur les marques de Google LLC.
> 
> **Exclusion de garantie :**
> Le logiciel est fourni "EN L'ÉTAT", SANS GARANTIE D'AUCUNE SORTE, expresse ou implicite. Vous assumez toute responsabilité et tous les risques associés à son utilisation.

> [!CAUTION]
> Les agents de codage IA fonctionnent de manière autonome. Examinez toujours attentivement les blocs de diff proposés et les commandes avant de confirmer l'exécution, en particulier lorsque vous travaillez avec des fichiers système ou la configuration du pare-feu.
