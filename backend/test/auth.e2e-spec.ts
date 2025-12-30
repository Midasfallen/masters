import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from './../src/app.module';

describe('AuthController (e2e)', () => {
  let app: INestApplication;
  let accessToken: string;
  let refreshToken: string;

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
  });

  afterAll(async () => {
    await app.close();
  });

  describe('/auth/register (POST)', () => {
    it('should register a new user', () => {
      return request(app.getHttpServer())
        .post('/auth/register')
        .send({
          email: `test${Date.now()}@example.com`,
          password: 'Password123',
          first_name: 'Test',
          last_name: 'User',
          phone: '+79991234567',
        })
        .expect(201)
        .expect((res) => {
          expect(res.body).toHaveProperty('access_token');
          expect(res.body).toHaveProperty('refresh_token');
          expect(res.body).toHaveProperty('user');
          expect(res.body.user).not.toHaveProperty('password_hash');
          accessToken = res.body.access_token;
          refreshToken = res.body.refresh_token;
        });
    });

    it('should fail with invalid email', () => {
      return request(app.getHttpServer())
        .post('/auth/register')
        .send({
          email: 'invalid-email',
          password: 'Password123',
          first_name: 'Test',
          last_name: 'User',
        })
        .expect(400);
    });

    it('should fail with weak password', () => {
      return request(app.getHttpServer())
        .post('/auth/register')
        .send({
          email: 'test@example.com',
          password: '123',
          first_name: 'Test',
          last_name: 'User',
        })
        .expect(400);
    });

    it('should fail when email already exists', () => {
      const email = `duplicate${Date.now()}@example.com`;

      // First registration
      return request(app.getHttpServer())
        .post('/auth/register')
        .send({
          email,
          password: 'Password123',
          first_name: 'Test',
          last_name: 'User',
        })
        .expect(201)
        .then(() => {
          // Second registration with same email
          return request(app.getHttpServer())
            .post('/auth/register')
            .send({
              email,
              password: 'Password123',
              first_name: 'Test2',
              last_name: 'User2',
            })
            .expect(409); // Conflict
        });
    });
  });

  describe('/auth/login (POST)', () => {
    const testEmail = `login${Date.now()}@example.com`;
    const testPassword = 'Password123';

    beforeAll(async () => {
      // Create test user
      await request(app.getHttpServer())
        .post('/auth/register')
        .send({
          email: testEmail,
          password: testPassword,
          first_name: 'Login',
          last_name: 'Test',
        });
    });

    it('should login with valid credentials', () => {
      return request(app.getHttpServer())
        .post('/auth/login')
        .send({
          email: testEmail,
          password: testPassword,
        })
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('access_token');
          expect(res.body).toHaveProperty('refresh_token');
          expect(res.body).toHaveProperty('user');
        });
    });

    it('should fail with invalid email', () => {
      return request(app.getHttpServer())
        .post('/auth/login')
        .send({
          email: 'wrong@example.com',
          password: testPassword,
        })
        .expect(401);
    });

    it('should fail with invalid password', () => {
      return request(app.getHttpServer())
        .post('/auth/login')
        .send({
          email: testEmail,
          password: 'WrongPassword123',
        })
        .expect(401);
    });
  });

  describe('/auth/refresh (POST)', () => {
    it('should refresh tokens with valid refresh token', async () => {
      // First, register and get tokens
      const registerResponse = await request(app.getHttpServer())
        .post('/auth/register')
        .send({
          email: `refresh${Date.now()}@example.com`,
          password: 'Password123',
          first_name: 'Refresh',
          last_name: 'Test',
        });

      const { refresh_token } = registerResponse.body;

      // Then refresh
      return request(app.getHttpServer())
        .post('/auth/refresh')
        .send({
          refresh_token,
        })
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('access_token');
          expect(res.body).toHaveProperty('refresh_token');
          expect(res.body.refresh_token).not.toBe(refresh_token); // Should be different
        });
    });

    it('should fail with invalid refresh token', () => {
      return request(app.getHttpServer())
        .post('/auth/refresh')
        .send({
          refresh_token: 'invalid_token',
        })
        .expect(401);
    });
  });

  describe('/users/me (GET)', () => {
    it('should get current user with valid token', async () => {
      // Register and get token
      const registerResponse = await request(app.getHttpServer())
        .post('/auth/register')
        .send({
          email: `me${Date.now()}@example.com`,
          password: 'Password123',
          first_name: 'Me',
          last_name: 'Test',
        });

      const { access_token } = registerResponse.body;

      return request(app.getHttpServer())
        .get('/users/me')
        .set('Authorization', `Bearer ${access_token}`)
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('id');
          expect(res.body).toHaveProperty('email');
          expect(res.body).not.toHaveProperty('password_hash');
        });
    });

    it('should fail without token', () => {
      return request(app.getHttpServer()).get('/users/me').expect(401);
    });

    it('should fail with invalid token', () => {
      return request(app.getHttpServer())
        .get('/users/me')
        .set('Authorization', 'Bearer invalid_token')
        .expect(401);
    });
  });
});
