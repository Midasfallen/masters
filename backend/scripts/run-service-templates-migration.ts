/**
 * Запуск только миграции CreateServiceTemplates (когда остальные уже применены вручную/sync).
 * Использование: npx ts-node -r tsconfig-paths/register scripts/run-service-templates-migration.ts
 */
import { DataSource } from 'typeorm';
import { dataSourceOptions } from '../src/config/typeorm.config';
import { CreateServiceTemplates1770313946604 } from '../src/database/migrations/1770313946604-CreateServiceTemplates';

async function run() {
  const dataSource = new DataSource(dataSourceOptions);
  await dataSource.initialize();

  const queryRunner = dataSource.createQueryRunner();
  await queryRunner.connect();
  await queryRunner.startTransaction();

  try {
    const migration = new CreateServiceTemplates1770313946604();
    await migration.up(queryRunner);
    await queryRunner.query(
      `INSERT INTO migrations (timestamp, name) VALUES (1770313946604, 'CreateServiceTemplates1770313946604')`,
    );
    await queryRunner.commitTransaction();
    console.log('Migration CreateServiceTemplates applied successfully.');
  } catch (e) {
    await queryRunner.rollbackTransaction();
    console.error('Migration failed:', e);
    throw e;
  } finally {
    await queryRunner.release();
    await dataSource.destroy();
  }
}

run();
