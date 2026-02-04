import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [
    ['html'],
    ['json', { outputFile: 'test-results/results.json' }],
    ['list'],
  ],
  use: {
    baseURL: 'http://localhost:8081', // Flutter Web dev server (changed from 8080 to avoid conflicts)
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    actionTimeout: 10000,
    navigationTimeout: 30000,
    // Для визуального наблюдения: headless: false (можно переопределить через --headed)
    headless: process.env.CI ? true : false, // В CI headless, локально - видимый браузер
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
  ],
  webServer: {
    // ВАЖНО: запускаем Flutter как web-server (без открытия браузера),
    // чтобы Playwright управлял Chromium сам. Иначе Flutter откроет Chrome,
    // а Playwright откроет ещё один Chromium на каждый прогон.
    command:
      'cd frontend && flutter run -d web-server --release --web-hostname=127.0.0.1 --web-port=8081',
    url: 'http://localhost:8081',
    reuseExistingServer: !process.env.CI,
    timeout: 120 * 1000,
    stdout: 'pipe',
    stderr: 'pipe',
  },
  // Глобальная настройка таймаутов
  timeout: 60000, // 60 секунд на тест
  expect: {
    timeout: 10000, // 10 секунд на expect
  },
});
