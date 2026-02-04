import { test as base } from '@playwright/test';

// Тестовые учетные данные из seed данных (backend/src/database/seeds/test-data.seed.ts)
export const TEST_USER = {
  email: 'maria.student@test.com',
  password: 'test123',
};

export const TEST_MASTER = {
  email: 'anna.master@test.com',
  password: 'test123',
};

type AuthFixtures = {
  authenticatedPage: any; // Page с авторизованным пользователем
};

export const test = base.extend<AuthFixtures>({
  authenticatedPage: async ({ page }, use) => {
    // Импортируем функцию авторизации
    const { loginUser } = await import('../helpers/test-helpers');
    
    // Авторизация с учетом splash screen и onboarding
    await loginUser(page, TEST_USER.email, TEST_USER.password);

    await use(page);
  },
});

export { expect } from '@playwright/test';
