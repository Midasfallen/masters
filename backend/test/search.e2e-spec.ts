import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from './../src/app.module';

describe('SearchController (e2e)', () => {
  let app: INestApplication;

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
  }, 30000);

  afterAll(async () => {
    if (app) {
      await app.close();
    }
  }, 10000);

  describe('GET /search/templates', () => {
    it('should return paginated template search results', () => {
      return request(app.getHttpServer())
        .get('/search/templates?page=1&limit=5')
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('data');
          expect(Array.isArray(res.body.data)).toBe(true);
          expect(res.body).toHaveProperty('total');
          expect(res.body).toHaveProperty('page', 1);
          expect(res.body).toHaveProperty('limit', 5);
          expect(res.body).toHaveProperty('processing_time_ms');
          if (res.body.data.length > 0) {
            const t = res.body.data[0];
            expect(t).toHaveProperty('id');
            expect(t).toHaveProperty('slug');
            expect(t).toHaveProperty('name');
            expect(t).toHaveProperty('category_id');
          }
        });
    });

    it('should accept query q and return results', () => {
      const query = encodeURIComponent('стрижка');
      return request(app.getHttpServer())
        .get(`/search/templates?q=${query}&limit=3`)
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('data');
          expect(res.body).toHaveProperty('query');
        });
    });

    it('should accept category_id filter', async () => {
      const res = await request(app.getHttpServer())
        .get('/search/templates?limit=2')
        .expect(200);
      const firstCategoryId =
        res.body.data && res.body.data[0]
          ? res.body.data[0].category_id
          : null;
      if (!firstCategoryId) return;
      await request(app.getHttpServer())
        .get(`/search/templates?category_id=${firstCategoryId}&limit=2`)
        .expect(200)
        .expect((r) => {
          expect(r.body.data.every((t: any) => t.category_id === firstCategoryId)).toBe(true);
        });
    });
  });

  describe('GET /search/masters', () => {
    it('should return 200 and paginated structure', () => {
      return request(app.getHttpServer())
        .get('/search/masters?page=1&limit=5')
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('data');
          expect(Array.isArray(res.body.data)).toBe(true);
          expect(res.body).toHaveProperty('total');
          expect(res.body).toHaveProperty('page', 1);
          expect(res.body).toHaveProperty('limit', 5);
        });
    });
  });

  describe('GET /search/services', () => {
    it('should return 200 and paginated structure', () => {
      return request(app.getHttpServer())
        .get('/search/services?page=1&limit=5')
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('data');
          expect(Array.isArray(res.body.data)).toBe(true);
          expect(res.body).toHaveProperty('total');
          expect(res.body).toHaveProperty('page', 1);
          expect(res.body).toHaveProperty('limit', 5);
        });
    });
  });
});
