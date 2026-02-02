import { MigrationInterface, QueryRunner } from 'typeorm';

export class AddCategoryIdsToPosts20260202021329 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    // Добавить поле category_ids (массив UUID) в posts
    await queryRunner.query(`
      ALTER TABLE "posts" 
      ADD COLUMN IF NOT EXISTS "category_ids" UUID[] DEFAULT '{}';
    `);

    // Создать GIN индекс для эффективного поиска по массиву категорий
    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS "IDX_posts_category_ids" 
      ON "posts" USING gin("category_ids");
    `);

    // Заполнить category_ids из связанных услуг (post_services -> services -> category_id)
    // Это миграция данных для существующих постов
    await queryRunner.query(`
      UPDATE "posts" p
      SET "category_ids" = (
        SELECT ARRAY_AGG(DISTINCT s.category_id)
        FROM post_services ps
        INNER JOIN services s ON s.id = ps.service_id
        WHERE ps.post_id = p.id
          AND s.category_id IS NOT NULL
      )
      WHERE EXISTS (
        SELECT 1 
        FROM post_services ps
        INNER JOIN services s ON s.id = ps.service_id
        WHERE ps.post_id = p.id
          AND s.category_id IS NOT NULL
      );
    `);

    // Также заполнить category_ids из master_profile.category_ids для постов без услуг
    // но только если у мастера есть категории
    await queryRunner.query(`
      UPDATE "posts" p
      SET "category_ids" = mp.category_ids
      FROM master_profiles mp
      WHERE p.author_id = mp.user_id
        AND (p.category_ids IS NULL OR array_length(p.category_ids, 1) = 0)
        AND mp.category_ids IS NOT NULL
        AND array_length(mp.category_ids, 1) > 0;
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // Удалить индекс
    await queryRunner.query(`
      DROP INDEX IF EXISTS "IDX_posts_category_ids";
    `);

    // Удалить колонку
    await queryRunner.query(`
      ALTER TABLE "posts" 
      DROP COLUMN IF EXISTS "category_ids";
    `);
  }
}
