import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from './../src/app.module';

describe('CategoriesController (e2e)', () => {
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

  describe('GET /categories/tree', () => {
    it('should return tree with only level 0 and level 1 categories', () => {
      return request(app.getHttpServer())
        .get('/categories/tree')
        .expect(200)
        .expect((res) => {
          expect(Array.isArray(res.body)).toBe(true);
          for (const node of res.body) {
            expect(node).toHaveProperty('id');
            expect(node).toHaveProperty('level');
            expect(node).toHaveProperty('slug');
            expect([0, 1]).toContain(node.level);
            // Дети уровня 1 не должны содержать вложенные children (только L0 и L1)
            if (node.children && Array.isArray(node.children)) {
              for (const child of node.children) {
                expect(child).toHaveProperty('id');
                expect(child).toHaveProperty('level', 1);
                expect(child).not.toHaveProperty('children');
              }
            }
          }
        });
    });
  });

  describe('GET /categories/:id/templates', () => {
    it('should return 400 for non-UUID id', () => {
      return request(app.getHttpServer())
        .get('/categories/not-a-uuid/templates')
        .expect(400);
    });

    it('should return 404 for non-existent category', () => {
      return request(app.getHttpServer())
        .get('/categories/00000000-0000-0000-0000-000000000000/templates')
        .expect(404);
    });

    it('should return templates for existing level-1 category', async () => {
      const res = await request(app.getHttpServer())
        .get('/categories/tree')
        .expect(200);
      const firstL1 = res.body
        .flatMap((n: any) => n.children || [])
        .find((c: any) => c && c.id);
      if (!firstL1) return;
      await request(app.getHttpServer())
        .get(`/categories/${firstL1.id}/templates`)
        .expect(200)
        .expect((r) => {
          expect(Array.isArray(r.body)).toBe(true);
          r.body.forEach((t: any) => {
            expect(t).toHaveProperty('id');
            expect(t).toHaveProperty('slug');
            expect(t).toHaveProperty('name');
            expect(t).toHaveProperty('category_id', firstL1.id);
          });
        });
    });
  });
});
