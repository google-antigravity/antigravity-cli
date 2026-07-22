<p align="center">
  <a href="README.md">English</a> | <a href="README-ZH.md">中文</a> | <a href="README-ES.md">Español</a> | <a href="README-FR.md">Français</a> | <a href="README-PT.md">Português</a> | <b>Українська</b> | <a href="README-DE.md">Deutsch</a>
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/agy-cli-demo.gif" alt="Antigravity CLI Logo" width="600" style="border-radius: 8px; box-shadow: 0 4px 20px rgba(0,0,0,0.25);" />
</p>

<h1 align="center">🚀 Antigravity CLI</h1>

<p align="center">
  <strong>Ком'юніті-форк та покращена офлайн-версія google-antigravity/antigravity-cli з автоналаштуванням статуслайну та заголовка вікна</strong>
</p>

<p align="center">
  <a href="https://github.com/weby-homelab/antigravity-cli"><img src="https://img.shields.io/badge/fork-google--antigravity-8a2be2?style=for-the-badge&logo=github" alt="GitHub Fork" /></a>
  <a href="CHANGELOG.md"><img src="https://img.shields.io/badge/version-1.1.5-success?style=for-the-badge&logo=git" alt="Version" /></a>
  <a href="https://antigravity.google/terms"><img src="https://img.shields.io/badge/license-Apache--2.0-blue?style=for-the-badge" alt="License" /></a>
  <img src="https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows-lightgrey?style=for-the-badge" alt="Supported Platforms" />
</p>

<p align="center">
  🤖 <b>ШІ-кодинг агент прямо у вашому терміналі</b>. Розуміє контекст вашої кодової бази, створює та редагує файли, виконує безпечні команди в пісочниці та вирішує комплексні архітектурні завдання за один промпт.
</p>

---

## ⚡ Швидкий старт

### Миттєве встановлення (Offline-first & Zero-dependency)
Цей форк завантажує попередньо скомпільовані бінарні файли прямо з **GitHub Release Assets** (замість серверів Google API). Також підтримується повністю автономне офлайн-встановлення, якщо потрібні архіви було попередньо завантажено в папку `packages/binaries/`.

#### 🐧 Linux та 🍎 macOS
```bash
# Мережеве встановлення з репозиторію форку:
curl -fsSL https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/install.sh | bash

# АБО автономне офлайн-встановлення з локального репозиторію:
git clone https://github.com/weby-homelab/antigravity-cli.git
cd antigravity-cli
# (Опціонально: завантажте архіви платформ у packages/binaries/)
make install
```

#### 🪟 Windows PowerShell
```powershell
# Мережеве встановлення:
irm https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/install.ps1 | iex

# АБО офлайн-встановлення з клонованого репозиторію:
.\install.ps1
```

#### 🪟 Windows CMD
```cmd
# Мережеве встановлення:
curl -fsSL https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/install.cmd -o install.cmd && install.cmd && del install.cmd

# АБО офлайн-встановлення з клонованого репозиторію:
install.cmd
```

---

## 📋 Основні можливості

> [!NOTE]
> На відміну від оригінальної версії, цей форк адаптований для стабільної роботи в headless/SSH-сесіях та локальних home-лабораторіях.

*   📂 **Мультифайлове редагування** — Редагує декілька файлів одночасно у вашому робочому просторі з попереднім підтвердженням змін.
*   🔒 **Безпечні Shell-команди** — Виконує будь-які термінальні команди у вбудованому Docker-контейнері (пісочниці) або на хост-системі.
*   🧠 **Багатокрокові міркування (PAV)** — Самостійно будує план виконання завдання, тестує код і виправляє власні помилки.
*   💾 **Постійна історія розмов** — Зберігає повний контекст розмови та стан робочого простору між сесіями.
*   🔌 **Система плагінів** — Розширюйте можливості агента за допомогою кастомних *Skills* та MCP-серверів (Model Context Protocol).

---

## ⚙️ Конфігурація

### 1. Конфігурація проєкту (`GEMINI.md`)
Створіть файл `GEMINI.md` у корені вашого проєкту, щоб передати ШІ-агенту специфічний контекст та правила розробки:

```markdown
# Контекст проєкту

- Цей проєкт використовує FastAPI та Pydantic v2.
- Завжди використовуйте `model_dump()` замість застарілого `dict()`.
- СУВОРЕ ПРАВИЛО: Жодних хардкод-паролів у коді. Всі секрети імпортувати з `.env`.
```

### 2. Глобальні налаштування (`~/.gemini/antigravity-cli/settings.json`)
Глобальний файл налаштувань керує дозволами на виконання інструментів, скриптами статуслайну/заголовка та MCP-серверами:

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
> Для отримання просунутого та адаптивного статус-бару з відстеженням Git-статусу в реальному часі, лічильником токенів, квотами моделей та станом живлення/батареї, скористайтеся плагіном **[Antigravity CLI Statusline (Max Edition)](https://github.com/weby-homelab/antigravity-cli-statusline)**.


### 3. Спеціалізовані агенти
Ви можете описувати кастомні ролі та інструкції для ШІ-агентів у форматі JSON. Кожен агент повинен мати власну директорію, яка містить файл `agent.json`:

- **Глобальні агенти (Linux/Unix)**: `~/.gemini/antigravity-cli/agents/{agent_name}/agent.json`
- **Глобальні агенти (macOS)**: `~/Library/Application Support/antigravity-cli/agents/{agent_name}/agent.json`
- **Глобальні агенти (Windows)**: `%APPDATA%\antigravity-cli\agents\{agent_name}\agent.json`
- **Локальні агенти (Робочий простір)**: `{workspace_root}/.agents/agents/{agent_name}/agent.json`

```json
{
  "name": "security-reviewer",
  "description": "Аналізує код на вразливості перед комітом",
  "instructions": "Перевіряти зміни на:\n- OWASP Top 10 вразливості\n- Витік API ключів чи секретів\n- Правильність налаштування firewall/nftables"
}
```

---

## 🔐 Способи авторизації

| Метод | Команда / Змінна | Обмеження та особливості |
| :--- | :--- | :--- |
| **Google Auth (Browser)** | Автоматично при першому `agy` | Стандартний вхід. Безкоштовний ліміт: 60 з/хв, 1000 з/добу |
| **API Key (Offline)** | `export GEMINI_API_KEY="X"` | Рекомендовано для серверів та автоматизації |
| **Vertex AI** | `export GOOGLE_GENAI_USE_VERTEXAI=true` | Enterprise-рівень з хмарною інфраструктурою Google Cloud |
| **Вихід з профілю** | `/logout` | Очищення локальних токенів сесії |

---

## 🔧 Довідка команд

### Командний рядок
```bash
agy                              # Запустити інтерактивну сесію
agy -p "Запит"                   # Одноразове виконання без входу в чат
agy -c                           # Продовжити останню незавершену розмову
agy --conversation <ID>          # Завантажити сесію за конкретним ідентифікатором
agy --sandbox                    # Запустити в ізольованому Docker-контейнері
agy update                       # Оновити бінарний файл до останньої версії
agy plugin list                  # Список встановлених плагінів
```

### Slash-команди в інтерфейсі чату
*   `/help` — Довідка з доступних інструментів.
*   `/settings` — Інтерактивне налаштування параметрів.
*   `/usage` — Статистика витрачених токенів та квоти.
*   `/diff` — Перегляд поточних незбережених змін у проєкті.
*   `/statusline` — Налаштування відображення статус-бару терміналу.

---

## 🔄 Злиття та міграція з Gemini CLI

> [!WARNING]
> Оригінальний Gemini CLI (`gemini`) припиняє підтримку для non-enterprise акаунтів **18 червня 2026**. Перехід на Antigravity CLI є обов'язковим.

### Кроки для швидкого переходу
1. Встановіть новий клієнт: `curl -fsSL https://raw.githubusercontent.com/weby-homelab/antigravity-cli/main/install.sh | bash`
2. Мігруйте локальні файли конфігурації кастомних агентів (наприклад, конвертуйте конфігурації YAML у папці `~/.gemini/agents/` в JSON-файли за шляхом `~/.gemini/antigravity-cli/agents/{agent_name}/agent.json`).
3. Оновіть CI/CD конфігурації в GitHub Actions, замінивши виклики `gemini` на `agy`.
4. Видаліть стару бібліотеку: `npm uninstall -g @google/gemini-cli`

### Порівняльна таблиця

| Характеристика | Gemini CLI (Застарілий) | Antigravity CLI (Сучасний) |
| :--- | :--- | :--- |
| **Платформа розробки** | Node.js / TypeScript | Go (Native Compiled Binary) |
| **Назва команди** | `gemini` | `agy` |
| **Швидкість старту** | ~1.2 сек (запуск Node.js) | **~0.05 сек (миттєвий нативний старт)** |
| **Файл конфігурації** | `GEMINI.md` | `GEMINI.md` |
| **Авто-оновлення** | Через `npm update` | Вбудований механізм self-update |
| **Статус підтримки** | ⛔ EOL (18.06.2026) | ✅ Активна розробка (Upstream) |

---

## 📁 Структура репозиторію

```
antigravity-cli/
├── install.sh           # Інсталятор для Linux/macOS (офлайн/онлайн)
├── install.ps1          # Інсталятор для Windows PowerShell (офлайн/онлайн)
├── install.cmd          # Інсталятор для Windows CMD
├── Makefile             # Автоматизовані цілі (make install/reinstall/uninstall)
├── GEMINI.md            # Шаблон файлу контексту проєкту
├── packages/            # Локальний офлайн-дистрибутив
│   ├── manifests/       # Маніфести версій для всіх платформ
│   └── binaries/        # (Створюється вручну для офлайн-режиму)
└── CHANGELOG.md         # Журнал версій та релізів
```

---

## 🤝 Спільнота та розробка (Contributing)

Цей репозиторій є незалежним ком'юніті-форком оригінального проєкту [google-antigravity/antigravity-cli](https://github.com/google-antigravity/antigravity-cli).

**Наші покращення:**
*   🇺🇦 Повна українська локалізація документації та гайдів.
*   📦 Автономність: можливість офлайн-встановлення без завантажень з Google API.
*   🛠️ Зручність: додано `Makefile` для спрощеного життєвого циклу інструменту.
*   🛡️ Безпека: регулярні баг-фікси та покращення роботи в пісочниці (сандбоксі).

---

## 📜 Юридичний статус та дисклеймер (Legal & Trademark Notice)

*   **Офіційні посилання**: [Офіційний репозиторій документації](https://github.com/google-antigravity/antigravity-cli) · [Офіційна кодова база CLI](https://github.com/google-gemini/gemini-cli) · [Офіційний сайт](https://antigravity.google)
*   **Правила використання**: [antigravity.google/terms](https://antigravity.google/terms) · [policies.google.com/privacy](https://policies.google.com/privacy)

> [!IMPORTANT]
> **Правовий статус форку:**
> Цей репозиторій є незалежною некомерційною копією (Community Fork) оригінального клієнта. Він **не є** офіційним продуктом компанії Google LLC. Google LLC не несе відповідальності за працездатність, модифікації або безпеку цього форку.
> 
> **Ліцензування та авторські права:**
> Оригінальне програмне забезпечення розповсюджується під ліцензією [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0). Весь оригінальний код є інтелектуальною власністю **Copyright © 2025 Google LLC**.
> 
> **Використання торгових марок:**
> Назва "Antigravity CLI" та пов'язані логотипи використовуються в межах дозволеного використання (Customary Use) виключно для опису походження, сумісності та функціонального призначення програмного забезпечення. Цей проєкт не претендує на володіння будь-якими торговими марками Google LLC.
> 
> **Обмеження відповідальності (Disclaimer of Warranty):**
> Програмне забезпечення надається на умовах «ЯК Є» (AS IS), БЕЗ БУДЬ-ЯКИХ ГАРАНТІЙ, явних чи неявних. Ви берете на себе всю відповідальність та ризики, пов'язані з його використанням.

> [!CAUTION]
> ШІ-агенти для кодування працюють автономно. Завжди уважно перевіряйте пропоновані diff-блоки та команди перед підтвердженням виконання, особливо при роботі з системними файлами чи конфігурацією фаєрволу.
