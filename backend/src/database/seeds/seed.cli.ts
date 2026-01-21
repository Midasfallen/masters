import { NestFactory } from '@nestjs/core';
import { AppModule } from '../../app.module';
import { DataSource } from 'typeorm';
import { seedTestData } from './test-data.seed';

async function bootstrap() {
  console.log('🚀 Starting seeding process...\n');

  const app = await NestFactory.createApplicationContext(AppModule);
  const dataSource = app.get(DataSource);

  try {
    await seedTestData(dataSource);
  } catch (error) {
    console.error('❌ Seeding failed:', error);
    process.exit(1);
  } finally {
    await app.close();
  }

  console.log('\n✨ Seeding process completed successfully!');
  process.exit(0);
}

bootstrap();
