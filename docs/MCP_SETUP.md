# Установка MCP серверов для отладки

Этот документ описывает установку полезных MCP серверов для отладки Frontend и Backend.

## Необходимые MCP серверы

| Задача | MCP сервер | Что делает |
|--------|------------|------------|
| Debug Frontend | `@modelcontextprotocol/server-puppeteer` | Видит ошибки F12, делает скриншоты рендеринга Flutter Web |
| Debug Backend | `@modelcontextprotocol/server-postgres` | Агент сам проверит, создалась ли запись в БД, если API вернул 200, но данных нет |
| Логи и файлы | `@modelcontextprotocol/server-filesystem` | Позволяет агенту читать логи и анализировать структуру файлов проекта |

## Шаг 1: Установка npm пакетов

⚠️ **Важно**: Эти пакеты помечены как deprecated, но все еще функциональны. Рассмотрите альтернативные решения для production.

Пакеты уже установлены локально в `backend/` директории. Если нужно переустановить:

```bash
cd backend
npm install --save-dev @modelcontextprotocol/server-puppeteer
npm install --save-dev @modelcontextprotocol/server-postgres
npm install --save-dev @modelcontextprotocol/server-filesystem
```

**Альтернативные решения:**
- Для Puppeteer: используйте актуальные версии `puppeteer` или `playwright`
- Для Postgres: используйте прямые подключения через `pg` или `typeorm`
- Для Filesystem: используйте стандартные Node.js `fs` модули

## Шаг 2: Конфигурация Cursor

В Cursor конфигурация MCP может храниться в нескольких местах:

**Вариант 1: Файл в проекте (рекомендуется)**
Файл `.cursor/mcp.json` уже создан в корне проекта. Cursor автоматически обнаружит его.

**Вариант 2: Глобальная конфигурация**
Найдите файл конфигурации в зависимости от ОС:

**Windows:**
```
%APPDATA%\Cursor\User\globalStorage\mcp.json
или
%USERPROFILE%\.cursor\mcp.json
```

**macOS:**
```
~/Library/Application Support/Cursor/User/globalStorage/mcp.json
```

**Linux:**
```
~/.config/Cursor/User/globalStorage/mcp.json
```

## Шаг 3: Добавление конфигурации MCP

### Вариант A: Создание файла в проекте (рекомендуется)

Создайте файл `.cursor/mcp.json` в корне проекта (`C:\masters\masters\.cursor\mcp.json`) со следующим содержимым:

```json
{
  "mcpServers": {
    "puppeteer": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-puppeteer"
      ],
      "env": {
        "BROWSER_PATH": "chrome"
      }
    },
    "postgres": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-postgres"
      ],
      "env": {
        "POSTGRES_CONNECTION_STRING": "postgresql://service_user:service_password@localhost:5433/service_db"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem"
      ],
      "env": {
        "ALLOWED_DIRECTORIES": "C:\\masters\\masters"
      }
    }
  }
}
```

**Примечание**: Если используете локальные пакеты из `backend/node_modules`, замените `npx -y` на путь к локальному пакету:

```json
{
  "mcpServers": {
    "puppeteer": {
      "command": "node",
      "args": [
        "C:\\masters\\masters\\backend\\node_modules\\@modelcontextprotocol\\server-puppeteer\\dist\\index.js"
      ],
      "env": {
        "BROWSER_PATH": "chrome"
      }
    },
    "postgres": {
      "command": "node",
      "args": [
        "C:\\masters\\masters\\backend\\node_modules\\@modelcontextprotocol\\server-postgres\\dist\\index.js"
      ],
      "env": {
        "POSTGRES_CONNECTION_STRING": "postgresql://service_user:service_password@localhost:5433/service_db"
      }
    },
    "filesystem": {
      "command": "node",
      "args": [
        "C:\\masters\\masters\\backend\\node_modules\\@modelcontextprotocol\\server-filesystem\\dist\\index.js"
      ],
      "env": {
        "ALLOWED_DIRECTORIES": "C:\\masters\\masters"
      }
    }
  }
}
```

### Вариант B: Глобальная конфигурация

Если Cursor не обнаруживает файл в проекте, добавьте конфигурацию в глобальный файл настроек Cursor.

### Важные замечания:

1. **Puppeteer**: Убедитесь, что Chrome установлен и доступен в PATH, или укажите полный путь к исполняемому файлу Chrome.

2. **Postgres**: Замените `POSTGRES_CONNECTION_STRING` на ваши реальные данные подключения к БД:
   - Хост: `localhost`
   - Порт: `5433` (из `backend/src/config/typeorm.config.ts`)
   - Пользователь: `service_user`
   - Пароль: `service_password`
   - База данных: `service_db`

3. **Filesystem**: Укажите абсолютный путь к корню проекта. Для Windows используйте двойные обратные слеши `\\` или одинарные прямые `/`.

## Шаг 4: Быстрая установка

Для быстрой установки скопируйте содержимое файла `docs/mcp-config-example.json` в файл `.cursor/mcp.json` в корне проекта:

```bash
# Windows PowerShell
New-Item -ItemType Directory -Force -Path .cursor
Copy-Item docs\mcp-config-example.json .cursor\mcp.json

# Или вручную:
# 1. Создайте папку .cursor в корне проекта (C:\masters\masters\.cursor)
# 2. Скопируйте содержимое docs/mcp-config-example.json в .cursor/mcp.json
# 3. Отредактируйте пути и переменные окружения под вашу систему
```

## Шаг 5: Перезапуск Cursor

После добавления конфигурации:
1. Сохраните файл конфигурации
2. Полностью закройте Cursor
3. Запустите Cursor снова

## Шаг 6: Проверка установки

После перезапуска Cursor проверьте:
1. Откройте панель MCP в Cursor (обычно в боковой панели или через команду `MCP: Show Servers` или `Ctrl+Shift+P` → "MCP")
2. Убедитесь, что все три сервера отображаются и имеют статус "Connected"
3. Если серверы не подключились, проверьте логи в панели MCP или консоли Cursor

## Альтернативный способ: Через настройки Cursor UI

Если файл конфигурации не найден, попробуйте:
1. Откройте настройки Cursor (`Ctrl+,` или `Cmd+,`)
2. Найдите раздел "MCP" или "Model Context Protocol"
3. Добавьте серверы через UI интерфейс

## Troubleshooting

### Puppeteer не запускается
- Убедитесь, что Chrome установлен
- Проверьте переменную окружения `BROWSER_PATH`
- Попробуйте указать полный путь: `"BROWSER_PATH": "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe"`

### Postgres не подключается
- Проверьте, что PostgreSQL запущен
- Убедитесь, что порт `5433` доступен
- Проверьте строку подключения на корректность

### Filesystem не работает
- Проверьте права доступа к указанной директории
- Убедитесь, что путь указан корректно (абсолютный путь)

## Статус установки

✅ **Пакеты установлены**: Все три MCP сервера установлены в `backend/node_modules`  
✅ **Конфигурация создана**: Файл `.cursor/mcp.json` создан в корне проекта  
⚠️ **Требуется**: Перезапуск Cursor для активации MCP серверов

## Дополнительные ресурсы

- [MCP Documentation](https://modelcontextprotocol.io/)
- [MCP Servers Repository](https://github.com/modelcontextprotocol/servers)
- [Cursor MCP Setup Guide](https://docs.cursor.com/mcp)

## Что дальше?

После перезапуска Cursor вы сможете:
- **Puppeteer**: Делать скриншоты Flutter Web приложения, видеть ошибки консоли браузера
- **Postgres**: Проверять данные в БД напрямую, отлаживать проблемы с сохранением данных
- **Filesystem**: Читать логи и анализировать структуру файлов проекта автоматически

Эти инструменты значительно ускорят процесс отладки и тестирования приложения!
