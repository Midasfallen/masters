# Быстрый старт: Установка рекомендуемых MCP серверов

## 🎯 Топ-5 рекомендуемых MCP серверов

Для вашего проекта (NestJS + Flutter + PostgreSQL + Docker) наиболее полезны:

1. **GitHub MCP** — управление Issues и PR
2. **Git MCP** — работа с git напрямую
3. **Memory MCP** — сохранение контекста проекта
4. **Brave Search MCP** — поиск документации
5. **Playwright MCP** — современная альтернатива Puppeteer

## 📦 Установка

```bash
cd backend
npm install --save-dev \
  @modelcontextprotocol/server-github \
  @modelcontextprotocol/server-git \
  @modelcontextprotocol/server-memory \
  @modelcontextprotocol/server-brave-search \
  @modelcontextprotocol/server-playwright
```

## ⚙️ Конфигурация

Скопируйте содержимое `docs/mcp-config-recommended.json` в `.cursor/mcp.json` и:

1. **GitHub MCP**: Получите Personal Access Token на https://github.com/settings/tokens
   - Права: `repo`, `workflow`, `read:org`
   - Замените `your_github_token_here` в конфигурации

2. **Brave Search MCP**: Получите API ключ на https://brave.com/search/api/
   - Замените `your_brave_api_key_here` в конфигурации

3. **Memory MCP**: Создайте папку для хранения памяти:
   ```bash
   mkdir -p .cursor/memory
   ```

## 🔄 Перезапуск Cursor

После установки и настройки:
1. Сохраните `.cursor/mcp.json`
2. Полностью закройте Cursor
3. Запустите Cursor снова
4. Проверьте статус MCP серверов в панели MCP

## 📚 Подробная документация

См. `docs/MCP_RECOMMENDATIONS.md` для полного списка рекомендуемых серверов и их описания.
