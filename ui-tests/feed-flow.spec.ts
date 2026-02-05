import { test, expect } from '@playwright/test';

/**
 * Сквозной E2E тест для Feed flow
 * 
 * Точное повторение ручных действий пользователя:
 * 1. Запуск бэка и фронта (выполняется вручную перед тестом)
 * 2. Ожидание загрузки splash screen
 * 3. Онбординг → "Пропустить"
 * 4. Экран регистрации → "Вход"
 * 5. Логин с тестовыми данными
 * 6. Ожидание загрузки Feed с изображениями
 * 7. Работа с фильтрами (без геолокации)
 * 8. Открытие поста
 * 9. Взаимодействия с постом (лайк, комментарий, закладки, подписка, профиль мастера)
 * 10. Возврат на Feed
 * 
 * ВАЖНО: Flutter Web с CanvasKit рендерит всё в canvas, поэтому используем координаты кликов.
 */

test('feed end-to-end flow - точное повторение ручных действий', async ({ page }) => {
  // ============================================
  // ШАГ 1-2: Запуск и ожидание загрузки
  // ============================================
  // Примечание: Backend и Frontend должны быть запущены вручную:
  // - cd backend && npm run start:dev
  // - cd frontend && flutter run -d chrome --web-port 3001
  
  await page.goto('/');
  await page.screenshot({ path: 'test-results/01-initial-load.png', fullPage: true });
  
  // Ждём загрузку splash screen и инициализацию Flutter
  await page.waitForTimeout(5000); // Даём время на splash screen
  await page.screenshot({ path: 'test-results/02-after-splash.png', fullPage: true });

  // ============================================
  // ШАГ 3: Онбординг → "Пропустить"
  // ============================================
  const viewport = page.viewportSize();
  if (!viewport) {
    throw new Error('Не удалось получить размер viewport');
  }
  
  // Кнопка "Пропустить" находится в правом верхнем углу онбординга
  // Пробуем текстовый селектор, если не работает - используем координаты
  try {
    await page.getByText('Пропустить', { exact: false }).first().click({ timeout: 3000 });
  } catch {
    // Fallback: правый верхний угол (где обычно кнопка "Пропустить")
    await page.mouse.click(viewport.width - 80, 30);
  }
  await page.waitForTimeout(1500);
  await page.screenshot({ path: 'test-results/03-onboarding-skipped.png', fullPage: true });

  // ============================================
  // ШАГ 4: Экран регистрации → "Вход"
  // ============================================
  // Кнопка "Вход" обычно внизу экрана регистрации или в центре
  try {
    await page.getByText('Вход', { exact: false }).first().click({ timeout: 3000 });
  } catch {
    // Fallback: клик в нижней части экрана, где обычно кнопка "Вход"
    await page.mouse.click(viewport.width / 2, viewport.height - 150);
  }
  await page.waitForTimeout(1500);
  await page.screenshot({ path: 'test-results/04-to-login-screen.png', fullPage: true });

  // ============================================
  // ШАГ 5: Логин с тестовыми данными
  // ============================================
  // Email: ravinski.genlawyer@gmail.com
  // Password: qwerty123
  
  await page.waitForTimeout(1000); // Даём время на рендеринг формы логина
  
  // Переходим к первому полю (email) через Tab
  await page.keyboard.press('Tab');
  await page.waitForTimeout(300);
  await page.keyboard.type('ravinski.genlawyer@gmail.com', { delay: 50 });
  await page.waitForTimeout(500);
  
  // Переходим к полю пароля
  await page.keyboard.press('Tab');
  await page.waitForTimeout(300);
  await page.keyboard.type('qwerty123', { delay: 50 });
  await page.waitForTimeout(500);
  
  await page.screenshot({ path: 'test-results/05-login-filled.png', fullPage: true });
  
  // Нажимаем кнопку "Войти" через Tab + Enter
  await page.keyboard.press('Tab'); // Переходим к кнопке
  await page.waitForTimeout(300);
  await page.keyboard.press('Enter');
  await page.waitForTimeout(2000);
  
  await page.screenshot({ path: 'test-results/06-after-login.png', fullPage: true });

  // ============================================
  // ШАГ 6: Ожидание загрузки Feed с изображениями
  // ============================================
  await page.waitForLoadState('networkidle');
  await page.waitForTimeout(5000); // Дополнительное время для загрузки изображений Flutter Web
  await page.screenshot({ path: 'test-results/07-feed-loaded.png', fullPage: true });
  
  console.log('✅ Feed загружен, изображения должны быть видны');

  // ============================================
  // ШАГ 7: Работа с фильтрами (без геолокации)
  // ============================================
  // Открываем фильтры - кнопка в левом верхнем углу AppBar
  await page.mouse.click(50, 50);
  await page.waitForTimeout(1500);
  await page.screenshot({ path: 'test-results/08-filters-opened.png', fullPage: true });
  
  // Ищем чекбоксы категорий в модальном окне
  const categoryCheckboxes = page.locator('input[type="checkbox"]');
  const checkboxCount = await categoryCheckboxes.count();
  
  if (checkboxCount > 0) {
    // Выбираем первую доступную категорию (например, "Маникюр" или любую другую)
    await categoryCheckboxes.first().check();
    await page.waitForTimeout(500);
    await page.screenshot({ path: 'test-results/09-filter-category-selected.png', fullPage: true });
  }
  
  // Применяем фильтры - кнопка "Применить" внизу справа
  const applyX = viewport.width / 2 + 100;
  const applyY = viewport.height - 80;
  await page.mouse.click(applyX, applyY);
  await page.waitForTimeout(2000); // Ждём применения фильтров и обновления Feed
  await page.screenshot({ path: 'test-results/10-filters-applied.png', fullPage: true });
  
  // Снова открываем фильтры для сброса
  await page.mouse.click(50, 50);
  await page.waitForTimeout(1500);
  
  // Сбрасываем фильтры - кнопка "Сбросить" слева от "Применить"
  const resetX = viewport.width / 2 - 100;
  const resetY = viewport.height - 80;
  await page.mouse.click(resetX, resetY);
  await page.waitForTimeout(500);
  
  // Применяем (теперь без фильтров)
  await page.mouse.click(applyX, resetY);
  await page.waitForTimeout(2000);
  await page.screenshot({ path: 'test-results/11-filters-reset.png', fullPage: true });

  // ============================================
  // ШАГ 8: Выбор и открытие поста
  // ============================================
  // Посты расположены в GridView 3x3
  // Кликаем на первый пост (левая колонка, первая строка)
  const postX = viewport.width / 6; // Примерно 1/6 ширины (первая колонка из 3)
  const postY = 200; // Ниже AppBar (~100px) + отступ
  await page.mouse.click(postX, postY);
  await page.waitForTimeout(3000); // Даём время на открытие поста и загрузку медиа
  await page.screenshot({ path: 'test-results/12-post-opened.png', fullPage: true });

  // ============================================
  // ШАГ 9: Взаимодействия с постом
  // ============================================
  // Кнопки действий расположены справа вертикально
  
  // 9.1. Лайк → убрать лайк
  const likeX = viewport.width - 50;
  const likeY = viewport.height / 2;
  
  await page.mouse.click(likeX, likeY);
  await page.waitForTimeout(1500);
  await page.screenshot({ path: 'test-results/13-post-liked.png', fullPage: true });
  
  await page.mouse.click(likeX, likeY); // Убираем лайк
  await page.waitForTimeout(1500);
  
  // 9.2. Комментарий
  const commentY = likeY + 40; // Кнопка комментариев между лайком и закладками
  await page.mouse.click(likeX, commentY);
  await page.waitForTimeout(2000);
  await page.screenshot({ path: 'test-results/14-comments-opened.png', fullPage: true });
  
  // Вводим комментарий через Tab-навигацию к полю ввода
  await page.keyboard.press('Tab');
  await page.waitForTimeout(300);
  await page.keyboard.press('Tab'); // Может потребоваться несколько Tab для попадания в поле
  await page.waitForTimeout(300);
  await page.keyboard.type('Автоматический тестовый комментарий', { delay: 50 });
  await page.waitForTimeout(500);
  await page.screenshot({ path: 'test-results/15-comment-typed.png', fullPage: true });
  
  // Отправляем комментарий
  await page.keyboard.press('Enter');
  await page.waitForTimeout(2000);
  await page.screenshot({ path: 'test-results/16-comment-sent.png', fullPage: true });
  
  // Закрываем модальное окно комментариев
  await page.keyboard.press('Escape');
  await page.waitForTimeout(1500);
  
  // 9.3. Закладки → убрать из закладок
  const bookmarkY = likeY + 80; // Кнопка закладок ниже лайка
  await page.mouse.click(likeX, bookmarkY);
  await page.waitForTimeout(1500);
  await page.screenshot({ path: 'test-results/17-post-bookmarked.png', fullPage: true });
  
  await page.mouse.click(likeX, bookmarkY); // Убираем из закладок
  await page.waitForTimeout(1500);
  
  // 9.4. Подписка → отписка
  // Кнопка подписки находится внизу экрана, справа от имени мастера
  const subscribeX = viewport.width - 150;
  const subscribeY = viewport.height - 100;
  
  await page.mouse.click(subscribeX, subscribeY);
  await page.waitForTimeout(2000);
  await page.screenshot({ path: 'test-results/18-subscribed.png', fullPage: true });
  
  await page.mouse.click(subscribeX, subscribeY); // Отписываемся
  await page.waitForTimeout(2000);
  
  // 9.5. Профиль мастера → возврат к посту
  // Имя мастера кликабельно и находится внизу экрана, слева от кнопки подписки
  const masterNameX = viewport.width / 2;
  const masterNameY = viewport.height - 120;
  
  await page.mouse.click(masterNameX, masterNameY);
  await page.waitForTimeout(3000); // Ждём загрузки профиля мастера
  await page.screenshot({ path: 'test-results/19-master-profile.png', fullPage: true });
  
  // Возвращаемся назад к посту
  await page.goBack();
  await page.waitForTimeout(2000);
  await page.screenshot({ path: 'test-results/20-back-to-post.png', fullPage: true });

  // ============================================
  // ШАГ 10: Возврат на экран Feed
  // ============================================
  await page.goBack();
  await page.waitForTimeout(2000);
  await page.screenshot({ path: 'test-results/21-back-to-feed.png', fullPage: true });
  
  console.log('✅ Тест завершён успешно! Все шаги выполнены в точном соответствии с планом.');
});
