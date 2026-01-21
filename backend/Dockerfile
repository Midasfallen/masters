# Multi-stage build для оптимизации размера образа

# ===== Builder Stage =====
FROM node:18-alpine AS builder

WORKDIR /app

# Копируем package files для кэширования зависимостей
COPY package*.json ./

# Устанавливаем ВСЕ зависимости (включая dev для компиляции)
RUN npm ci && npm cache clean --force

# Копируем исходный код
COPY . .

# Билдим приложение (TypeScript → JavaScript)
RUN npm run build

# ===== Production Stage =====
FROM node:18-alpine

WORKDIR /app

# Устанавливаем только runtime зависимости
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

# Копируем собранное приложение из builder stage
COPY --from=builder /app/dist ./dist

# Создаем non-root пользователя для безопасности
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nestjs -u 1001

# Меняем владельца файлов
RUN chown -R nestjs:nodejs /app

USER nestjs

# Экспонируем порт
EXPOSE 3000

# Health check для docker-compose
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/api/v2/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Запускаем приложение
CMD ["node", "dist/main.js"]
