import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from './../src/app.module';

describe('PostsController (e2e)', () => {
  let app: INestApplication;
  let userToken: string;
  let userId: string;
  let postId: string;
  let commentId: string;

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

    // Create test user
    const userResponse = await request(app.getHttpServer())
      .post('/auth/register')
      .send({
        email: `postuser${Date.now()}@example.com`,
        password: 'Password123',
        first_name: 'Post',
        last_name: 'User',
        phone: '+79991234567',
      });
    userToken = userResponse.body.access_token;
    userId = userResponse.body.user.id;
  });

  afterAll(async () => {
    await app.close();
  });

  describe('/posts (POST)', () => {
    it('should create a new post', () => {
      return request(app.getHttpServer())
        .post('/posts')
        .set('Authorization', `Bearer ${userToken}`)
        .send({
          content: 'My first post with amazing photos!',
          media_urls: [
            'https://example.com/photo1.jpg',
            'https://example.com/photo2.jpg',
          ],
          category_id: '1',
        })
        .expect(201)
        .expect((res) => {
          expect(res.body).toHaveProperty('id');
          expect(res.body).toHaveProperty('content', 'My first post with amazing photos!');
          expect(res.body).toHaveProperty('author_id', userId);
          expect(res.body).toHaveProperty('likes_count', 0);
          expect(res.body).toHaveProperty('comments_count', 0);
          expect(Array.isArray(res.body.media_urls)).toBe(true);
          postId = res.body.id;
        });
    });

    it('should fail without authentication', () => {
      return request(app.getHttpServer())
        .post('/posts')
        .send({
          content: 'Unauthorized post',
          media_urls: ['https://example.com/photo.jpg'],
        })
        .expect(401);
    });

    it('should fail with empty content and no media', () => {
      return request(app.getHttpServer())
        .post('/posts')
        .set('Authorization', `Bearer ${userToken}`)
        .send({
          content: '',
          media_urls: [],
        })
        .expect(400);
    });

    it('should create post with only media (no content)', () => {
      return request(app.getHttpServer())
        .post('/posts')
        .set('Authorization', `Bearer ${userToken}`)
        .send({
          content: '',
          media_urls: ['https://example.com/beautiful-work.jpg'],
        })
        .expect(201);
    });
  });

  describe('/posts/feed (GET)', () => {
    it('should get feed posts with pagination', () => {
      return request(app.getHttpServer())
        .get('/posts/feed?page=1&limit=20')
        .set('Authorization', `Bearer ${userToken}`)
        .expect(200)
        .expect((res) => {
          expect(Array.isArray(res.body.data)).toBe(true);
          expect(res.body).toHaveProperty('total');
          expect(res.body).toHaveProperty('page', 1);
          expect(res.body).toHaveProperty('limit', 20);
        });
    });

    it('should filter by category', () => {
      return request(app.getHttpServer())
        .get('/posts/feed?category_id=1&page=1&limit=10')
        .set('Authorization', `Bearer ${userToken}`)
        .expect(200)
        .expect((res) => {
          expect(Array.isArray(res.body.data)).toBe(true);
        });
    });

    it('should work without authentication (public feed)', () => {
      return request(app.getHttpServer())
        .get('/posts/feed?page=1&limit=10')
        .expect(200);
    });
  });

  describe('/posts/:id (GET)', () => {
    it('should get post by id', () => {
      return request(app.getHttpServer())
        .get(`/posts/${postId}`)
        .set('Authorization', `Bearer ${userToken}`)
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('id', postId);
          expect(res.body).toHaveProperty('content');
          expect(res.body).toHaveProperty('author');
          expect(res.body.author).toHaveProperty('id');
          expect(res.body.author).toHaveProperty('first_name');
        });
    });

    it('should fail with non-existent id', () => {
      return request(app.getHttpServer())
        .get('/posts/00000000-0000-0000-0000-000000000000')
        .set('Authorization', `Bearer ${userToken}`)
        .expect(404);
    });
  });

  describe('/posts/:id (PATCH)', () => {
    it('should update own post', () => {
      return request(app.getHttpServer())
        .patch(`/posts/${postId}`)
        .set('Authorization', `Bearer ${userToken}`)
        .send({
          content: 'Updated post content',
        })
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('content', 'Updated post content');
        });
    });

    it('should fail to update others post', async () => {
      // Create another user
      const otherUserResponse = await request(app.getHttpServer())
        .post('/auth/register')
        .send({
          email: `other${Date.now()}@example.com`,
          password: 'Password123',
          first_name: 'Other',
          last_name: 'User',
        });
      const otherToken = otherUserResponse.body.access_token;

      return request(app.getHttpServer())
        .patch(`/posts/${postId}`)
        .set('Authorization', `Bearer ${otherToken}`)
        .send({
          content: 'Trying to hack',
        })
        .expect(403);
    });
  });

  describe('/posts/:id (DELETE)', () => {
    let deletePostId: string;

    beforeAll(async () => {
      const response = await request(app.getHttpServer())
        .post('/posts')
        .set('Authorization', `Bearer ${userToken}`)
        .send({
          content: 'Post to be deleted',
          media_urls: ['https://example.com/temp.jpg'],
        });
      deletePostId = response.body.id;
    });

    it('should delete own post', () => {
      return request(app.getHttpServer())
        .delete(`/posts/${deletePostId}`)
        .set('Authorization', `Bearer ${userToken}`)
        .expect(200);
    });

    it('should fail to get deleted post', () => {
      return request(app.getHttpServer())
        .get(`/posts/${deletePostId}`)
        .set('Authorization', `Bearer ${userToken}`)
        .expect(404);
    });
  });

  describe('/posts/:id/like (POST)', () => {
    it('should like a post', () => {
      return request(app.getHttpServer())
        .post(`/posts/${postId}/like`)
        .set('Authorization', `Bearer ${userToken}`)
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('likes_count', 1);
        });
    });

    it('should fail to like the same post twice', () => {
      return request(app.getHttpServer())
        .post(`/posts/${postId}/like`)
        .set('Authorization', `Bearer ${userToken}`)
        .expect(400);
    });

    it('should fail without authentication', () => {
      return request(app.getHttpServer())
        .post(`/posts/${postId}/like`)
        .expect(401);
    });
  });

  describe('/posts/:id/unlike (DELETE)', () => {
    it('should unlike a post', () => {
      return request(app.getHttpServer())
        .delete(`/posts/${postId}/unlike`)
        .set('Authorization', `Bearer ${userToken}`)
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('likes_count', 0);
        });
    });

    it('should fail to unlike a post not liked', () => {
      return request(app.getHttpServer())
        .delete(`/posts/${postId}/unlike`)
        .set('Authorization', `Bearer ${userToken}`)
        .expect(400);
    });
  });

  describe('/posts/:id/comments (POST)', () => {
    it('should create a comment', () => {
      return request(app.getHttpServer())
        .post(`/posts/${postId}/comments`)
        .set('Authorization', `Bearer ${userToken}`)
        .send({
          content: 'Great work! Love it!',
        })
        .expect(201)
        .expect((res) => {
          expect(res.body).toHaveProperty('id');
          expect(res.body).toHaveProperty('content', 'Great work! Love it!');
          expect(res.body).toHaveProperty('author_id', userId);
          commentId = res.body.id;
        });
    });

    it('should fail with empty comment', () => {
      return request(app.getHttpServer())
        .post(`/posts/${postId}/comments`)
        .set('Authorization', `Bearer ${userToken}`)
        .send({
          content: '',
        })
        .expect(400);
    });

    it('should create a reply comment', () => {
      return request(app.getHttpServer())
        .post(`/posts/${postId}/comments`)
        .set('Authorization', `Bearer ${userToken}`)
        .send({
          content: 'Thanks!',
          parent_comment_id: commentId,
        })
        .expect(201)
        .expect((res) => {
          expect(res.body).toHaveProperty('parent_comment_id', commentId);
        });
    });
  });

  describe('/posts/:id/comments (GET)', () => {
    it('should get post comments', () => {
      return request(app.getHttpServer())
        .get(`/posts/${postId}/comments?page=1&limit=10`)
        .set('Authorization', `Bearer ${userToken}`)
        .expect(200)
        .expect((res) => {
          expect(Array.isArray(res.body.data)).toBe(true);
          expect(res.body.data.length).toBeGreaterThan(0);
          expect(res.body).toHaveProperty('total');
        });
    });
  });

  describe('/posts/:postId/comments/:commentId (DELETE)', () => {
    it('should delete own comment', () => {
      return request(app.getHttpServer())
        .delete(`/posts/${postId}/comments/${commentId}`)
        .set('Authorization', `Bearer ${userToken}`)
        .expect(200);
    });

    it('should fail to delete non-existent comment', () => {
      return request(app.getHttpServer())
        .delete(`/posts/${postId}/comments/00000000-0000-0000-0000-000000000000`)
        .set('Authorization', `Bearer ${userToken}`)
        .expect(404);
    });
  });

  describe('/posts/:id/repost (POST)', () => {
    it('should repost a post', () => {
      return request(app.getHttpServer())
        .post(`/posts/${postId}/repost`)
        .set('Authorization', `Bearer ${userToken}`)
        .send({
          content: 'Check this out!',
        })
        .expect(201)
        .expect((res) => {
          expect(res.body).toHaveProperty('id');
          expect(res.body).toHaveProperty('reposted_from_id', postId);
          expect(res.body).toHaveProperty('content', 'Check this out!');
        });
    });

    it('should fail to repost the same post twice', () => {
      return request(app.getHttpServer())
        .post(`/posts/${postId}/repost`)
        .set('Authorization', `Bearer ${userToken}`)
        .send({
          content: 'Trying again',
        })
        .expect(400);
    });
  });
});
