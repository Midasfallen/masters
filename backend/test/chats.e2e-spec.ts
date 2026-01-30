/**
 * E2E тесты для ChatsController
 * Тесты выполняются против запущенного Docker контейнера
 * Запуск: npm run test:e2e -- --testPathPattern="chats"
 */
import * as request from 'supertest';

// API базовый URL (Docker контейнер)
const API_URL = process.env.API_URL || 'http://localhost:3000/api/v2';

// Helper to generate unique email
const uniqueEmail = () => `test-${Date.now()}-${Math.random().toString(36).substring(7)}@test.com`;

describe('ChatsController (e2e) - Docker', () => {
  let user1Token: string;
  let user2Token: string;
  let user1Id: string;
  let user2Id: string;
  let chatId: string;

  beforeAll(async () => {
    // Register user 1
    const user1Email = uniqueEmail();
    const register1Res = await request(API_URL)
      .post('/auth/register')
      .send({
        email: user1Email,
        password: 'Password123',
        first_name: 'Chat',
        last_name: 'User1',
      });

    console.log('Register user1 response:', register1Res.status);

    if (register1Res.status !== 201) {
      throw new Error(`Failed to register user1: ${JSON.stringify(register1Res.body)}`);
    }

    user1Token = register1Res.body.accessToken;
    user1Id = register1Res.body.user?.id;

    if (!user1Token) {
      throw new Error(`No accessToken for user1: ${JSON.stringify(register1Res.body)}`);
    }

    // Register user 2
    const user2Email = uniqueEmail();
    const register2Res = await request(API_URL)
      .post('/auth/register')
      .send({
        email: user2Email,
        password: 'Password123',
        first_name: 'Chat',
        last_name: 'User2',
      });

    console.log('Register user2 response:', register2Res.status);

    if (register2Res.status !== 201) {
      throw new Error(`Failed to register user2: ${JSON.stringify(register2Res.body)}`);
    }

    user2Token = register2Res.body.accessToken;
    user2Id = register2Res.body.user?.id;

    if (!user2Token) {
      throw new Error(`No accessToken for user2: ${JSON.stringify(register2Res.body)}`);
    }

    console.log('Users created:', { user1Id, user2Id });
  }, 60000);

  describe('/chats (GET) - Unauthorized', () => {
    it('should fail without authentication', async () => {
      const res = await request(API_URL).get('/chats');
      expect(res.status).toBe(401);
    });
  });

  describe('/chats (GET) - Authorized', () => {
    it('should return list of user chats', async () => {
      const res = await request(API_URL)
        .get('/chats')
        .set('Authorization', `Bearer ${user1Token}`);

      expect(res.status).toBe(200);
      expect(res.body).toHaveProperty('data');
      expect(Array.isArray(res.body.data)).toBe(true);
    });

    it('should support pagination', async () => {
      const res = await request(API_URL)
        .get('/chats?page=1&limit=10')
        .set('Authorization', `Bearer ${user1Token}`);

      expect(res.status).toBe(200);
      expect(res.body).toHaveProperty('data');
      // meta.total вместо total
      expect(res.body).toHaveProperty('meta');
      expect(res.body.meta).toHaveProperty('total');
    });
  });

  describe('/chats (POST)', () => {
    it('should fail without authentication', async () => {
      const res = await request(API_URL)
        .post('/chats')
        .send({
          type: 'direct',
          participant_ids: [user2Id],
        });

      expect(res.status).toBe(401);
    });

    it('should create a new direct chat', async () => {
      const res = await request(API_URL)
        .post('/chats')
        .set('Authorization', `Bearer ${user1Token}`)
        .send({
          type: 'direct',
          participant_ids: [user2Id],
        });

      console.log('Create chat response:', res.status, JSON.stringify(res.body));

      expect(res.status).toBe(201);
      expect(res.body).toHaveProperty('id');
      chatId = res.body.id;
    });

    it('should fail with non-existent participant', async () => {
      const res = await request(API_URL)
        .post('/chats')
        .set('Authorization', `Bearer ${user1Token}`)
        .send({
          type: 'direct',
          participant_ids: ['00000000-0000-0000-0000-000000000000'],
        });

      expect([400, 404]).toContain(res.status);
    });
  });

  describe('/chats/:id (GET)', () => {
    it('should return chat by ID', async () => {
      if (!chatId) {
        console.log('Skipping - no chatId');
        return;
      }

      const res = await request(API_URL)
        .get(`/chats/${chatId}`)
        .set('Authorization', `Bearer ${user1Token}`);

      expect(res.status).toBe(200);
      expect(res.body).toHaveProperty('id', chatId);
    });

    it('should allow participant to access chat', async () => {
      if (!chatId) {
        console.log('Skipping - no chatId');
        return;
      }

      const res = await request(API_URL)
        .get(`/chats/${chatId}`)
        .set('Authorization', `Bearer ${user2Token}`);

      expect(res.status).toBe(200);
    });

    it('should fail without authentication', async () => {
      const res = await request(API_URL)
        .get(`/chats/${chatId || '00000000-0000-0000-0000-000000000000'}`);

      expect(res.status).toBe(401);
    });

    it('should return 404 for non-existent chat', async () => {
      const res = await request(API_URL)
        .get('/chats/00000000-0000-0000-0000-000000000000')
        .set('Authorization', `Bearer ${user1Token}`);

      expect(res.status).toBe(404);
    });
  });

  describe('/chats/:id/pin (POST)', () => {
    it('should pin chat', async () => {
      if (!chatId) {
        console.log('Skipping - no chatId');
        return;
      }

      const res = await request(API_URL)
        .post(`/chats/${chatId}/pin`)
        .set('Authorization', `Bearer ${user1Token}`);

      expect([200, 201]).toContain(res.status);
    });
  });

  describe('/chats/:id/unpin (POST)', () => {
    it('should unpin chat', async () => {
      if (!chatId) {
        console.log('Skipping - no chatId');
        return;
      }

      const res = await request(API_URL)
        .post(`/chats/${chatId}/unpin`)
        .set('Authorization', `Bearer ${user1Token}`);

      expect([200, 201]).toContain(res.status);
    });
  });

  describe('/chats/:id/read (POST)', () => {
    it('should fail without authentication', async () => {
      const res = await request(API_URL)
        .post(`/chats/${chatId || '00000000-0000-0000-0000-000000000000'}/read`)
        .send({});

      expect(res.status).toBe(401);
    });

    it('should mark messages as read', async () => {
      if (!chatId) {
        console.log('Skipping - no chatId');
        return;
      }

      const res = await request(API_URL)
        .post(`/chats/${chatId}/read`)
        .set('Authorization', `Bearer ${user1Token}`)
        .send({});

      // 200 или 201 - успех, 400 - нет сообщений для прочтения (тоже валидно)
      expect([200, 201, 400]).toContain(res.status);
    });
  });

  describe('/chats/:id (DELETE)', () => {
    it('should fail without authentication', async () => {
      const res = await request(API_URL)
        .delete(`/chats/${chatId || '00000000-0000-0000-0000-000000000000'}`);

      expect(res.status).toBe(401);
    });

    it('should allow user to leave chat', async () => {
      if (!chatId) {
        console.log('Skipping - no chatId');
        return;
      }

      const res = await request(API_URL)
        .delete(`/chats/${chatId}`)
        .set('Authorization', `Bearer ${user1Token}`);

      expect(res.status).toBe(200);
    });
  });
});
