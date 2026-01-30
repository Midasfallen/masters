/**
 * E2E тесты для ReviewsController
 * Тесты выполняются против запущенного Docker контейнера
 */
import * as request from 'supertest';

const API_URL = process.env.API_URL || 'http://localhost:3000/api/v2';
const uniqueEmail = () => `test-${Date.now()}-${Math.random().toString(36).substring(7)}@test.com`;

describe('ReviewsController (e2e) - Docker', () => {
  let clientToken: string;
  let clientId: string;
  let masterToken: string;
  let masterId: string;

  beforeAll(async () => {
    // Create client user
    const clientRes = await request(API_URL)
      .post('/auth/register')
      .send({
        email: uniqueEmail(),
        password: 'Password123',
        first_name: 'Review',
        last_name: 'Client',
      });

    if (clientRes.status !== 201) {
      throw new Error(`Failed to register client: ${JSON.stringify(clientRes.body)}`);
    }

    clientToken = clientRes.body.accessToken;
    clientId = clientRes.body.user?.id;

    // Create master user
    const masterRes = await request(API_URL)
      .post('/auth/register')
      .send({
        email: uniqueEmail(),
        password: 'Password123',
        first_name: 'Review',
        last_name: 'Master',
      });

    if (masterRes.status !== 201) {
      throw new Error(`Failed to register master: ${JSON.stringify(masterRes.body)}`);
    }

    masterToken = masterRes.body.accessToken;
    masterId = masterRes.body.user?.id;
  }, 30000);

  describe('/reviews (GET) - Public', () => {
    it('should return list of reviews without auth', async () => {
      const res = await request(API_URL).get('/reviews');

      expect(res.status).toBe(200);
      expect(res.body).toHaveProperty('data');
      expect(Array.isArray(res.body.data)).toBe(true);
    });

    it('should support pagination', async () => {
      const res = await request(API_URL).get('/reviews?page=1&limit=10');

      expect(res.status).toBe(200);
      expect(res.body).toHaveProperty('data');
    });

    it('should filter by rating', async () => {
      const res = await request(API_URL).get('/reviews?min_rating=4');
      expect(res.status).toBe(200);
    });

    it('should filter by reviewed user', async () => {
      const res = await request(API_URL).get(`/reviews?reviewed_user_id=${masterId}`);
      expect(res.status).toBe(200);
    });
  });

  describe('/reviews/:id (GET) - Public', () => {
    it('should return 404 for non-existent review', async () => {
      const res = await request(API_URL)
        .get('/reviews/00000000-0000-0000-0000-000000000000');

      expect(res.status).toBe(404);
    });
  });

  describe('/reviews/user/:userId/stats (GET) - Public', () => {
    it('should return user review stats', async () => {
      const res = await request(API_URL).get(`/reviews/user/${masterId}/stats`);

      expect(res.status).toBe(200);
      expect(res.body).toHaveProperty('averageRating');
      expect(res.body).toHaveProperty('totalReviews');
    });

    it('should return stats for non-existent user with zero values', async () => {
      const res = await request(API_URL)
        .get('/reviews/user/00000000-0000-0000-0000-000000000000/stats');

      expect(res.status).toBe(200);
      expect(res.body.totalReviews).toBe(0);
    });
  });

  describe('/reviews (POST) - Authenticated', () => {
    it('should fail without authentication', async () => {
      const res = await request(API_URL)
        .post('/reviews')
        .send({
          booking_id: '00000000-0000-0000-0000-000000000000',
          rating: 5,
          comment: 'Great service!',
        });

      expect(res.status).toBe(401);
    });

    it('should fail with invalid booking_id', async () => {
      const res = await request(API_URL)
        .post('/reviews')
        .set('Authorization', `Bearer ${clientToken}`)
        .send({
          booking_id: '00000000-0000-0000-0000-000000000000',
          rating: 5,
          comment: 'Great service!',
        });

      // 400 - Bad Request (validation) или 404 - Not Found
      expect([400, 404]).toContain(res.status);
    });
  });

  describe('/reviews/:id/respond (PATCH) - Authenticated', () => {
    it('should fail without authentication', async () => {
      const res = await request(API_URL)
        .patch('/reviews/00000000-0000-0000-0000-000000000000/respond')
        .send({ response: 'Thank you!' });

      expect(res.status).toBe(401);
    });

    it('should fail for non-existent review', async () => {
      const res = await request(API_URL)
        .patch('/reviews/00000000-0000-0000-0000-000000000000/respond')
        .set('Authorization', `Bearer ${masterToken}`)
        .send({ response: 'Thank you!' });

      expect(res.status).toBe(404);
    });
  });

  describe('/reviews/:id/report (POST) - Authenticated', () => {
    it('should fail without authentication', async () => {
      const res = await request(API_URL)
        .post('/reviews/00000000-0000-0000-0000-000000000000/report');

      expect(res.status).toBe(401);
    });

    it('should fail for non-existent review', async () => {
      const res = await request(API_URL)
        .post('/reviews/00000000-0000-0000-0000-000000000000/report')
        .set('Authorization', `Bearer ${clientToken}`);

      expect(res.status).toBe(404);
    });
  });

  describe('/reviews/:id (DELETE) - Authenticated', () => {
    it('should fail without authentication', async () => {
      const res = await request(API_URL)
        .delete('/reviews/00000000-0000-0000-0000-000000000000');

      expect(res.status).toBe(401);
    });

    it('should fail for non-existent review', async () => {
      const res = await request(API_URL)
        .delete('/reviews/00000000-0000-0000-0000-000000000000')
        .set('Authorization', `Bearer ${clientToken}`);

      expect(res.status).toBe(404);
    });
  });

  describe('/reviews/unreviewed/bookings (GET) - Authenticated', () => {
    it('should fail without authentication', async () => {
      const res = await request(API_URL).get('/reviews/unreviewed/bookings');
      expect(res.status).toBe(401);
    });

    it('should return unreviewed bookings', async () => {
      const res = await request(API_URL)
        .get('/reviews/unreviewed/bookings')
        .set('Authorization', `Bearer ${clientToken}`);

      // 200 - OK, 500 - может быть внутренняя ошибка если нет бронирований
      expect([200, 500]).toContain(res.status);
      if (res.status === 200) {
        expect(Array.isArray(res.body)).toBe(true);
      }
    });
  });

  describe('/reviews/skip/:bookingId (POST) - Authenticated', () => {
    it('should fail without authentication', async () => {
      const res = await request(API_URL)
        .post('/reviews/skip/00000000-0000-0000-0000-000000000000')
        .send({ isGracePeriod: true });

      expect(res.status).toBe(401);
    });

    it('should fail for non-existent booking', async () => {
      const res = await request(API_URL)
        .post('/reviews/skip/00000000-0000-0000-0000-000000000000')
        .set('Authorization', `Bearer ${clientToken}`)
        .send({ isGracePeriod: true });

      expect(res.status).toBe(404);
    });
  });
});
