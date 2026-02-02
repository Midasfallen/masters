import { seedCatalog } from './seed-catalog';
import { seed } from './seed';

async function bootstrap() {
  console.log('🚀 Starting seeding process...\n');

  try {
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
