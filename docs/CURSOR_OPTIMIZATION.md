# 🚀 Оптимизация Cursor для максимальной эффективности

Полное руководство по настройке Cursor для достижения точных результатов с максимальной автоматизацией.

---

## 📋 Содержание

1. [Настройки Cursor](#настройки-cursor)
2. [Файл .cursorrules](#файл-cursorrules)
3. [Оптимизация промптов](#оптимизация-промптов)
4. [Автоматизация через Tasks](#автоматизация-через-tasks)
5. [Snippets и шаблоны](#snippets-и-шаблоны)
6. [Расширения и интеграции](#расширения-и-интеграции)
7. [Best Practices для работы с AI](#best-practices-для-работы-с-ai)
8. [Автоматизация тестирования](#автоматизация-тестирования)
9. [Мониторинг и метрики](#мониторинг-и-метрики)

---

## ⚙️ Настройки Cursor

### 1. Settings.json (Cursor)

Создайте или обновите файл настроек Cursor:

**Windows:** `%APPDATA%\Cursor\User\settings.json`  
**macOS:** `~/Library/Application Support/Cursor/User/settings.json`  
**Linux:** `~/.config/Cursor/User/settings.json`

```json
{
  // AI настройки
  "cursor.aiModel": "claude-3.5-sonnet",
  "cursor.enableAutoComplete": true,
  "cursor.enableInlineCompletion": true,
  "cursor.maxTokens": 8192,
  "cursor.temperature": 0.2,
  
  // Автодополнение
  "editor.inlineSuggest.enabled": true,
  "editor.suggestSelection": "first",
  "editor.acceptSuggestionOnCommitCharacter": true,
  
  // Контекст для AI
  "cursor.includeWorkspaceFiles": true,
  "cursor.maxContextFiles": 50,
  "cursor.includeGitIgnore": false,
  
  // Автоматизация
  "cursor.autoSave": "afterDelay",
  "cursor.autoSaveDelay": 1000,
  "files.autoSave": "afterDelay",
  
  // Форматирование
  "editor.formatOnSave": true,
  "editor.formatOnPaste": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": "explicit",
    "source.organizeImports": "explicit"
  },
  
  // TypeScript/JavaScript
  "typescript.updateImportsOnFileMove.enabled": "always",
  "javascript.updateImportsOnFileMove.enabled": "always",
  "typescript.preferences.importModuleSpecifier": "relative",
  
  // Dart/Flutter
  "dart.enableSdkFormatter": true,
  "dart.lineLength": 100,
  "dart.previewFlutterUiGuides": true,
  
  // Git
  "git.enableSmartCommit": true,
  "git.confirmSync": false,
  "git.autofetch": true,
  
  // Файлы
  "files.exclude": {
    "**/.git": true,
    "**/.DS_Store": true,
    "**/node_modules": true,
    "**/.dart_tool": true,
    "**/build": true
  },
  
  // Поиск
  "search.exclude": {
    "**/node_modules": true,
    "**/build": true,
    "**/.dart_tool": true,
    "**/coverage": true
  }
}
```

### 2. Ключевые настройки для точности

```json
{
  // Низкая температура = более точные и предсказуемые ответы
  "cursor.temperature": 0.2,
  
  // Больше контекста = лучше понимание проекта
  "cursor.maxContextFiles": 50,
  
  // Включить все файлы проекта в контекст
  "cursor.includeWorkspaceFiles": true
}
```

---

## 📝 Файл .cursorrules

Файл `.cursorrules` в корне проекта помогает AI понимать специфику вашего проекта.

**Создан:** `.cursorrules` в корне проекта

**Что он делает:**
- Определяет архитектурные принципы
- Устанавливает стандарты кода
- Задает правила именования
- Описывает паттерны проекта

**Пример использования:**
```
AI, добавь валидацию для email в DTO
→ AI автоматически использует class-validator и следует паттернам проекта
```

---

## 💬 Оптимизация промптов

### Структура эффективного промпта

```
1. Контекст (что нужно сделать)
2. Конкретные требования (как сделать)
3. Ожидаемый результат (что должно получиться)
4. Ограничения (чего не делать)
```

### Примеры хороших промптов

#### ❌ Плохо:
```
Сделай форму логина
```

#### ✅ Хорошо:
```
Создай форму логина в Flutter:
- Используй существующий AuthProvider из core/providers/api/auth_provider.dart
- Валидация: email должен быть валидным, пароль минимум 8 символов
- Обработка ошибок через ApiExceptionHandler
- После успешного входа - навигация на /feed
- Используй Material Design компоненты из shared/widgets
```

### Шаблоны промптов

#### Для новых фич:
```
Задача: [описание задачи]

Требования:
- [требование 1]
- [требование 2]

Используй:
- [существующий компонент/сервис]
- [паттерн из проекта]

Ожидаемый результат:
- [что должно получиться]

Ограничения:
- [чего не делать]
```

#### Для исправления багов:
```
Баг: [описание проблемы]

Шаги воспроизведения:
1. [шаг 1]
2. [шаг 2]

Ожидаемое поведение:
[что должно быть]

Фактическое поведение:
[что происходит]

Файлы для проверки:
- [файл 1]
- [файл 2]
```

---

## 🔧 Автоматизация через Tasks

### Создание Tasks.json

**Путь:** `.vscode/tasks.json` (Cursor использует VS Code tasks)

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Backend: Start Dev",
      "type": "shell",
      "command": "npm run start:dev",
      "options": {
        "cwd": "${workspaceFolder}/backend"
      },
      "problemMatcher": [],
      "isBackground": true,
      "presentation": {
        "reveal": "always",
        "panel": "dedicated"
      }
    },
    {
      "label": "Frontend: Run Web",
      "type": "shell",
      "command": "flutter run -d chrome",
      "options": {
        "cwd": "${workspaceFolder}/frontend"
      },
      "problemMatcher": []
    },
    {
      "label": "Backend: Run Tests",
      "type": "shell",
      "command": "npm test",
      "options": {
        "cwd": "${workspaceFolder}/backend"
      },
      "problemMatcher": "$tsc"
    },
    {
      "label": "Frontend: Generate Code",
      "type": "shell",
      "command": "flutter pub run build_runner build --delete-conflicting-outputs",
      "options": {
        "cwd": "${workspaceFolder}/frontend"
      }
    },
    {
      "label": "Docker: Start Infrastructure",
      "type": "shell",
      "command": "docker-compose up -d",
      "problemMatcher": []
    },
    {
      "label": "Docker: Stop All",
      "type": "shell",
      "command": "docker-compose down",
      "problemMatcher": []
    },
    {
      "label": "Backend: Run Migrations",
      "type": "shell",
      "command": "npm run migration:run",
      "options": {
        "cwd": "${workspaceFolder}/backend"
      }
    },
    {
      "label": "Backend: Seed Database",
      "type": "shell",
      "command": "npm run seed",
      "options": {
        "cwd": "${workspaceFolder}/backend"
      }
    }
  ]
}
```

**Использование:**
- `Ctrl+Shift+P` → "Tasks: Run Task"
- Выберите нужную задачу
- Или создайте комбинации клавиш в `keybindings.json`

---

## 📦 Snippets и шаблоны

### TypeScript Snippets (Backend)

**Путь:** `.vscode/typescript.code-snippets`

```json
{
  "NestJS Controller": {
    "prefix": "nest-controller",
    "body": [
      "import { Controller, Get, Post, Body, Param, UseGuards } from '@nestjs/common';",
      "import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';",
      "import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';",
      "",
      "@ApiTags('${1:resource}')",
      "@Controller('${1:resource}')",
      "@UseGuards(JwtAuthGuard)",
      "export class ${2:Resource}Controller {",
      "  constructor(private readonly ${3:service}: ${2:Resource}Service) {}",
      "",
      "  @Get()",
      "  @ApiOperation({ summary: 'Get all ${1:resource}' })",
      "  async findAll() {",
      "    return this.${3:service}.findAll();",
      "  }",
      "}"
    ],
    "description": "Create NestJS controller"
  },
  "NestJS Service": {
    "prefix": "nest-service",
    "body": [
      "import { Injectable } from '@nestjs/common';",
      "import { InjectRepository } from '@nestjs/typeorm';",
      "import { Repository } from 'typeorm';",
      "",
      "@Injectable()",
      "export class ${1:Resource}Service {",
      "  constructor(",
      "    @InjectRepository(${2:Entity})",
      "    private readonly ${3:repository}: Repository<${2:Entity}>,",
      "  ) {}",
      "",
      "  async findAll() {",
      "    return this.${3:repository}.find();",
      "  }",
      "}"
    ],
    "description": "Create NestJS service"
  }
}
```

### Dart Snippets (Frontend)

**Путь:** `.vscode/dart.code-snippets`

```json
{
  "Riverpod Provider": {
    "prefix": "riverpod-provider",
    "body": [
      "@riverpod",
      "Future<${1:Type}> ${2:providerName}(${2:ProviderName}Ref ref) async {",
      "  final repository = ref.watch(${3:repositoryProvider});",
      "  return await repository.${4:method}();",
      "}"
    ],
    "description": "Create Riverpod provider"
  },
  "Flutter Screen": {
    "prefix": "flutter-screen",
    "body": [
      "import 'package:flutter/material.dart';",
      "",
      "class ${1:ScreenName}Screen extends StatelessWidget {",
      "  const ${1:ScreenName}Screen({super.key});",
      "",
      "  @override",
      "  Widget build(BuildContext context) {",
      "    return Scaffold(",
      "      appBar: AppBar(",
      "        title: const Text('${2:Title}'),",
      "      ),",
      "      body: const Center(",
      "        child: Text('${1:ScreenName}'),",
      "      ),",
      "    );",
      "  }",
      "}"
    ],
    "description": "Create Flutter screen"
  }
}
```

---

## 🔌 Расширения и интеграции

### Рекомендуемые расширения для Cursor

1. **GitLens** - расширенная работа с Git
2. **Error Lens** - показ ошибок прямо в коде
3. **Todo Tree** - управление TODO комментариями
4. **Better Comments** - улучшенные комментарии
5. **Dart** - официальное расширение Dart
6. **Flutter** - официальное расширение Flutter
7. **ESLint** - линтер для TypeScript
8. **Prettier** - форматирование кода
9. **Thunder Client** - тестирование API прямо в IDE
10. **Docker** - управление Docker контейнерами

### Установка расширений

```bash
# Через командную строку Cursor
code --install-extension eamodio.gitlens
code --install-extension usernamehw.errorlens
code --install-extension gruntfuggly.todo-tree
code --install-extension dart-code.dart-code
code --install-extension dart-code.flutter
```

---

## 🎯 Best Practices для работы с AI

### 1. Используй CODE REFERENCES

Всегда ссылайся на существующий код:

```
Используй паттерн из frontend/lib/core/providers/api/auth_provider.dart
для создания нового провайдера subscriptions_provider.dart
```

### 2. Разбивай большие задачи

❌ Плохо:
```
Сделай всю систему аутентификации
```

✅ Хорошо:
```
Шаг 1: Создай AuthProvider
Шаг 2: Добавь методы login/logout
Шаг 3: Интегрируй с API
```

### 3. Используй контекст проекта

```
Проверь, как реализована валидация в backend/src/modules/users/dto/create-user.dto.ts
и примени тот же подход для create-post.dto.ts
```

### 4. Проверяй результаты

Всегда проверяй код перед коммитом:
- Запусти линтер
- Проверь типы
- Запусти тесты
- Проверь вручную

### 5. Итеративный подход

```
1. Попроси AI создать базовую структуру
2. Проверь результат
3. Попроси улучшить/исправить
4. Повторяй до идеального результата
```

---

## 🧪 Автоматизация тестирования

### Pre-commit hooks

**Установка Husky (для Git hooks):**

```bash
cd backend
npm install --save-dev husky
npx husky install
```

**Создание pre-commit hook:**

```bash
npx husky add .husky/pre-commit "npm run lint && npm test"
```

### GitHub Actions для автоматического тестирования

**Путь:** `.github/workflows/test.yml`

```yaml
name: Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  backend-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: cd backend && npm ci
      - run: cd backend && npm test
      - run: cd backend && npm run lint

  frontend-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      - run: cd frontend && flutter pub get
      - run: cd frontend && flutter test
      - run: cd frontend && flutter analyze
```

---

## 📊 Мониторинг и метрики

### Отслеживание эффективности

1. **Время на задачу** - сколько времени уходит на реализацию
2. **Количество итераций** - сколько раз нужно исправлять код
3. **Точность промптов** - процент успешных результатов с первого раза
4. **Покрытие тестами** - процент кода, покрытого тестами

### Метрики качества кода

- **Linter errors** - количество ошибок линтера
- **Test coverage** - покрытие тестами
- **Code complexity** - сложность кода
- **Dependencies** - количество зависимостей

---

## 🎓 Продвинутые техники

### 1. Использование Memory MCP

Memory MCP сохраняет контекст между сессиями:

```
AI, запомни: мы используем Riverpod 2.x для state management
→ Memory MCP сохранит это для будущих сессий
```

### 2. Автоматизация через GitHub MCP

```
AI, создай issue для бага с описанием из логов
→ GitHub MCP автоматически создаст issue
```

### 3. Использование Docker MCP

```
AI, покажи логи PostgreSQL за последний час
→ Docker MCP автоматически получит логи
```

### 4. Работа с Git через Git MCP

```
AI, создай коммит с сообщением "Fix: исправлена валидация email"
→ Git MCP автоматически создаст коммит
```

---

## ✅ Чек-лист оптимизации

- [ ] Настроен `settings.json` с оптимальными параметрами
- [ ] Создан `.cursorrules` в корне проекта
- [ ] Настроены Tasks для автоматизации
- [ ] Созданы Snippets для часто используемых паттернов
- [ ] Установлены полезные расширения
- [ ] Настроены pre-commit hooks
- [ ] Настроен CI/CD для автоматического тестирования
- [ ] Используются MCP серверы для автоматизации
- [ ] Ведется отслеживание метрик эффективности

---

## 🚀 Результат

После применения всех оптимизаций:

- ✅ **Точность:** 90%+ правильных результатов с первого раза
- ✅ **Скорость:** В 3-5 раз быстрее разработка
- ✅ **Автоматизация:** 80%+ рутинных задач автоматизировано
- ✅ **Качество:** Меньше багов, больше покрытие тестами

---

**Последнее обновление:** 2026-02-03
