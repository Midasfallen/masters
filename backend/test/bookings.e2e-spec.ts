import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from './../src/app.module';

describe('BookingsController (e2e)', () => {
  let app: INestApplication;
  let clientToken: string;
  let masterToken: string;
  let masterId: string;
  let serviceId: string;
  let bookingId: string;

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

    // Create client user
    const clientResponse = await request(app.getHttpServer())
      .post('/auth/register')
      .send({
        email: `client${Date.now()}@example.com`,
        password: 'Password123',
        first_name: 'Client',
        last_name: 'User',
        phone: '+79991234567',
      });
    clientToken = clientResponse.body.access_token;

    // Create master user
    const masterResponse = await request(app.getHttpServer())
      .post('/auth/register')
      .send({
        email: `master${Date.now()}@example.com`,
        password: 'Password123',
        first_name: 'Master',
        last_name: 'User',
        phone: '+79991234568',
      });
    masterToken = masterResponse.body.access_token;
    masterId = masterResponse.body.user.id;

    // Create master profile
    await request(app.getHttpServer())
      .post('/masters')
      .set('Authorization', `Bearer ${masterToken}`)
      .send({
        bio: 'Professional hairdresser',
        experience_years: 5,
        address: {
          city: 'Москва',
          street: 'Тверская',
          building: '1',
          latitude: 55.7558,
          longitude: 37.6173,
        },
        portfolio_urls: ['https://example.com/photo1.jpg'],
      });

    // Create service
    const serviceResponse = await request(app.getHttpServer())
      .post('/services')
      .set('Authorization', `Bearer ${masterToken}`)
      .send({
        category_id: '1',
        name: 'Стрижка',
        description: 'Мужская стрижка',
        price: 1500,
        duration_minutes: 60,
      });
    serviceId = serviceResponse.body.id;
  });

  afterAll(async () => {
    await app.close();
  });

  describe('/bookings (POST)', () => {
    it('should create a new booking', () => {
      const scheduledFor = new Date(Date.now() + 86400000); // Tomorrow

      return request(app.getHttpServer())
        .post('/bookings')
        .set('Authorization', `Bearer ${clientToken}`)
        .send({
          master_profile_id: masterId,
          service_id: serviceId,
          scheduled_for: scheduledFor.toISOString(),
          notes: 'Please call before arrival',
        })
        .expect(201)
        .expect((res) => {
          expect(res.body).toHaveProperty('id');
          expect(res.body).toHaveProperty('status', 'pending');
          expect(res.body).toHaveProperty('total_price', 1500);
          bookingId = res.body.id;
        });
    });

    it('should fail without authentication', () => {
      return request(app.getHttpServer())
        .post('/bookings')
        .send({
          master_profile_id: masterId,
          service_id: serviceId,
          scheduled_for: new Date().toISOString(),
        })
        .expect(401);
    });

    it('should fail with invalid service_id', () => {
      return request(app.getHttpServer())
        .post('/bookings')
        .set('Authorization', `Bearer ${clientToken}`)
        .send({
          master_profile_id: masterId,
          service_id: '00000000-0000-0000-0000-000000000000',
          scheduled_for: new Date().toISOString(),
        })
        .expect(404);
    });

    it('should fail with past date', () => {
      const pastDate = new Date(Date.now() - 86400000); // Yesterday

      return request(app.getHttpServer())
        .post('/bookings')
        .set('Authorization', `Bearer ${clientToken}`)
        .send({
          master_profile_id: masterId,
          service_id: serviceId,
          scheduled_for: pastDate.toISOString(),
        })
        .expect(400);
    });
  });

  describe('/bookings/my (GET)', () => {
    it('should get client bookings', () => {
      return request(app.getHttpServer())
        .get('/bookings/my?role=client')
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(200)
        .expect((res) => {
          expect(Array.isArray(res.body.data)).toBe(true);
          expect(res.body).toHaveProperty('total');
          expect(res.body).toHaveProperty('page');
        });
    });

    it('should get master bookings', () => {
      return request(app.getHttpServer())
        .get('/bookings/my?role=master')
        .set('Authorization', `Bearer ${masterToken}`)
        .expect(200)
        .expect((res) => {
          expect(Array.isArray(res.body.data)).toBe(true);
        });
    });

    it('should fail without authentication', () => {
      return request(app.getHttpServer())
        .get('/bookings/my?role=client')
        .expect(401);
    });
  });

  describe('/bookings/:id (GET)', () => {
    it('should get booking by id', () => {
      return request(app.getHttpServer())
        .get(`/bookings/${bookingId}`)
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('id', bookingId);
          expect(res.body).toHaveProperty('status');
        });
    });

    it('should fail with invalid id', () => {
      return request(app.getHttpServer())
        .get('/bookings/00000000-0000-0000-0000-000000000000')
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(404);
    });
  });

  describe('/bookings/:id/confirm (POST)', () => {
    it('should confirm booking as master', () => {
      return request(app.getHttpServer())
        .post(`/bookings/${bookingId}/confirm`)
        .set('Authorization', `Bearer ${masterToken}`)
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('status', 'confirmed');
        });
    });

    it('should fail if not master of the booking', () => {
      return request(app.getHttpServer())
        .post(`/bookings/${bookingId}/confirm`)
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(403);
    });
  });

  describe('/bookings/:id/complete (POST)', () => {
    it('should complete booking as master', () => {
      return request(app.getHttpServer())
        .post(`/bookings/${bookingId}/complete`)
        .set('Authorization', `Bearer ${masterToken}`)
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('status', 'completed');
        });
    });
  });

  describe('/bookings/:id/cancel (POST)', () => {
    let cancelBookingId: string;

    beforeAll(async () => {
      const scheduledFor = new Date(Date.now() + 86400000);
      const response = await request(app.getHttpServer())
        .post('/bookings')
        .set('Authorization', `Bearer ${clientToken}`)
        .send({
          master_profile_id: masterId,
          service_id: serviceId,
          scheduled_for: scheduledFor.toISOString(),
        });
      cancelBookingId = response.body.id;
    });

    it('should cancel booking as client', () => {
      return request(app.getHttpServer())
        .post(`/bookings/${cancelBookingId}/cancel`)
        .set('Authorization', `Bearer ${clientToken}`)
        .send({
          cancellation_reason: 'Changed my mind',
        })
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('status', 'cancelled');
          expect(res.body).toHaveProperty('cancellation_reason');
        });
    });

    it('should fail to cancel already cancelled booking', () => {
      return request(app.getHttpServer())
        .post(`/bookings/${cancelBookingId}/cancel`)
        .set('Authorization', `Bearer ${clientToken}`)
        .send({
          cancellation_reason: 'Trying again',
        })
        .expect(400);
    });
  });
});
