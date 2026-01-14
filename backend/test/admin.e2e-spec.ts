import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from './../src/app.module';
import { Repository } from 'typeorm';
import { User } from '../src/modules/users/entities/user.entity';
import { getRepositoryToken } from '@nestjs/typeorm';

// Helper to generate unique email
const uniqueEmail = (prefix: string) => `${prefix}-${Date.now()}-${Math.random().toString(36).substring(7)}@example.com`;

describe('AdminController (e2e)', () => {
  let app: INestApplication;
  let adminToken: string;
  let userToken: string;
  let regularUserId: string;
  let userRepository: Repository<User>;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    app.useGlobalPipes(
      new ValidationPipe({
        whitelist: true,
        forbidNonWhitelisted: true,
        transform: true,
      }),
    );
    await app.init();

    userRepository = moduleFixture.get<Repository<User>>(
      getRepositoryToken(User),
    );

    // Create regular user
    const userResponse = await request(app.getHttpServer())
      .post('/auth/register')
      .send({
        email: uniqueEmail('user'),
        password: 'Password123',
        first_name: 'Regular',
        last_name: 'User',
        phone: `+7999${Math.floor(Math.random() * 10000000)}`,
      });
    userToken = userResponse.body.access_token;
    regularUserId = userResponse.body.user.id;

    // Create admin user
    const adminResponse = await request(app.getHttpServer())
      .post('/auth/register')
      .send({
        email: uniqueEmail('admin'),
        password: 'AdminPass123',
        first_name: 'Admin',
        last_name: 'User',
        phone: `+7999${Math.floor(Math.random() * 10000000)}`,
      });
    adminToken = adminResponse.body.access_token;

    // Manually set is_admin flag (in real app, this would be done through database migration or admin panel)
    await userRepository.update(
      { id: adminResponse.body.user.id },
      { is_admin: true },
    );
  }, 30000);

  afterAll(async () => {
    if (app) {
      await app.close();
    }
  }, 10000);

  describe('/admin/stats (GET)', () => {
    it('should get platform statistics as admin', () => {
      return request(app.getHttpServer())
        .get('/admin/stats')
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('totalUsers');
          expect(res.body).toHaveProperty('totalMasters');
          expect(res.body).toHaveProperty('totalBookings');
          expect(res.body).toHaveProperty('totalRevenue');
          expect(res.body).toHaveProperty('activeUsersToday');
          expect(res.body).toHaveProperty('newUsersThisWeek');
          expect(res.body).toHaveProperty('bookingsToday');
          expect(res.body).toHaveProperty('averageRating');
          expect(res.body).toHaveProperty('totalReviews');
          expect(typeof res.body.totalUsers).toBe('number');
          expect(typeof res.body.totalRevenue).toBe('number');
        });
    });

    it('should fail for regular user', () => {
      return request(app.getHttpServer())
        .get('/admin/stats')
        .set('Authorization', `Bearer ${userToken}`)
        .expect(403);
    });

    it('should fail without authentication', () => {
      return request(app.getHttpServer()).get('/admin/stats').expect(401);
    });
  });

  describe('/admin/users (GET)', () => {
    it('should get users list with pagination as admin', () => {
      return request(app.getHttpServer())
        .get('/admin/users?page=1&limit=50')
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200)
        .expect((res) => {
          expect(Array.isArray(res.body.users)).toBe(true);
          expect(res.body).toHaveProperty('total');
          expect(res.body).toHaveProperty('page', 1);
          expect(res.body).toHaveProperty('limit', 50);
          expect(res.body.users.length).toBeGreaterThan(0);

          // Verify user structure
          const user = res.body.users[0];
          expect(user).toHaveProperty('id');
          expect(user).toHaveProperty('email');
          expect(user).toHaveProperty('first_name');
          expect(user).toHaveProperty('last_name');
          expect(user).toHaveProperty('is_master');
          expect(user).toHaveProperty('is_admin');
          expect(user).toHaveProperty('is_active');
          expect(user).toHaveProperty('created_at');
        });
    });

    it('should support custom page size', () => {
      return request(app.getHttpServer())
        .get('/admin/users?page=1&limit=10')
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200)
        .expect((res) => {
          expect(res.body.limit).toBe(10);
          expect(res.body.users.length).toBeLessThanOrEqual(10);
        });
    });

    it('should fail for regular user', () => {
      return request(app.getHttpServer())
        .get('/admin/users')
        .set('Authorization', `Bearer ${userToken}`)
        .expect(403);
    });
  });

  describe('/admin/bookings/recent (GET)', () => {
    it('should get recent bookings as admin', () => {
      return request(app.getHttpServer())
        .get('/admin/bookings/recent?limit=20')
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200)
        .expect((res) => {
          expect(Array.isArray(res.body)).toBe(true);
          // Each booking should have these properties
          if (res.body.length > 0) {
            const booking = res.body[0];
            expect(booking).toHaveProperty('id');
            expect(booking).toHaveProperty('status');
            expect(booking).toHaveProperty('total_price');
            expect(booking).toHaveProperty('scheduled_for');
            expect(booking).toHaveProperty('client');
            expect(booking).toHaveProperty('master');
          }
        });
    });

    it('should fail for regular user', () => {
      return request(app.getHttpServer())
        .get('/admin/bookings/recent')
        .set('Authorization', `Bearer ${userToken}`)
        .expect(403);
    });
  });

  describe('/admin/users/:id/status (POST)', () => {
    it('should update user status as admin', () => {
      return request(app.getHttpServer())
        .post(`/admin/users/${regularUserId}/status`)
        .set('Authorization', `Bearer ${adminToken}`)
        .send({
          isActive: false, // Changed to camelCase
          reason: 'Suspicious activity detected',
        })
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('id', regularUserId);
          expect(res.body).toHaveProperty('is_active', false);
        });
    });

    it('should reactivate user', () => {
      return request(app.getHttpServer())
        .post(`/admin/users/${regularUserId}/status`)
        .set('Authorization', `Bearer ${adminToken}`)
        .send({
          isActive: true, // Changed to camelCase
          reason: 'Issue resolved',
        })
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('is_active', true);
        });
    });

    it('should promote user to admin', () => {
      return request(app.getHttpServer())
        .post(`/admin/users/${regularUserId}/status`)
        .set('Authorization', `Bearer ${adminToken}`)
        .send({
          isAdmin: true, // Changed to camelCase
          reason: 'Promoted to admin role',
        })
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('is_admin', true);
        });
    });

    it('should fail for regular user', () => {
      return request(app.getHttpServer())
        .post(`/admin/users/${regularUserId}/status`)
        .set('Authorization', `Bearer ${userToken}`)
        .send({
          is_active: false,
        })
        .expect(403);
    });

    it('should fail with non-existent user', () => {
      return request(app.getHttpServer())
        .post('/admin/users/00000000-0000-0000-0000-000000000000/status')
        .set('Authorization', `Bearer ${adminToken}`)
        .send({
          isActive: false, // Changed to camelCase
          reason: 'Test',
        })
        .expect(404);
    });
  });

  describe('/admin/health (GET)', () => {
    it('should get system health as admin', () => {
      return request(app.getHttpServer())
        .get('/admin/health')
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('status');
          expect(res.body).toHaveProperty('database');
          expect(res.body).toHaveProperty('uptime');
          expect(res.body).toHaveProperty('memoryUsage');
          expect(['healthy', 'degraded', 'down']).toContain(res.body.status);
          expect(['connected', 'disconnected']).toContain(res.body.database);
          expect(typeof res.body.uptime).toBe('number');
          expect(res.body.memoryUsage).toHaveProperty('heapUsed');
          expect(res.body.memoryUsage).toHaveProperty('heapTotal');
        });
    });

    it('should fail for regular user', () => {
      return request(app.getHttpServer())
        .get('/admin/health')
        .set('Authorization', `Bearer ${userToken}`)
        .expect(403);
    });
  });

  describe('/admin/analytics (GET)', () => {
    it('should get platform analytics as admin', () => {
      return request(app.getHttpServer())
        .get('/admin/analytics?days=30')
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200)
        .expect((res) => {
          expect(Array.isArray(res.body.dailyStats)).toBe(true);
          expect(res.body).toHaveProperty('totalUsers');
          expect(res.body).toHaveProperty('totalBookings');
          expect(res.body).toHaveProperty('totalRevenue');

          // Check daily stats structure
          if (res.body.dailyStats.length > 0) {
            const dayStat = res.body.dailyStats[0];
            expect(dayStat).toHaveProperty('date');
            expect(dayStat).toHaveProperty('newUsers');
            expect(dayStat).toHaveProperty('newBookings');
            expect(dayStat).toHaveProperty('revenue');
          }
        });
    });

    it('should support custom days range', () => {
      return request(app.getHttpServer())
        .get('/admin/analytics?days=7')
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200)
        .expect((res) => {
          expect(res.body.dailyStats.length).toBeLessThanOrEqual(7);
        });
    });

    it('should fail for regular user', () => {
      return request(app.getHttpServer())
        .get('/admin/analytics')
        .set('Authorization', `Bearer ${userToken}`)
        .expect(403);
    });
  });

  describe('/admin/users/:id (DELETE)', () => {
    let deleteUserId: string;

    beforeAll(async () => {
      const response = await request(app.getHttpServer())
        .post('/auth/register')
        .send({
          email: `delete${Date.now()}@example.com`,
          password: 'Password123',
          first_name: 'Delete',
          last_name: 'Me',
        });
      deleteUserId = response.body.user.id;
    });

    it('should delete user as admin', () => {
      return request(app.getHttpServer())
        .delete(`/admin/users/${deleteUserId}`)
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200);
    });

    it('should fail to delete non-existent user', () => {
      return request(app.getHttpServer())
        .delete(`/admin/users/${deleteUserId}`)
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(404);
    });

    it('should fail for regular user', () => {
      return request(app.getHttpServer())
        .delete(`/admin/users/${regularUserId}`)
        .set('Authorization', `Bearer ${userToken}`)
        .expect(403);
    });
  });
});
