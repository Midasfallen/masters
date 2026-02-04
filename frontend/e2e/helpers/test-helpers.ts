import { Page, expect } from '@playwright/test';

/**
 * Ожидание загрузки страницы Flutter Web
 */
export async function waitForFlutterApp(page: Page, timeout = 30000) {
  // Для Flutter Web `body` часто "hidden" пока Flutter инициализируется,
  // поэтому ждём специфичные для Flutter элементы.
  await page.waitForLoadState('domcontentloaded', { timeout });

  // `flt-glass-pane` появляется, когда Flutter уже смонтировался.
  // В debug/release DOM может отличаться, поэтому держим несколько вариантов.
  await page.waitForSelector('flt-glass-pane, flutter-view, flt-platform-view', {
    timeout,
  });

  // Даем Flutter дорендерить первый кадр/семантику
  await page.waitForTimeout(1000);
}

/**
 * Ожидание прохождения splash screen
 * Splash screen длится ~1.5 секунды и автоматически навигирует
 */
export async function waitForSplashScreen(page: Page, timeout = 10000) {
  // Ждем завершения splash screen (минимум 1.5 секунды)
  await page.waitForTimeout(2000);
  
  // Ждем навигации с splash screen (URL изменится с /splash)
  try {
    await page.waitForFunction(
      () => {
        return !window.location.pathname.includes('/splash');
      },
      { timeout },
    );
  } catch (e) {
    // Если навигация не произошла, проверяем текущий URL
    const currentUrl = page.url();
    if (currentUrl.includes('/splash')) {
      // Если все еще на splash, ждем еще немного
      await page.waitForTimeout(2000);
    }
  }
  
  // Дополнительное ожидание для загрузки следующего экрана
  await page.waitForTimeout(1000);
}

/**
 * Прохождение onboarding (если показывается)
 * Onboarding имеет 3 страницы с кнопкой "Пропустить" или "Далее"/"Начать"
 */
export async function handleOnboarding(page: Page) {
  const currentUrl = page.url();
  
  // Проверяем, находимся ли мы на onboarding
  if (!currentUrl.includes('/onboarding')) {
    return; // Не на onboarding, пропускаем
  }
  
  // Ждем загрузки onboarding экрана
  await page.waitForTimeout(1000);
  
  // Ищем текст onboarding для подтверждения
  const onboardingText = page.locator('text=/Найди профессионала|Удобная запись|Гарантия качества/i');
  
  if ((await onboardingText.count()) > 0) {
    // Вариант 1: Пропустить onboarding через кнопку "Пропустить"
    const skipButton = page.locator('text="Пропустить"').first();
    
    if ((await skipButton.count()) > 0) {
      await skipButton.click();
      await page.waitForTimeout(2000);
      // После пропуска должен быть переход на /register
      return;
    }
    
    // Вариант 2: Пройти все страницы onboarding
    // Листаем до последней страницы (3 страницы, индексы 0, 1, 2)
    for (let i = 0; i < 2; i++) {
      // Используем свайп или клик на кнопку "Далее"
      const nextButton = page.locator('button:has-text("Далее")').first();
      if ((await nextButton.count()) > 0) {
        await nextButton.click();
        await page.waitForTimeout(1000);
      } else {
        // Если кнопки нет, используем свайп
        await page.keyboard.press('ArrowRight');
        await page.waitForTimeout(500);
      }
    }
    
    // На последней странице нажимаем "Начать"
    const startButton = page.locator('button:has-text("Начать")').first();
    if ((await startButton.count()) > 0) {
      await startButton.click();
      await page.waitForTimeout(2000);
      // После "Начать" должен быть переход на /register
    }
  }
}

/**
 * Авторизация пользователя (с учетом splash screen и onboarding)
 * Полный flow: Splash -> Onboarding (если первый запуск) -> Login -> Feed
 */
export async function loginUser(
  page: Page,
  email: string,
  password: string,
) {
  // Начинаем с splash screen (начальная точка приложения)
  await page.goto('/splash');
  await waitForFlutterApp(page);
  await waitForSplashScreen(page);
  
  // Обрабатываем onboarding, если показывается (первый запуск)
  await handleOnboarding(page);
  
  // После splash/onboarding можем быть на /login или /register
  // Если на /register, переходим на /login
  let currentUrl = page.url();
  if (currentUrl.includes('/register')) {
    // Ищем ссылку "Войти" или переходим напрямую
    const loginLink = page.locator('text=/Войти/i').first();
    if ((await loginLink.count()) > 0) {
      await loginLink.click();
      await page.waitForTimeout(2000);
    } else {
      await page.goto('/login');
      await waitForFlutterApp(page);
      await page.waitForTimeout(1000);
    }
  }
  
  // Убеждаемся, что мы на странице логина
  currentUrl = page.url();
  if (!currentUrl.includes('/login')) {
    await page.goto('/login');
    await waitForFlutterApp(page);
    await page.waitForTimeout(1000);
  }
  
  // Заполнение формы логина
  // Flutter Web рендерит TextFormField как input с labelText
  // Ищем по labelText через XPath или текстовому содержимому
  const emailInput = page.locator('input[type="email"]').first();
  const passwordInput = page.locator('input[type="password"]').first();
  const submitButton = page.locator('button:has-text("Войти")').first();
  
  // Ждем появления формы логина
  await page.waitForSelector('text="Вход"', { timeout: 10000 });
  await page.waitForTimeout(1000);
  
  // Заполняем email
  if ((await emailInput.count()) > 0) {
    await emailInput.fill(email);
    await page.waitForTimeout(500);
  } else {
    throw new Error('Email input not found on login page');
  }
  
  // Заполняем пароль
  if ((await passwordInput.count()) > 0) {
    await passwordInput.fill(password);
    await page.waitForTimeout(500);
  } else {
    throw new Error('Password input not found on login page');
  }
  
  // Нажимаем кнопку "Войти"
  if ((await submitButton.count()) > 0) {
    await submitButton.click();
    
    // Ожидание редиректа после успешного логина (должен быть переход на /)
    try {
      await page.waitForURL('**/', { timeout: 15000 });
    } catch (e) {
      // Если редирект не произошел, проверяем текущий URL
      const finalUrl = page.url();
      if (finalUrl.includes('/login')) {
        // Возможно ошибка логина, проверяем наличие SnackBar с ошибкой
        const errorSnackBar = page.locator('[role="alert"], .snackbar');
        if ((await errorSnackBar.count()) > 0) {
          const errorText = await errorSnackBar.textContent();
          throw new Error(`Login failed: ${errorText}`);
        }
      }
    }
    
    // Дополнительное ожидание загрузки Feed после логина
    await page.waitForTimeout(3000);
  } else {
    throw new Error('Login button not found on login page');
  }
}

/**
 * Ожидание ответа API
 */
export async function waitForApiResponse(
  page: Page,
  urlPattern: string | RegExp,
  status = 200,
) {
  return page.waitForResponse(
    (response) => {
      const url = response.url();
      const matches =
        typeof urlPattern === 'string'
          ? url.includes(urlPattern)
          : urlPattern.test(url);
      return matches && response.status() === status;
    },
    { timeout: 30000 },
  );
}

/**
 * Проверка наличия элемента (с retry)
 */
export async function expectElementVisible(
  page: Page,
  selector: string,
  timeout = 10000,
) {
  await expect(page.locator(selector)).toBeVisible({ timeout });
}

/**
 * Получение текста элемента
 */
export async function getElementText(
  page: Page,
  selector: string,
): Promise<string> {
  return page.locator(selector).textContent() || '';
}

/**
 * Ожидание исчезновения элемента
 */
export async function waitForElementHidden(
  page: Page,
  selector: string,
  timeout = 10000,
) {
  await expect(page.locator(selector)).toBeHidden({ timeout });
}

/**
 * Скролл к элементу
 */
export async function scrollToElement(page: Page, selector: string) {
  await page.locator(selector).scrollIntoViewIfNeeded();
  await page.waitForTimeout(500); // Небольшая задержка после скролла
}

/**
 * Ожидание появления SnackBar
 */
export async function waitForSnackBar(
  page: Page,
  message?: string,
  timeout = 5000,
) {
  const snackBarSelector = '[role="alert"], .snackbar, [class*="SnackBar"]';
  await expectElementVisible(page, snackBarSelector, timeout);

  if (message) {
    await expect(page.locator(snackBarSelector)).toContainText(message, {
      timeout,
    });
  }
}

/**
 * Проверка UUID формата
 */
export function isValidUUID(str: string): boolean {
  const uuidRegex =
    /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
  return uuidRegex.test(str);
}

/**
 * Извлечение UUID из URL
 */
export function extractUUIDsFromUrl(url: string): string[] {
  const uuidRegex =
    /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/gi;
  return url.match(uuidRegex) || [];
}
