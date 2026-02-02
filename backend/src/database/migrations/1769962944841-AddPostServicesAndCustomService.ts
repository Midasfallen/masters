import { MigrationInterface, QueryRunner } from 'typeorm';

export class AddPostServicesAndCustomService1769962944841
  implements MigrationInterface
{
  public async up(queryRunner: QueryRunner): Promise<void> {
    // PostGIS extension создается в init.sql при инициализации БД
    // Здесь только создаем таблицы и колонки

    // Добавить поле custom_service_name в posts
    await queryRunner.query(`
      ALTER TABLE "posts" 
      ADD COLUMN IF NOT EXISTS "custom_service_name" TEXT;
    `);

    // Добавить geography колонку для геопоиска (если еще нет)
    await queryRunner.query(`
      ALTER TABLE "posts" 
      ADD COLUMN IF NOT EXISTS "location_geography" geography(POINT, 4326);
    `);

    // Создать таблицу post_services
    await queryRunner.query(`
      CREATE TABLE IF NOT EXISTS "post_services" (
        "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        "post_id" UUID NOT NULL,
        "service_id" UUID NOT NULL,
        "created_at" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "FK_post_services_post" FOREIGN KEY ("post_id") REFERENCES "posts"("id") ON DELETE CASCADE,
        CONSTRAINT "FK_post_services_service" FOREIGN KEY ("service_id") REFERENCES "services"("id") ON DELETE CASCADE,
        CONSTRAINT "UQ_post_services" UNIQUE ("post_id", "service_id")
      );
    `);

    // Индексы для post_services
    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS "IDX_post_services_post" ON "post_services" ("post_id");
    `);
    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS "IDX_post_services_service" ON "post_services" ("service_id");
    `);

    // GIN индекс для полнотекстового поиска по кастомным услугам
    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS "IDX_posts_custom_service_gin" 
      ON "posts" USING gin(to_tsvector('russian', COALESCE("custom_service_name", '')));
    `);

    // Создать GIST индекс для геопоиска
    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS "IDX_posts_location_geography" 
      ON "posts" USING gist("location_geography");
    `);

    // Заполнить geography колонку из существующих координат
    await queryRunner.query(`
      UPDATE "posts" 
      SET "location_geography" = ST_SetSRID(ST_MakePoint("location_lng", "location_lat"), 4326)::geography
      WHERE "location_lat" IS NOT NULL 
        AND "location_lng" IS NOT NULL 
        AND "location_geography" IS NULL;
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // Удалить индексы
    await queryRunner.query(`
      DROP INDEX IF EXISTS "IDX_posts_location_geography";
    `);
    await queryRunner.query(`
      DROP INDEX IF EXISTS "IDX_posts_custom_service_gin";
    `);
    await queryRunner.query(`
      DROP INDEX IF EXISTS "IDX_post_services_service";
    `);
    await queryRunner.query(`
      DROP INDEX IF EXISTS "IDX_post_services_post";
    `);

    // Удалить таблицу post_services
    await queryRunner.query(`DROP TABLE IF EXISTS "post_services";`);

    // Удалить колонки из posts
    await queryRunner.query(`
      ALTER TABLE "posts" 
      DROP COLUMN IF EXISTS "location_geography";
    `);
    await queryRunner.query(`
      ALTER TABLE "posts" 
      DROP COLUMN IF EXISTS "custom_service_name";
    `);
  }
}
