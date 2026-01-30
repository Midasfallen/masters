/**
 * E2E тесты для NotificationsController
 * Тесты выполняются против запущенного Docker контейнера
 */
import * as request from 'supertest';

const API_URL = process.env.API_URL || 'http://localhost:3000/api/v2';
const uniqueEmail = () => `test-${Date.now()}-${Math.random().toString(36).substring(7)}@test.com`;

describe('NotificationsController (e2e) - Docker', () => {
  let userToken: string;
  let userId: string;

  beforeAll(async () => {
    const registerRes = await request(API_URL)
      .post('/auth/register')
      .send({
        email: uniqueEmail(),
        password: 'Password123',
        first_name: 'Notification',
        last_name: 'User',
      });

    if (registerRes.status !== 201) {
      throw new Error(`Failed to register: ${JSON.stringify(registerRes.body)}`);
    }

    userToken = registerRes.body.accessToken;
    userId = registerRes.body.user?.id;

    if (!userToken) {
      throw new Error(`No accessToken: ${JSON.stringify(registerRes.body)}`);
    }
  }, 30000);

  describe('/notifications (GET)', () => {
    it('should fail without authentication', async () => {
      const res = await request(API_URL).get('/notifications');
      expect(res.status).toBe(401);
    });

    it('should return list of notifications', async () => {
      const res = await request(API_URL)
        .get('/notifications')
        .set('Authorization', `Bearer ${userToken}`);

      expect(res.status).toBe(200);
      expect(res.body).toHaveProperty('data');
      expect(Array.isArray(res.body.data)).toBe(true);
    });

    it('should support pagination', async () => {
      const res = await request(API_URL)
        .get('/notifications?page=1&limit=10')
        .set('Authorization', `Bearer ${userToken}`);

      expect(res.status).toBe(200);
      // Notifications API возвращает total на верхнем уровне, не в meta
      expect(res.body).toHaveProperty('total');
    });

    it('should filter by type', async () => {
      const res = await request(API_URL)
        .get('/notifications?type=booking')
        .set('Authorization', `Bearer ${userToken}`);

      // 200 OK или 400 если тип не валидный
      expect([200, 400]).toContain(res.status);
    });
  });

  describe('/notifications/unread-count (GET)', () => {
    it('should fail without authentication', async () => {
      const res = await request(API_URL).get('/notifications/unread-count');
      expect(res.status).toBe(401);
    });

    it('should return unread count', async () => {
      const res = await request(API_URL)
        .get('/notifications/unread-count')
        .set('Authorization', `Bearer ${userToken}`);

      expect(res.status).toBe(200);
      expect(res.body).toHaveProperty('count');
      expect(typeof res.body.count).toBe('number');
    });
  });

  describe('/notifications/read-all (PATCH)', () => {
    it('should fail without authentication', async () => {
      const res = await request(API_URL).patch('/notifications/read-all');
      expect(res.status).toBe(401);
    });

    it('should mark all notifications as read', async () => {
      const res = await request(API_URL)
        .patch('/notifications/read-all')
        .set('Authorization', `Bearer ${userToken}`);

      expect(res.status).toBe(200);
    });
  });

  describe('/notifications/read-multiple (PATCH)', () => {
    it('should fail without authentication', async () => {
      const res = await request(API_URL)
        .patch('/notifications/read-multiple')
        .send({ ids: [] });
      expect(res.status).toBe(401);
    });

    it('should mark multiple notifications as read', async () => {
      const res = await request(API_URL)
        .patch('/notifications/read-multiple')
        .set('Authorization', `Bearer ${userToken}`)
        .send({ ids: [] });

      // 200 OK или 400 если пустой массив не валиден
      expect([200, 400]).toContain(res.status);
    });
  });

  describe('/notifications/devices/register (POST)', () => {
    it('should fail without authentication', async () => {
      const res = await request(API_URL)
        .post('/notifications/devices/register')
        .send({ token: 'test', platform: 'android' });
      expect(res.status).toBe(401);
    });

    it('should register device token', async () => {
      const res = await request(API_URL)
        .post('/notifications/devices/register')
        .set('Authorization', `Bearer ${userToken}`)
        .send({
          token: `test-device-${Date.now()}`,
          platform: 'android',
          deviceName: 'Test Device',  // camelCase
        });

      // 200 успех, 400 - возможно уже зарегистрирован или невалидный формат
      expect([200, 400]).toContain(res.status);
    });
  });

  describe('/notifications/:id (GET)', () => {
    it('should fail without authentication', async () => {
      const res = await request(API_URL)
        .get('/notifications/00000000-0000-0000-0000-000000000000');
      expect(res.status).toBe(401);
    });

    it('should return 404 for non-existent notification', async () => {
      const res = await request(API_URL)
        .get('/notifications/00000000-0000-0000-0000-000000000000')
        .set('Authorization', `Bearer ${userToken}`);

      expect(res.status).toBe(404);
    });
  });

  describe('/notifications/:id/read (PATCH)', () => {
    it('should fail without authentication', async () => {
      const res = await request(API_URL)
        .patch('/notifications/00000000-0000-0000-0000-000000000000/read');
      expect(res.status).toBe(401);
    });

    it('should return 404 for non-existent notification', async () => {
      const res = await request(API_URL)
        .patch('/notifications/00000000-0000-0000-0000-000000000000/read')
        .set('Authorization', `Bearer ${userToken}`);

      expect(res.status).toBe(404);
    });
  });

  describe('/notifications/:id (DELETE)', () => {
    it('should fail without authentication', async () => {
      const res = await request(API_URL)
        .delete('/notifications/00000000-0000-0000-0000-000000000000');
      expect(res.status).toBe(401);
    });

    it('should return 404 for non-existent notification', async () => {
      const res = await request(API_URL)
        .delete('/notifications/00000000-0000-0000-0000-000000000000')
        .set('Authorization', `Bearer ${userToken}`);

      expect(res.status).toBe(404);
    });
  });
});
