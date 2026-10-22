# Antigravity CLI

**Langues / Languages:** [English](./README.md) · [中文](./README-ZH.md) · [Español](./README-ES.md) · [Français](./README-FR.md) · [Português](./README-PT.md) · [Русский](./README-RU.md) · [Deutsch](./README-DE.md)

Antigravity CLI comprend votre base de code, effectue des modifications avec votre permission et exécute des commandes — directement depuis votre terminal.

- **Documentation officielle** : [antigravity.google/docs/cli-overview](https://antigravity.google/docs/cli-overview)
- **Site officiel** : [antigravity.google/product/antigravity-cli](https://antigravity.google/product/antigravity-cli)

![Antigravity CLI Demo](agy-cli-demo.gif)

---

Antigravity CLI apporte les capacités principales d'Antigravity 2.0 (raisonnement en plusieurs étapes, édition multi-fichiers, appels d'outils et historique persistant) directement dans votre terminal. Il est optimisé pour les flux de travail au clavier et les sessions SSH distantes avec une consommation minimale de ressources.

---

## Fonctionnalités en un coup d'œil

| Fonctionnalité | Antigravity CLI | Antigravity 2.0 |
| :--- | :--- | :--- |
| **Focus principal** | Vitesse, efficacité clavier, faible consommation | Exhaustivité, orchestration visuelle, gestion de projet |
| **Interface** | Interface utilisateur terminal (TUI) | Application GUI complète |
| **Flux de travail** | Sessions SSH/distantes, clavier d'abord | Espaces de travail locaux, orchestration intensive |
| **Moteur d'agents** | Moteur d'agents central partagé | Moteur d'agents central partagé |

---

## Intégration

- **Moteur d'agents partagé** : Les deux interfaces fonctionnent sur le même moteur d'agents central. Les améliorations s'appliquent automatiquement aux deux.
- **Paramètres partagés** : Préférences et permissions synchronisées bidirectionnellement.
- **Export de sessions** : Exportez les sessions terminal vers la GUI Antigravity 2.0 pour continuer à travailler.

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

## Authentification

La CLI s'authentifie via le trousseau système, avec repli sur Google Sign-In si aucune session active n'existe.

- **Local** : Ouvre automatiquement votre navigateur par défaut.
- **Distant / SSH** : Détecte les sessions SSH et affiche une URL d'autorisation pour terminer la connexion localement.
- **Déconnexion** : Exécutez `/logout` pour effacer les identifiants enregistrés.

> [!NOTE]
> Pour l'accès entreprise, connectez votre projet GCP lors de l'onboarding. Consultez la page Enterprise pour plus de détails.

---

## Conditions d'utilisation et données

> [!WARNING]
> Les agents de codage IA présentent des risques de sécurité connus, notamment l'exécution autonome de code, l'exfiltration de données, l'injection de prompts et les risques de la chaîne d'approvisionnement. Assurez-vous de surveiller et vérifier toutes les actions effectuées par l'agent.

En utilisant Antigravity CLI, vous acceptez d'aider à améliorer le produit en autorisant Google à collecter et utiliser vos données d'interaction, conformément aux Conditions d'utilisation Google et à la Politique de confidentialité Google. Vous pouvez vous désinscrire à tout moment via vos paramètres.

### Liens juridiques et confidentialité

- **Conditions d'utilisation** : [antigravity.google/terms](https://antigravity.google/terms)
- **Politique de confidentialité** : [policies.google.com/privacy](https://policies.google.com/privacy)
