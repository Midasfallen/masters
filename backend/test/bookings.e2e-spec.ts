import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from './../src/app.module';
import { DataSource } from 'typeorm';
import { User } from '../src/modules/users/entities/user.entity';
import { MasterProfile } from '../src/modules/masters/entities/master-profile.entity';
import { Category } from '../src/modules/categories/entities/category.entity';
import { CategoryTranslation } from '../src/modules/categories/entities/category-translation.entity';

// Helper to generate unique email
const uniqueEmail = (prefix: string) => `${prefix}-${Date.now()}-${Math.random().toString(36).substring(7)}@example.com`;

describe('BookingsController (e2e)', () => {
  let app: INestApplication;
  let clientToken: string;
  let client2Token: string; // Second client for cancel tests (to avoid review conflicts)
  let masterToken: string;
  let masterId: string;
  let serviceId: string;
  let bookingId: string;
  let completeBookingId: string; // Shared between complete and cancel tests

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

    // Create test category if it doesn't exist
    let dataSource = app.get(DataSource);
    const categoryRepo = dataSource.getRepository(Category);
    const categoryTranslationRepo = dataSource.getRepository(CategoryTranslation);

    let testCategory = await categoryRepo.findOne({ where: { slug: 'test-beauty' } });
    if (!testCategory) {
      testCategory = categoryRepo.create({
        slug: 'test-beauty',
        level: 0,
        icon_url: '💇',
        display_order: 999,
        is_active: true,
      });
      await categoryRepo.save(testCategory);

      // Create English translation
      const translation = categoryTranslationRepo.create({
        category_id: testCategory.id,
        language: 'en',
        name: 'Test Beauty Services',
        description: 'Test category for E2E tests',
      });
      await categoryTranslationRepo.save(translation);
      console.log('Created test category:', testCategory.id);
    } else {
      console.log('Using existing test category:', testCategory.id);
    }

    // Create client user
    const clientResponse = await request(app.getHttpServer())
      .post('/auth/register')
      .send({
        email: uniqueEmail('client'),
        password: 'Password123',
        first_name: 'Client',
        last_name: 'User',
        phone: `+7999${Math.floor(Math.random() * 10000000)}`,
      });
    clientToken = clientResponse.body.access_token;

    // Create second client user (for cancel tests, to avoid review requirement conflicts)
    const client2Response = await request(app.getHttpServer())
      .post('/auth/register')
      .send({
        email: uniqueEmail('client2'),
        password: 'Password123',
        first_name: 'Client2',
        last_name: 'User',
        phone: `+7999${Math.floor(Math.random() * 10000000)}`,
      });
    client2Token = client2Response.body.access_token;

    // Create master user
    const masterResponse = await request(app.getHttpServer())
      .post('/auth/register')
      .send({
        email: uniqueEmail('master'),
        password: 'Password123',
        first_name: 'Master',
        last_name: 'User',
        phone: `+7999${Math.floor(Math.random() * 10000000)}`,
      });
    masterToken = masterResponse.body.access_token;
    masterId = masterResponse.body.user.id;

    // Create master profile
    const masterProfileResponse = await request(app.getHttpServer())
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
      })
      .expect(201);

    // Complete master profile setup (manually set user flags for testing)
    dataSource = app.get(DataSource);
    try {
      const userRepo = dataSource.getRepository(User);
      const masterUser = await userRepo.findOne({ where: { id: masterId } });
      if (!masterUser) {
        console.error('Master user not found:', masterId);
        throw new Error('Master user not found');
      }
      masterUser.is_master = true;
      masterUser.master_profile_completed = true;
      await userRepo.save(masterUser);
      console.log('Master user updated successfully');

      // Update master profile to setup_step 5 and add categories
      const masterProfileRepo = dataSource.getRepository(MasterProfile);
      const masterProfile = await masterProfileRepo.findOne({ where: { user_id: masterId } });
      if (!masterProfile) {
        console.error('Master profile not found for user:', masterId);
        throw new Error('Master profile not found');
      }
      masterProfile.setup_step = 5;
      masterProfile.is_active = true;

      // Get test category
      const categoryRepo = dataSource.getRepository(Category);
      testCategory = await categoryRepo.findOne({ where: { slug: 'test-beauty' } });
      if (!testCategory) {
        throw new Error('Test category not found');
      }

      masterProfile.category_ids = [testCategory.id];
      console.log('Added category to profile:', testCategory.id);
      await masterProfileRepo.save(masterProfile);
      console.log('Master profile updated successfully');
    } catch (error) {
      console.error('Error updating master profile:', error);
      throw error;
    }

    // Create service (using test category)
    console.log('Attempting to create service with categoryId:', testCategory.id);
    const serviceResponse = await request(app.getHttpServer())
      .post('/services')
      .set('Authorization', `Bearer ${masterToken}`)
      .send({
        category_id: testCategory.id,
        name: 'Стрижка',
        description: 'Мужская стрижка',
        price: 1500,
        duration_minutes: 60,
      });

    if (serviceResponse.status !== 201) {
      console.error('Service creation failed:', serviceResponse.status, serviceResponse.body);
      throw new Error(`Service creation failed: ${JSON.stringify(serviceResponse.body)}`);
    }

    serviceId = serviceResponse.body.id;
    console.log('Created service ID:', serviceId);
  }, 30000);

  afterAll(async () => {
    if (app) {
      await app.close();
    }
  }, 10000);

  describe('/bookings (POST)', () => {
    it('should create a new booking', () => {
      const startTime = new Date(Date.now() + 86400000); // Tomorrow

      return request(app.getHttpServer())
        .post('/bookings')
        .set('Authorization', `Bearer ${clientToken}`)
        .send({
          service_id: serviceId,
          start_time: startTime.toISOString(),
          comment: 'Please call before arrival',
        })
        .expect((res) => {
          if (res.status !== 201) {
            console.log('ERROR Response:', JSON.stringify(res.body, null, 2));
          }
        })
        .expect(201)
        .expect((res) => {
          expect(res.body).toHaveProperty('id');
          expect(res.body).toHaveProperty('status', 'pending');
          expect(res.body).toHaveProperty('price');
          bookingId = res.body.id;
        });
    });

    it('should fail without authentication', () => {
      return request(app.getHttpServer())
        .post('/bookings')
        .send({
          service_id: serviceId,
          start_time: new Date(Date.now() + 86400000).toISOString(),
        })
        .expect(401);
    });

    it('should fail with invalid service_id', () => {
      return request(app.getHttpServer())
        .post('/bookings')
        .set('Authorization', `Bearer ${clientToken}`)
        .send({
          service_id: '00000000-0000-0000-0000-000000000000',
          start_time: new Date(Date.now() + 86400000).toISOString(),
        })
        .expect((res) => {
          // API returns 404 if service not found
          expect([400, 404]).toContain(res.status);
        });
    });

    it('should fail with past date', () => {
      const pastDate = new Date(Date.now() - 86400000); // Yesterday

      return request(app.getHttpServer())
        .post('/bookings')
        .set('Authorization', `Bearer ${clientToken}`)
        .send({
          service_id: serviceId,
          start_time: pastDate.toISOString(),
        })
        .expect(400);
    });
  });

  describe('/bookings/my (GET)', () => {
    it('should get client bookings', () => {
      return request(app.getHttpServer())
        .get('/bookings/my?role=client')
        .set('Authorization', `Bearer ${clientToken}`)
        .expect((res) => {
          if (res.status !== 200) {
            console.log('Get client bookings ERROR:', res.status, res.body);
          }
        })
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
        .expect(201)
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
    beforeAll(async () => {
      // Create new booking for complete test
      const startTime = new Date(Date.now() + 86400000 * 2); // Day after tomorrow to avoid conflicts
      const bookingResponse = await request(app.getHttpServer())
        .post('/bookings')
        .set('Authorization', `Bearer ${clientToken}`)
        .send({
          service_id: serviceId,
          start_time: startTime.toISOString(),
        });
      completeBookingId = bookingResponse.body.id;

      // Confirm booking first
      await request(app.getHttpServer())
        .post(`/bookings/${completeBookingId}/confirm`)
        .set('Authorization', `Bearer ${masterToken}`);

      // Start booking (IN_PROGRESS) - use PATCH, not POST
      await request(app.getHttpServer())
        .patch(`/bookings/${completeBookingId}/start`)
        .set('Authorization', `Bearer ${masterToken}`);
    }, 30000);

    it('should complete booking as master', () => {
      return request(app.getHttpServer())
        .post(`/bookings/${completeBookingId}/complete`)
        .set('Authorization', `Bearer ${masterToken}`)
        .expect(201) // Changed from 200 to 201 (complete creates review requirement)
        .expect((res) => {
          expect(res.body).toHaveProperty('status', 'completed');
        });
    });
  });

  describe('/bookings/:id/cancel (POST)', () => {
    let cancelBookingId: string;

    beforeAll(async () => {
      // Use client2Token (second client) to avoid review requirement conflicts
      // This client has no completed bookings, so can create new bookings freely
      const startTime = new Date(Date.now() + 86400000 * 3); // 3 days from now to avoid conflicts
      const response = await request(app.getHttpServer())
        .post('/bookings')
        .set('Authorization', `Bearer ${client2Token}`) // Use client2Token instead of clientToken
        .send({
          service_id: serviceId,
          start_time: startTime.toISOString(),
        });

      if (response.status !== 201) {
        console.error('Failed to create cancel booking:', response.status, response.body);
        throw new Error(`Failed to create cancel booking: ${JSON.stringify(response.body)}`);
      }

      cancelBookingId = response.body.id;
      console.log('Created cancel booking ID:', cancelBookingId);
    }, 30000);

    it('should cancel booking as client', () => {
      return request(app.getHttpServer())
        .post(`/bookings/${cancelBookingId}/cancel`)
        .set('Authorization', `Bearer ${client2Token}`) // Use client2Token
        .send({
          cancellation_reason: 'Changed my mind',
        })
        .expect(201)
        .expect((res) => {
          expect(res.body).toHaveProperty('status', 'cancelled');
          expect(res.body).toHaveProperty('cancellation_reason');
        });
    });

    it('should fail to cancel already cancelled booking', () => {
      return request(app.getHttpServer())
        .post(`/bookings/${cancelBookingId}/cancel`)
        .set('Authorization', `Bearer ${client2Token}`) // Use client2Token
        .send({
          cancellation_reason: 'Trying again',
        })
        .expect(400);
    });
  });
});
