import 'dotenv/config';
import { DataSource } from 'typeorm';
import { dataSourceOptions } from '../../config/typeorm.config';
import { InitBaseSchema1782639034802 } from '../migrations/1782639034802-InitBaseSchema';

/**
 * Одноразовый разворот схемы для локальной разработки на ЧИСТОЙ БД.
 *
 * Контекст: базовые таблицы (users, categories, services, ...) не создавались ни
 * инкрементальными миграциями, ни init.sql — раньше схема рождалась из synchronize.
 * Сгенерированная InitBaseSchema содержит ПОЛНУЮ актуальную схему из entities,
 * поэтому здесь мы:
 *   1) применяем только InitBaseSchema (создаёт все таблицы);
 *   2) помечаем ВСЕ миграции (init + исторические) как applied в таблице migrations,
 *      чтобы migration:run / старт приложения считали схему полностью накатанной.
 *
 * Запуск: npx ts-node -r tsconfig-paths/register src/database/seeds/init-dev-db.ts
 */
async function initDevDb() {
  const ds = new DataSource(dataSourceOptions);
  await ds.initialize();
  const qr = ds.createQueryRunner();

  console.log('🏗  Applying InitBaseSchema...');
  const migration = new InitBaseSchema1782639034802();
  await migration.up(qr);
  console.log('✅ Schema created');

  // Таблица учёта миграций
  await qr.query(`
    CREATE TABLE IF NOT EXISTS "migrations" (
      "id" SERIAL PRIMARY KEY,
      "timestamp" bigint NOT NULL,
      "name" character varying NOT NULL
    )
  `);

  // Регистрируем init + все исторические миграции как выполненные
  const applied: Array<[number, string]> = [
    [1782639034802, 'InitBaseSchema1782639034802'],
    [1735544000000, 'CreatePostsTables1735544000000'],
    [1735544100000, 'CreateSocialTables1735544100000'],
    [1735544200000, 'CreateFriendsTables1735544200000'],
    [1735544300000, 'CreateChatsTables1735544300000'],
    [1769086715332, 'AddReviewReminders1769086715332'],
    [1769268000000, 'AddFavorites1769268000000'],
    [1769270000000, 'AddChatPinning1769270000000'],
    [1769962944841, 'AddPostServicesAndCustomService1769962944841'],
    [1770313946604, 'CreateServiceTemplates1770313946604'],
    [1770700000000, 'RemoveBusinessNameFromMasterProfiles1770700000000'],
    [1770800000000, 'AddCategoryIdsToPosts1770800000000'],
  ];

  for (const [ts, name] of applied) {
    const exists = await qr.query('SELECT 1 FROM "migrations" WHERE "name" = $1', [name]);
    if (exists.length === 0) {
      await qr.query('INSERT INTO "migrations" ("timestamp", "name") VALUES ($1, $2)', [ts, name]);
    }
  }
  console.log(`✅ Registered ${applied.length} migrations as applied`);

  await qr.release();
  await ds.destroy();
  console.log('✨ Dev DB ready');
  process.exit(0);
}

initDevDb().catch((err) => {
  console.error('❌ init-dev-db failed:', err);
  process.exit(1);
});
