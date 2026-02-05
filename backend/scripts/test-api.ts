/**
 * Скрипт для проверки основных API эндпоинтов
 * Запуск: ts-node -r tsconfig-paths/register scripts/test-api.ts
 * 
 * Требования:
 * - Backend должен быть запущен на http://localhost:3000
 * - Docker сервисы должны быть запущены
 */

import axios, { AxiosError } from 'axios';

const BASE_URL = 'http://localhost:3000/api/v2';

interface TestResult {
  name: string;
  status: 'PASS' | 'FAIL' | 'SKIP';
  message?: string;
  duration?: number;
}

const results: TestResult[] = [];

async function test(name: string, fn: () => Promise<void>): Promise<void> {
  const start = Date.now();
  try {
    await fn();
    const duration = Date.now() - start;
    results.push({ name, status: 'PASS', duration });
    console.log(`✅ ${name} (${duration}ms)`);
  } catch (error: any) {
    const duration = Date.now() - start;
    const message = error.response?.data?.message || error.message || 'Unknown error';
    results.push({ name, status: 'FAIL', message, duration });
    console.error(`❌ ${name}: ${message} (${duration}ms)`);
    if (error.response?.data) {
      console.error('   Response:', JSON.stringify(error.response.data, null, 2));
    }
  }
}

async function skip(name: string, reason: string): Promise<void> {
  results.push({ name, status: 'SKIP', message: reason });
  console.log(`⏭️  ${name}: ${reason}`);
}

// Helper для получения токена
let testUserToken: string | null = null;
let testUserId: string | null = null;

async function setupTestUser(): Promise<void> {
  const email = `test-${Date.now()}@example.com`;
  const phone = `+7999${String(Math.floor(Math.random() * 10000000)).padStart(7, '0')}`;
  
  try {
    const response = await axios.post(`${BASE_URL}/auth/register`, {
      email,
      password: 'TestPassword123',
      first_name: 'Test',
      last_name: 'User',
      phone,
    });
    
    // API возвращает accessToken (camelCase), а не access_token
    const token = response.data.accessToken || response.data.access_token;
    const userId = response.data.user?.id;
    
    if (response.status === 201 && token && userId) {
      testUserToken = token;
      testUserId = userId;
      console.log(`📝 Создан тестовый пользователь: ${email}`);
    } else {
      throw new Error(`Registration returned status ${response.status}, missing token or user`);
    }
  } catch (error: any) {
    const errorMsg = error.response?.data?.message || error.message;
    throw new Error(`Failed to setup test user: ${errorMsg}`);
  }
}

async function main() {
  console.log('🚀 Начало проверки API эндпоинтов\n');
  console.log(`📍 Base URL: ${BASE_URL}\n`);

  // Проверка доступности сервера
  await test('GET / - API info', async () => {
    const response = await axios.get(`${BASE_URL}/`);
    if (response.status !== 200 || !response.data.name) {
      throw new Error(`Expected 200 with API info, got ${response.status}`);
    }
  });

  await test('GET /health - health check', async () => {
    const response = await axios.get(`${BASE_URL}/health`);
    if (response.status !== 200 || !response.data.status) {
      throw new Error(`Expected 200 with health status, got ${response.status}`);
    }
  });

  // Настройка тестового пользователя
  await test('Setup test user', async () => {
    await setupTestUser();
    if (!testUserToken) {
      throw new Error('Failed to get test user token');
    }
  });

  const headers = testUserToken ? { Authorization: `Bearer ${testUserToken}` } : {};

  // ============ AUTH TESTS ============
  console.log('\n📋 Auth Endpoints:');
  
  await test('POST /auth/register - регистрация', async () => {
    const email = `test-register-${Date.now()}@example.com`;
    const phone = `+7999${String(Math.floor(Math.random() * 10000000)).padStart(7, '0')}`;
    const response = await axios.post(`${BASE_URL}/auth/register`, {
      email,
      password: 'TestPassword123',
      first_name: 'Test',
      last_name: 'User',
      phone,
    });
    const token = response.data.accessToken || response.data.access_token;
    if (response.status !== 201 || !token) {
      throw new Error(`Registration failed: missing token in response`);
    }
  });

  await test('POST /auth/login - логин', async () => {
    // Создаем нового пользователя для теста логина
    const email = `test-login-${Date.now()}@example.com`;
    const phone = `+7999${String(Math.floor(Math.random() * 10000000)).padStart(7, '0')}`;
    await axios.post(`${BASE_URL}/auth/register`, {
      email,
      password: 'TestPassword123',
      first_name: 'Test',
      last_name: 'User',
      phone,
    });
    
    const response = await axios.post(`${BASE_URL}/auth/login`, {
      email,
      password: 'TestPassword123',
    });
    const token = response.data.accessToken || response.data.access_token;
    if (response.status !== 200 || !token) {
      throw new Error(`Login failed: missing token in response`);
    }
  });

  await test('GET /users/me - получение профиля через users', async () => {
    if (!testUserToken) throw new Error('No token');
    // Используем /users/me вместо /auth/me
    const response = await axios.get(`${BASE_URL}/users/me`, { headers });
    if (response.status !== 200 || !response.data.id) {
      throw new Error('Get profile failed');
    }
  });

  // ============ USERS TESTS ============
  console.log('\n📋 Users Endpoints:');
  
  // Уже проверено выше как GET /users/me

  await test('GET /users/me/stats - статистика', async () => {
    if (!testUserToken) throw new Error('No token');
    const response = await axios.get(`${BASE_URL}/users/me/stats`, { headers });
    if (response.status !== 200) {
      throw new Error('Get stats failed');
    }
  });

  // ============ CATEGORIES TESTS ============
  console.log('\n📋 Categories Endpoints:');
  
  await test('GET /categories/tree - дерево категорий', async () => {
    const response = await axios.get(`${BASE_URL}/categories/tree`);
    if (response.status !== 200 || !Array.isArray(response.data)) {
      throw new Error('Get categories tree failed');
    }
  });

  await test('GET /categories/roots - корневые категории', async () => {
    const response = await axios.get(`${BASE_URL}/categories/roots`);
    if (response.status !== 200 || !Array.isArray(response.data)) {
      throw new Error('Get root categories failed');
    }
  });

  // ============ POSTS TESTS ============
  console.log('\n📋 Posts Endpoints:');
  
  let postId: string | null = null;

  await test('GET /posts/feed - лента постов', async () => {
    if (!testUserToken) throw new Error('No token');
    const response = await axios.get(`${BASE_URL}/posts/feed`, { headers });
    if (response.status !== 200 || !response.data.data) {
      throw new Error('Get feed failed');
    }
  });

  await test('POST /posts - создание поста', async () => {
    if (!testUserToken) throw new Error('No token');
    const response = await axios.post(
      `${BASE_URL}/posts`,
      {
        type: 'text',
        content: `Test post ${Date.now()}`,
        privacy: 'public',
      },
      { headers },
    );
    if (response.status !== 201 || !response.data.id) {
      throw new Error('Create post failed');
    }
    postId = response.data.id;
  });

  if (postId) {
    await test('GET /posts/:id - получение поста', async () => {
      if (!testUserToken) throw new Error('No token');
      const response = await axios.get(`${BASE_URL}/posts/${postId}`, { headers });
      if (response.status !== 200 || response.data.id !== postId) {
        throw new Error('Get post failed');
      }
    });

    await test('POST /posts/:id/like - лайк поста', async () => {
      if (!testUserToken) throw new Error('No token');
      const response = await axios.post(`${BASE_URL}/posts/${postId}/like`, {}, { headers });
      if (response.status !== 200) {
        throw new Error('Like post failed');
      }
    });

    await test('DELETE /posts/:id/unlike - убрать лайк', async () => {
      if (!testUserToken) throw new Error('No token');
      const response = await axios.delete(`${BASE_URL}/posts/${postId}/unlike`, { headers });
      if (response.status !== 200) {
        throw new Error('Unlike post failed');
      }
    });
  }

  // ============ SUBSCRIPTIONS TESTS ============
  console.log('\n📋 Subscriptions Endpoints:');
  
  await test('GET /subscriptions/following - мои подписки', async () => {
    if (!testUserToken) throw new Error('No token');
    const response = await axios.get(`${BASE_URL}/subscriptions/following`, { headers });
    if (response.status !== 200 || !response.data.data) {
      throw new Error('Get following failed');
    }
  });

  await test('GET /subscriptions/followers - мои подписчики', async () => {
    if (!testUserToken) throw new Error('No token');
    const response = await axios.get(`${BASE_URL}/subscriptions/followers`, { headers });
    if (response.status !== 200 || !response.data.data) {
      throw new Error('Get followers failed');
    }
  });

  // ============ REVIEWS TESTS ============
  console.log('\n📋 Reviews Endpoints:');
  
  await test('GET /reviews - список отзывов', async () => {
    const response = await axios.get(`${BASE_URL}/reviews?page=1&limit=10`);
    if (response.status !== 200 || !response.data.data) {
      throw new Error('Get reviews failed');
    }
  });

  // ============ SERVICES TESTS ============
  console.log('\n📋 Services Endpoints:');
  
  await test('GET /services - список услуг', async () => {
    const response = await axios.get(`${BASE_URL}/services`, {
      params: { page: 1, limit: 10 },
    });
    if (response.status !== 200) {
      throw new Error(`Get services failed: ${JSON.stringify(response.data)}`);
    }
    // Проверяем структуру ответа (может быть массив или объект с data)
    if (!Array.isArray(response.data) && !response.data.hasOwnProperty('data')) {
      throw new Error('Response format unexpected');
    }
  });

  // ============ SEARCH TESTS ============
  console.log('\n📋 Search Endpoints:');
  
  await test('GET /search/masters - поиск мастеров', async () => {
    const response = await axios.get(`${BASE_URL}/search/masters`, {
      params: {
        query: 'test',
        page: 1,
        limit: 10,
      },
    });
    if (response.status !== 200 || !response.data.hasOwnProperty('data')) {
      throw new Error(`Search masters failed: ${JSON.stringify(response.data)}`);
    }
  });

  await test('GET /search/services - поиск услуг', async () => {
    const response = await axios.get(`${BASE_URL}/search/services`, {
      params: {
        query: 'test',
        page: 1,
        limit: 10,
      },
    });
    if (response.status !== 200 || !response.data.hasOwnProperty('data')) {
      throw new Error(`Search services failed: ${JSON.stringify(response.data)}`);
    }
  });

  // ============ MASTERS TESTS ============
  console.log('\n📋 Masters Endpoints:');
  
  await test('GET /masters/:id - получение профиля мастера', async () => {
    // Попробуем найти существующего мастера из seeds
    const servicesResponse = await axios.get(`${BASE_URL}/services?page=1&limit=1`);
    if (servicesResponse.data.data && servicesResponse.data.data.length > 0) {
      const masterId = servicesResponse.data.data[0].masterId;
      const response = await axios.get(`${BASE_URL}/masters/${masterId}`);
      if (response.status !== 200 || !response.data.id) {
        throw new Error('Get master profile failed');
      }
    } else {
      await skip('GET /masters/:id', 'No masters found in database');
    }
  });

  // ============ FAVORITES TESTS ============
  console.log('\n📋 Favorites Endpoints:');
  
  await test('GET /favorites - список избранного', async () => {
    if (!testUserToken) throw new Error('No token');
    const response = await axios.get(`${BASE_URL}/favorites`, { headers });
    if (response.status !== 200) {
      throw new Error(`Get favorites failed: ${JSON.stringify(response.data)}`);
    }
    // Проверяем структуру ответа (может быть массив или объект с data)
    if (!Array.isArray(response.data) && !response.data.hasOwnProperty('data')) {
      throw new Error('Response format unexpected');
    }
  });

  // ============ FRIENDSHIPS TESTS ============
  console.log('\n📋 Friendships Endpoints:');
  
  await test('GET /friendships - список друзей', async () => {
    if (!testUserToken) throw new Error('No token');
    const response = await axios.get(`${BASE_URL}/friendships`, { headers });
    if (response.status !== 200 || !response.data.data) {
      throw new Error('Get friendships failed');
    }
  });

  // ============ COMMENTS TESTS ============
  console.log('\n📋 Comments Endpoints:');
  
  if (postId) {
    await test('GET /comments - комментарии к посту', async () => {
      if (!testUserToken) throw new Error('No token');
      const response = await axios.get(`${BASE_URL}/comments?post_id=${postId}`, { headers });
      if (response.status !== 200 || !response.data.data) {
        throw new Error('Get comments failed');
      }
    });
  }

  // ============ NOTIFICATIONS TESTS ============
  console.log('\n📋 Notifications Endpoints:');
  
  await test('GET /notifications - список уведомлений', async () => {
    if (!testUserToken) throw new Error('No token');
    const response = await axios.get(`${BASE_URL}/notifications`, { headers });
    if (response.status !== 200 || !response.data.data) {
      throw new Error('Get notifications failed');
    }
  });

  await test('GET /notifications/unread-count - количество непрочитанных', async () => {
    if (!testUserToken) throw new Error('No token');
    const response = await axios.get(`${BASE_URL}/notifications/unread-count`, { headers });
    if (response.status !== 200 || typeof response.data.count !== 'number') {
      throw new Error('Get unread count failed');
    }
  });

  // ============ SUMMARY ============
  console.log('\n' + '='.repeat(60));
  console.log('📊 ИТОГИ ПРОВЕРКИ API');
  console.log('='.repeat(60));

  const passed = results.filter((r) => r.status === 'PASS').length;
  const failed = results.filter((r) => r.status === 'FAIL').length;
  const skipped = results.filter((r) => r.status === 'SKIP').length;
  const total = results.length;

  console.log(`✅ Успешно: ${passed}`);
  console.log(`❌ Провалено: ${failed}`);
  console.log(`⏭️  Пропущено: ${skipped}`);
  console.log(`📊 Всего: ${total}`);

  if (failed > 0) {
    console.log('\n❌ Проваленные тесты:');
    results
      .filter((r) => r.status === 'FAIL')
      .forEach((r) => {
        console.log(`   - ${r.name}: ${r.message}`);
      });
  }

  const avgDuration = results.reduce((sum, r) => sum + (r.duration || 0), 0) / total;
  console.log(`\n⏱️  Среднее время выполнения: ${Math.round(avgDuration)}ms`);

  process.exit(failed > 0 ? 1 : 0);
}

main().catch((error) => {
  console.error('Fatal error:', error);
  process.exit(1);
});
