import { DataSource } from 'typeorm';
import { seedCatalog } from './seed-catalog';
import { seed } from './seed';

/**
 * Очистка данных основного сида (пользователи, услуги, бронирования, посты и т.д.)
 * в порядке, безопасном для FK. Позволяет повторно запускать npm run seed (идемпотентность).
 */
async function clearMainSeedData(): Promise<void> {
  const dataSource = new DataSource({
    type: 'postgres',
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT || '5433'),
    username: process.env.DB_USERNAME || 'service_user',
    password: process.env.DB_PASSWORD || 'service_password',
    database: process.env.DB_DATABASE || 'service_db',
    synchronize: false,
  });
  await dataSource.initialize();

  // Порядок удаления: сначала таблицы, зависящие от users/services/posts (FK)
  const order = [
    'post_services',
    'post_media',
    'comments',
    'likes',
    'reposts',
    'posts',
    'reviews',
    'bookings',
    'services',
    'master_profiles',
    'notifications',
    'device_tokens',
    'review_reminders',
    'favorites',
    'subscriptions',
    'friendships',
    'messages',
    'chat_participants',
    'chats',
    'users',
  ];

  for (const table of order) {
    try {
      await dataSource.query(`DELETE FROM ${table}`);
    } catch (e: any) {
      if (e.code !== '42P01') throw e;
      // 42P01 = table does not exist, skip
    }
  }

  await dataSource.destroy();
}

async function bootstrap() {
  console.log('🚀 Starting seeding process...\n');

  try {
    // Очистка данных основного сида, чтобы повторный запуск был идемпотентным
    console.log('🧹 Clearing main seed data (for idempotency)...');
    await clearMainSeedData();
    console.log('✅ Main seed data cleared\n');

    // Сначала заполнить каталог категорий из Catalog.md
    console.log('📚 Seeding catalog categories...');
    await seedCatalog();

    // Затем основной seed (пользователи, мастера, услуги, посты)
    console.log('🌱 Seeding main data...');
    await seed();
  } catch (error) {
    console.error('❌ Seeding failed:', error);
    process.exit(1);
  }

  console.log('\n✨ Seeding process completed successfully!');
  process.exit(0);
}

bootstrap();
