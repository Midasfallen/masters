import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './ui-tests',
  timeout: 120_000, // Увеличено до 2 минут для Flutter Web
  expect: {
    timeout: 15_000,
  },
  // Настройки для скриншотов
  outputDir: 'test-results',
  use: {
    // ВАЖНО: запускаем в видимом режиме, чтобы наблюдать UI
    headless: false,
    // Небольшая задержка между действиями для комфортного наблюдения
    launchOptions: {
      slowMo: 200,
    },
    // Фронт поднимается командой:
    // flutter run -d chrome --web-port 3001
    baseURL: 'http://localhost:3001',
    viewport: { width: 1280, height: 720 },
    trace: 'on-first-retry',
    screenshot: 'only-on-failure', // Скриншоты при ошибках (но мы делаем свои в тесте)
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
  ],
});

