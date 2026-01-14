import { DataSource } from 'typeorm';
import { faker } from '@faker-js/faker/locale/ru';
import * as bcrypt from 'bcrypt';
import { User } from '../../modules/users/entities/user.entity';
import { MasterProfile } from '../../modules/masters/entities/master-profile.entity';
import { Category } from '../../modules/categories/entities/category.entity';
import { Service } from '../../modules/services/entities/service.entity';
import { Booking, BookingStatus } from '../../modules/bookings/entities/booking.entity';
import { Review, ReviewerType } from '../../modules/reviews/entities/review.entity';

/**
 * Seed Script for Service Platform
 *
 * Creates test data:
 * - 10 test users (5 regular users + 5 masters)
 * - 10 categories
 * - 20 services (4 per master)
 * - 15 bookings in different statuses
 * - 20 reviews
 *
 * Usage:
 *   npm run seed
 * Or:
 *   ts-node src/database/seeds/seed.ts
 */

// Category data
const CATEGORIES = [
  {
    slug: 'beauty',
    icon_url: 'https://storage.example.com/icons/beauty.svg',
    color: '#E91E63',
    translations: {
      ru: { name: 'Красота', description: 'Парикмахеры, визажисты, косметологи' },
      en: { name: 'Beauty', description: 'Hairdressers, makeup artists, beauticians' },
    },
  },
  {
    slug: 'repair',
    icon_url: 'https://storage.example.com/icons/repair.svg',
    color: '#FF9800',
    translations: {
      ru: { name: 'Ремонт', description: 'Сантехники, электрики, мастера' },
      en: { name: 'Repair', description: 'Plumbers, electricians, handymen' },
    },
  },
  {
    slug: 'health',
    icon_url: 'https://storage.example.com/icons/health.svg',
    color: '#4CAF50',
    translations: {
      ru: { name: 'Здоровье', description: 'Массажисты, врачи, тренеры' },
      en: { name: 'Health', description: 'Massage therapists, doctors, trainers' },
    },
  },
  {
    slug: 'education',
    icon_url: 'https://storage.example.com/icons/education.svg',
    color: '#2196F3',
    translations: {
      ru: { name: 'Образование', description: 'Репетиторы, преподаватели' },
      en: { name: 'Education', description: 'Tutors, teachers' },
    },
  },
  {
    slug: 'auto',
    icon_url: 'https://storage.example.com/icons/auto.svg',
    color: '#9C27B0',
    translations: {
      ru: { name: 'Авто', description: 'Автомеханики, детейлинг' },
      en: { name: 'Auto', description: 'Auto mechanics, detailing' },
    },
  },
  {
    slug: 'cleaning',
    icon_url: 'https://storage.example.com/icons/cleaning.svg',
    color: '#00BCD4',
    translations: {
      ru: { name: 'Уборка', description: 'Клининговые услуги' },
      en: { name: 'Cleaning', description: 'Cleaning services' },
    },
  },
  {
    slug: 'pets',
    icon_url: 'https://storage.example.com/icons/pets.svg',
    color: '#795548',
    translations: {
      ru: { name: 'Животные', description: 'Груминг, ветеринары' },
      en: { name: 'Pets', description: 'Grooming, veterinarians' },
    },
  },
  {
    slug: 'it',
    icon_url: 'https://storage.example.com/icons/it.svg',
    color: '#607D8B',
    translations: {
      ru: { name: 'IT услуги', description: 'Программисты, настройка техники' },
      en: { name: 'IT Services', description: 'Programmers, tech setup' },
    },
  },
  {
    slug: 'photo',
    icon_url: 'https://storage.example.com/icons/photo.svg',
    color: '#FF5722',
    translations: {
      ru: { name: 'Фото', description: 'Фотографы, видеографы' },
      en: { name: 'Photo', description: 'Photographers, videographers' },
    },
  },
  {
    slug: 'events',
    icon_url: 'https://storage.example.com/icons/events.svg',
    color: '#FFC107',
    translations: {
      ru: { name: 'События', description: 'Организация мероприятий' },
      en: { name: 'Events', description: 'Event planning' },
    },
  },
];

// Service templates per category
const SERVICE_TEMPLATES: Record<string, Array<{ name: string; price: [number, number]; duration: number }>> = {
  beauty: [
    { name: 'Стрижка мужская', price: [800, 2000], duration: 45 },
    { name: 'Стрижка женская', price: [1500, 3500], duration: 60 },
    { name: 'Окрашивание волос', price: [3000, 8000], duration: 120 },
    { name: 'Маникюр', price: [1000, 2500], duration: 60 },
  ],
  repair: [
    { name: 'Установка розетки', price: [500, 1500], duration: 60 },
    { name: 'Замена смесителя', price: [1000, 2500], duration: 90 },
    { name: 'Сборка мебели', price: [1500, 5000], duration: 120 },
    { name: 'Мелкий ремонт', price: [800, 3000], duration: 90 },
  ],
  health: [
    { name: 'Массаж спины', price: [1500, 3000], duration: 60 },
    { name: 'Общий массаж', price: [2500, 5000], duration: 90 },
    { name: 'Персональная тренировка', price: [1500, 4000], duration: 60 },
    { name: 'Консультация диетолога', price: [2000, 5000], duration: 60 },
  ],
  education: [
    { name: 'Урок английского', price: [800, 2500], duration: 60 },
    { name: 'Репетиторство по математике', price: [1000, 3000], duration: 60 },
    { name: 'Урок программирования', price: [1500, 4000], duration: 90 },
    { name: 'Подготовка к ЕГЭ', price: [1200, 3500], duration: 90 },
  ],
};

async function seed() {
  // Connect to database
  const dataSource = new DataSource({
    type: 'postgres',
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT || '5433'),
    username: process.env.DB_USERNAME || 'service_user',
    password: process.env.DB_PASSWORD || 'service_password',
    database: process.env.DB_DATABASE || 'service_db',
    entities: [User, MasterProfile, Category, Service, Booking, Review],
    synchronize: false,
  });

  await dataSource.initialize();
  console.log('✅ Database connected');

  const userRepository = dataSource.getRepository(User);
  const masterProfileRepository = dataSource.getRepository(MasterProfile);
  const categoryRepository = dataSource.getRepository(Category);
  const serviceRepository = dataSource.getRepository(Service);
  const bookingRepository = dataSource.getRepository(Booking);
  const reviewRepository = dataSource.getRepository(Review);

  // Clear existing data (optional - uncomment if needed)
  // await reviewRepository.delete({});
  // await bookingRepository.delete({});
  // await serviceRepository.delete({});
  // await masterProfileRepository.delete({});
  // await categoryRepository.delete({});
  // await userRepository.delete({});
  // console.log('🗑️  Old data cleared');

  // 1. Create Categories
  console.log('📂 Creating categories...');
  const categories: Category[] = [];
  for (const catData of CATEGORIES) {
    const category = categoryRepository.create({
      slug: catData.slug,
      icon_url: catData.icon_url,
      color: catData.color,
      level: 0,
      display_order: categories.length,
      is_active: true,
      is_popular: faker.datatype.boolean(),
      masters_count: 0,
      services_count: 0,
    });
    await categoryRepository.save(category);
    categories.push(category);
  }
  console.log(`✅ Created ${categories.length} categories`);

  // 2. Create Users (5 regular + 5 masters)
  console.log('👥 Creating users...');
  const users: User[] = [];
  const hashedPassword = await bcrypt.hash('Password123!', 10);

  // Regular users
  for (let i = 0; i < 5; i++) {
    const firstName = faker.person.firstName();
    const lastName = faker.person.lastName();
    const user = userRepository.create({
      email: faker.internet.email({ firstName, lastName }).toLowerCase(),
      phone: `+7${faker.string.numeric(10)}`,
      password_hash: hashedPassword,
      first_name: firstName,
      last_name: lastName,
      avatar_url: faker.image.avatar(),
      is_master: false,
      language: 'ru',
      timezone: 'Europe/Moscow',
      last_location_lat: 55.7558 + faker.number.float({ min: -0.5, max: 0.5 }),
      last_location_lng: 37.6173 + faker.number.float({ min: -0.5, max: 0.5 }),
    });
    await userRepository.save(user);
    users.push(user);
  }

  // Master users
  const masterUsers: User[] = [];
  for (let i = 0; i < 5; i++) {
    const firstName = faker.person.firstName();
    const lastName = faker.person.lastName();
    const user = userRepository.create({
      email: faker.internet.email({ firstName, lastName }).toLowerCase(),
      phone: `+7${faker.string.numeric(10)}`,
      password_hash: hashedPassword,
      first_name: firstName,
      last_name: lastName,
      avatar_url: faker.image.avatar(),
      is_master: true,
      master_profile_completed: true,
      is_verified: faker.datatype.boolean(),
      is_premium: faker.datatype.boolean(),
      rating: faker.number.float({ min: 3.5, max: 5.0, fractionDigits: 1 }),
      reviews_count: faker.number.int({ min: 5, max: 150 }),
      language: 'ru',
      timezone: 'Europe/Moscow',
      last_location_lat: 55.7558 + faker.number.float({ min: -0.5, max: 0.5 }),
      last_location_lng: 37.6173 + faker.number.float({ min: -0.5, max: 0.5 }),
    });
    await userRepository.save(user);
    users.push(user);
    masterUsers.push(user);
  }
  console.log(`✅ Created ${users.length} users (${masterUsers.length} masters)`);

  // 3. Create Master Profiles
  console.log('🎨 Creating master profiles...');
  const masterProfiles: MasterProfile[] = [];
  for (let i = 0; i < masterUsers.length; i++) {
    const user = masterUsers[i];
    const category = categories[i % categories.length];
    const secondCategory = categories[(i + 1) % categories.length];

    const profile = masterProfileRepository.create({
      user_id: user.id,
      business_name: faker.company.name(),
      bio: faker.lorem.paragraph(),
      category_ids: [category.id, secondCategory.id],
      subcategory_ids: [],
      rating: user.rating,
      reviews_count: user.reviews_count,
      completed_bookings: faker.number.int({ min: 10, max: 300 }),
      cancellations_count: faker.number.int({ min: 0, max: 5 }),
      views_count: faker.number.int({ min: 50, max: 1500 }),
      favorites_count: faker.number.int({ min: 5, max: 100 }),
      subscribers_count: faker.number.int({ min: 10, max: 200 }),
      location_lat: user.last_location_lat,
      location_lng: user.last_location_lng,
      location_address: `${faker.location.city()}, ${faker.location.street()}, ${faker.location.buildingNumber()}`,
      location_name: faker.company.name(),
      service_radius_km: faker.number.int({ min: 5, max: 25 }),
      is_mobile: faker.datatype.boolean(),
      has_location: true,
      is_online_only: false,
      portfolio_urls: Array.from({ length: faker.number.int({ min: 3, max: 10 }) }, () =>
        faker.image.urlLoremFlickr({ category: 'portfolio' }),
      ),
      video_urls: [],
      social_links: {
        instagram: `@${faker.internet.username()}`,
        telegram: `@${faker.internet.username()}`,
      },
      working_hours: {
        monday: { start: '09:00', end: '18:00' },
        tuesday: { start: '09:00', end: '18:00' },
        wednesday: { start: '09:00', end: '18:00' },
        thursday: { start: '09:00', end: '18:00' },
        friday: { start: '09:00', end: '18:00' },
        saturday: { start: '10:00', end: '16:00' },
        sunday: { start: null, end: null },
      },
      min_booking_hours: faker.helpers.arrayElement([1, 2, 4, 12, 24]),
      max_bookings_per_day: faker.number.int({ min: 5, max: 20 }),
      auto_confirm: faker.datatype.boolean(),
      years_of_experience: faker.number.int({ min: 1, max: 20 }),
      certificates: faker.datatype.boolean()
        ? [faker.lorem.sentence(), faker.lorem.sentence()]
        : [],
      languages: ['ru', 'en'],
      is_active: true,
      is_approved: true,
      setup_step: 5,
    });
    await masterProfileRepository.save(profile);
    masterProfiles.push(profile);

    // Update category counts
    category.masters_count += 1;
    await categoryRepository.save(category);
    if (secondCategory.id !== category.id) {
      secondCategory.masters_count += 1;
      await categoryRepository.save(secondCategory);
    }
  }
  console.log(`✅ Created ${masterProfiles.length} master profiles`);

  // 4. Create Services
  console.log('💼 Creating services...');
  const services: Service[] = [];
  for (const profile of masterProfiles) {
    const categoryId = profile.category_ids[0];
    const category = categories.find((c) => c.id === categoryId);
    const categorySlug = category?.slug || 'beauty';

    const templates = SERVICE_TEMPLATES[categorySlug] || SERVICE_TEMPLATES.beauty;

    // Create 4 services per master
    for (const template of templates) {
      const service = serviceRepository.create({
        master_id: profile.id,
        category_id: categoryId,
        name: template.name,
        description: faker.lorem.sentences(2),
        price: faker.number.int({ min: template.price[0], max: template.price[1] }),
        currency: 'RUB',
        duration_minutes: template.duration,
        is_bookable_online: true,
        is_mobile: profile.is_mobile,
        is_in_salon: profile.has_location,
        tags: faker.helpers.arrayElements(
          ['популярное', 'акция', 'новинка', 'премиум', 'быстро'],
          faker.number.int({ min: 0, max: 3 }),
        ),
        photo_urls: Array.from({ length: faker.number.int({ min: 1, max: 5 }) }, () =>
          faker.image.urlLoremFlickr({ category: 'service' }),
        ),
        bookings_count: faker.number.int({ min: 0, max: 100 }),
        average_rating: faker.number.float({ min: 3.5, max: 5.0, fractionDigits: 1 }),
        is_active: true,
        display_order: services.length,
      });
      await serviceRepository.save(service);
      services.push(service);

      // Update category service count
      if (category) {
        category.services_count += 1;
        await categoryRepository.save(category);
      }
    }
  }
  console.log(`✅ Created ${services.length} services`);

  // 5. Create Bookings
  console.log('📅 Creating bookings...');
  const bookings: Booking[] = [];
  const statuses = Object.values(BookingStatus);

  for (let i = 0; i < 15; i++) {
    const client = users[i % 5]; // Regular users
    const service = faker.helpers.arrayElement(services);
    const master = masterUsers.find(
      (u) => masterProfiles.find((p) => p.id === service.master_id)?.user_id === u.id,
    );

    if (!master) continue;

    const startTime = faker.date.between({
      from: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000), // 30 days ago
      to: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000), // 30 days ahead
    });

    const endTime = new Date(startTime.getTime() + service.duration_minutes * 60 * 1000);
    const status = faker.helpers.arrayElement(statuses);

    const booking = bookingRepository.create({
      client_id: client.id,
      master_id: master.id,
      service_id: service.id,
      start_time: startTime,
      end_time: endTime,
      duration_minutes: service.duration_minutes,
      price: service.price,
      status,
      comment: faker.datatype.boolean() ? faker.lorem.sentence() : null,
      location_type: faker.helpers.arrayElement(['salon', 'client_location', 'online']),
      location_address: faker.location.streetAddress(),
      reminder_sent: status !== BookingStatus.PENDING ? faker.datatype.boolean() : false,
      completed_at: status === BookingStatus.COMPLETED ? endTime : null,
    });
    await bookingRepository.save(booking);
    bookings.push(booking);
  }
  console.log(`✅ Created ${bookings.length} bookings`);

  // 6. Create Reviews
  console.log('⭐ Creating reviews...');
  const completedBookings = bookings.filter((b) => b.status === BookingStatus.COMPLETED);

  for (let i = 0; i < Math.min(20, completedBookings.length); i++) {
    const booking = completedBookings[i % completedBookings.length];

    // Client review to master
    const clientReview = reviewRepository.create({
      booking_id: booking.id,
      reviewer_id: booking.client_id,
      reviewed_user_id: booking.master_id,
      reviewer_type: ReviewerType.CLIENT,
      rating: faker.number.int({ min: 3, max: 5 }),
      comment: faker.lorem.sentences(faker.number.int({ min: 1, max: 3 })),
      photo_urls: faker.datatype.boolean()
        ? [faker.image.urlLoremFlickr({ category: 'review' })]
        : [],
      is_visible: true,
      is_approved: true,
      response: faker.datatype.boolean() ? faker.lorem.sentence() : null,
      response_at: faker.datatype.boolean() ? faker.date.recent({ days: 7 }) : null,
    });
    await reviewRepository.save(clientReview);

    // Update booking
    booking.client_review_left = true;
    await bookingRepository.save(booking);
  }
  console.log(`✅ Created 20 reviews`);

  await dataSource.destroy();
  console.log('🎉 Seed completed successfully!');
  console.log(`
Summary:
  - ${categories.length} categories
  - ${users.length} users (${masterUsers.length} masters)
  - ${masterProfiles.length} master profiles
  - ${services.length} services
  - ${bookings.length} bookings
  - 20 reviews
  `);
}

// Run the seed
seed()
  .then(() => {
    console.log('✅ Seeding finished');
    process.exit(0);
  })
  .catch((error) => {
    console.error('❌ Seeding failed:', error);
    process.exit(1);
  });
