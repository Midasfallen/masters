import 'dotenv/config';
import { DataSource } from 'typeorm';
import { entities } from '../../config/entities';

/**
 * Одноразовая синхронизация схемы из entities (dev/локальный запуск).
 *
 * На чистой БД базовые таблицы (users, services, categories, master_profiles, ...)
 * не создаются ни миграциями, ни init.sql. Этот скрипт создаёт полную актуальную
 * схему из entities через synchronize: true. Запускать ОДИН РАЗ перед seed.
 *
 * Использование: npx ts-node -r tsconfig-paths/register src/database/seeds/sync-schema.ts
 */
async function syncSchema() {
  console.log('🔧 Synchronizing schema from entities...');

  const dataSource = new DataSource({
    type: 'postgres',
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT || '5433', 10),
    username: process.env.DB_USERNAME || 'service_user',
    password: process.env.DB_PASSWORD || 'service_password',
    database: process.env.DB_DATABASE || 'service_db',
    entities,
    synchronize: true,
    logging: ['error', 'warn'],
  });

  await dataSource.initialize();
  console.log('✅ Schema synchronized successfully');
  await dataSource.destroy();
  process.exit(0);
}

syncSchema().catch((err) => {
  console.error('❌ Schema sync failed:', err);
  process.exit(1);
});
