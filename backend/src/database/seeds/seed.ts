import { DataSource, TreeRepository } from 'typeorm';
import { faker } from '@faker-js/faker/locale/ru';
import * as bcrypt from 'bcrypt';
import { User } from '../../modules/users/entities/user.entity';
import { MasterProfile } from '../../modules/masters/entities/master-profile.entity';
import { Category } from '../../modules/categories/entities/category.entity';
import { CategoryTranslation } from '../../modules/categories/entities/category-translation.entity';
import { Service } from '../../modules/services/entities/service.entity';
import { Booking, BookingStatus } from '../../modules/bookings/entities/booking.entity';
import { Review, ReviewerType } from '../../modules/reviews/entities/review.entity';
import { Post, PostType, PostPrivacy } from '../../modules/posts/entities/post.entity';
import { PostService } from '../../modules/posts/entities/post-service.entity';
import { PostMedia } from '../../modules/posts/entities/post-media.entity';

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
    entities: [User, MasterProfile, Category, CategoryTranslation, Service, Booking, Review, Post, PostService, PostMedia],
    synchronize: false,
  });

  await dataSource.initialize();
  console.log('✅ Database connected');

  const userRepository = dataSource.getRepository(User);
  const masterProfileRepository = dataSource.getRepository(MasterProfile);
  const categoryRepository = dataSource.getTreeRepository(Category);
  const categoryTranslationRepository = dataSource.getRepository(CategoryTranslation);
  const serviceRepository = dataSource.getRepository(Service);
  const bookingRepository = dataSource.getRepository(Booking);
  const reviewRepository = dataSource.getRepository(Review);
  const postRepository = dataSource.getRepository(Post);
  const postServiceRepository = dataSource.getRepository(PostService);

  // Категории уже должны быть созданы через seed-catalog.ts
  // Получаем категории из БД
  console.log('📂 Loading categories from catalog...');
  const rootCategories = await categoryRepository.find({ where: { level: 0 } });
  const subCategories = await categoryRepository.find({ where: { level: 1 } });
  const serviceCategories = await categoryRepository.find({ where: { level: 2 } });
  
  if (rootCategories.length === 0) {
    console.warn('⚠️  No categories found! Please run seed-catalog first.');
    process.exit(1);
  }
  
  console.log(`✅ Loaded ${rootCategories.length} root, ${subCategories.length} sub, ${serviceCategories.length} service categories`);

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
    
    // Заполняем category_ids из реального каталога (любого уровня)
    const selectedRootCategories = faker.helpers.arrayElements(rootCategories, { min: 1, max: 3 });
    const selectedSubCategories = faker.helpers.arrayElements(subCategories, { min: 0, max: 2 });
    const selectedServiceCategories = faker.helpers.arrayElements(serviceCategories, { min: 0, max: 2 });
    
    const allCategoryIds = [
      ...selectedRootCategories.map(c => c.id),
      ...selectedSubCategories.map(c => c.id),
      ...selectedServiceCategories.map(c => c.id)
    ];

    const profile = masterProfileRepository.create({
      user_id: user.id,
      business_name: faker.company.name(),
      bio: faker.lorem.paragraph(),
      category_ids: allCategoryIds,
      subcategory_ids: selectedSubCategories.map(c => c.id),
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

    // Update category counts для всех выбранных категорий
    for (const cat of [...selectedRootCategories, ...selectedSubCategories, ...selectedServiceCategories]) {
      cat.masters_count = (cat.masters_count || 0) + 1;
      await categoryRepository.save(cat);
    }
  }
  console.log(`✅ Created ${masterProfiles.length} master profiles`);

  // 4. Create Services
  console.log('💼 Creating services...');
  const services: Service[] = [];
  for (const profile of masterProfiles) {
    // Используем категории уровня 2 (услуги) для создания services
    // Берем категории уровня 2, которые есть в category_ids мастера
    const masterServiceCategories = serviceCategories.filter(c => 
      profile.category_ids.includes(c.id)
    );
    
    // Если у мастера нет категорий уровня 2, выбираем случайные
    const categoriesToUse = masterServiceCategories.length > 0 
      ? masterServiceCategories 
      : faker.helpers.arrayElements(serviceCategories, { min: 2, max: 5 });

    // Создаем 3-5 услуг для каждого мастера
    const servicesCount = faker.number.int({ min: 3, max: 5 });
    for (let j = 0; j < servicesCount; j++) {
      const serviceCategory = faker.helpers.arrayElement(categoriesToUse);
      
      // Получаем название услуги из категории через translations
      const translation = await categoryTranslationRepository.findOne({
        where: { category_id: serviceCategory.id, language: 'ru' }
      });
      const serviceName = translation?.name || serviceCategory.slug.split('-').map(word => 
        word.charAt(0).toUpperCase() + word.slice(1)
      ).join(' ');

      const service = serviceRepository.create({
        master_id: profile.id,
        category_id: serviceCategory.id, // Используем category_id уровня 2
        subcategory_id: serviceCategory.parent_id || null,
        name: serviceName,
        description: faker.lorem.sentences(2),
        price: faker.number.int({ min: 500, max: 5000 }),
        currency: 'RUB',
        duration_minutes: faker.helpers.arrayElement([30, 45, 60, 90, 120]),
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
      serviceCategory.services_count = (serviceCategory.services_count || 0) + 1;
      await categoryRepository.save(serviceCategory);
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

  // 7. Create Posts
  console.log('📝 Creating posts...');
  const posts: Post[] = [];
  for (let i = 0; i < 20; i++) {
    const author = faker.helpers.arrayElement(masterUsers);
    const post = postRepository.create({
      author_id: author.id,
      type: faker.helpers.arrayElement([PostType.TEXT, PostType.PHOTO]),
      content: faker.lorem.paragraphs(faker.number.int({ min: 1, max: 3 })),
      privacy: PostPrivacy.PUBLIC,
      likes_count: faker.number.int({ min: 0, max: 100 }),
      comments_count: faker.number.int({ min: 0, max: 50 }),
      reposts_count: faker.number.int({ min: 0, max: 20 }),
      views_count: faker.number.int({ min: 0, max: 500 }),
      location_lat: author.last_location_lat,
      location_lng: author.last_location_lng,
      location_name: faker.location.city(),
      comments_disabled: false,
      is_pinned: false,
    });
    await postRepository.save(post);
    posts.push(post);
  }
  console.log(`✅ Created ${posts.length} posts`);

  // 8. Create Post-Service links and populate category_ids
  console.log('🔗 Creating post-service links and populating category_ids...');
  let postServiceLinksCount = 0;
  for (const post of posts) {
    const authorProfile = masterProfiles.find(p => p.user_id === post.author_id);
    const postCategoryIds = new Set<string>();
    
    if (authorProfile) {
      const masterServices = services.filter(s => s.master_id === authorProfile.id);
      if (masterServices.length > 0) {
        // Связываем пост с 1-3 услугами мастера
        const selectedServices = faker.helpers.arrayElements(masterServices, { 
          min: 1, 
          max: Math.min(3, masterServices.length) 
        });
        for (const service of selectedServices) {
          const postService = postServiceRepository.create({
            post_id: post.id,
            service_id: service.id,
          });
          await postServiceRepository.save(postService);
          postServiceLinksCount++;
          
          // Собираем category_id из услуги
          if (service.category_id) {
            postCategoryIds.add(service.category_id);
          }
        }
      }
    }

    // Обновляем category_ids в посте
    if (postCategoryIds.size > 0) {
      await postRepository.update(post.id, {
        category_ids: Array.from(postCategoryIds),
      });
    } else if (authorProfile && authorProfile.category_ids && authorProfile.category_ids.length > 0) {
      // Если нет услуг, используем категории мастера
      await postRepository.update(post.id, {
        category_ids: authorProfile.category_ids,
      });
    }
  }
  console.log(`✅ Created ${postServiceLinksCount} post-service links`);

  await dataSource.destroy();
  console.log('🎉 Seed completed successfully!');
  console.log(`
Summary:
  - ${rootCategories.length} root categories (from catalog)
  - ${subCategories.length} subcategories (from catalog)
  - ${serviceCategories.length} service categories (from catalog)
  - ${users.length} users (${masterUsers.length} masters)
  - ${masterProfiles.length} master profiles
  - ${services.length} services
  - ${bookings.length} bookings
  - 20 reviews
  - ${posts.length} posts
  - ${postServiceLinksCount} post-service links
  `);
}

// Export seed function for use in seed.cli.ts
export { seed };

// Run the seed if called directly
if (require.main === module) {
  seed()
    .then(() => {
      console.log('✅ Seeding finished');
      process.exit(0);
    })
    .catch((error) => {
      console.error('❌ Seeding failed:', error);
      process.exit(1);
    });
}
