import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateServiceTemplates1770313946604 implements MigrationInterface {
  name = 'CreateServiceTemplates1770313946604';

  public async up(queryRunner: QueryRunner): Promise<void> {
    // Создание таблицы service_templates
    await queryRunner.query(`
      CREATE TABLE "service_templates" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "category_id" uuid NOT NULL,
        "slug" character varying(255) NOT NULL,
        "name" character varying(255) NOT NULL,
        "description" text,
        "icon_url" text,
        "default_duration_minutes" integer,
        "default_price_range_min" numeric(10,2),
        "default_price_range_max" numeric(10,2),
        "is_active" boolean NOT NULL DEFAULT true,
        "display_order" integer NOT NULL DEFAULT '0',
        "created_at" TIMESTAMP NOT NULL DEFAULT now(),
        "updated_at" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "PK_service_templates" PRIMARY KEY ("id"),
        CONSTRAINT "UQ_service_templates_slug" UNIQUE ("slug"),
        CONSTRAINT "FK_service_templates_category" 
          FOREIGN KEY ("category_id") 
          REFERENCES "categories"("id") 
          ON DELETE CASCADE 
          ON UPDATE NO ACTION
      )
    `);

    // Индексы для service_templates
    await queryRunner.query(`
      CREATE INDEX "IDX_service_templates_category" 
      ON "service_templates" ("category_id")
    `);

    await queryRunner.query(`
      CREATE INDEX "IDX_service_templates_active" 
      ON "service_templates" ("is_active")
    `);

    await queryRunner.query(`
      CREATE INDEX "IDX_service_templates_slug" 
      ON "service_templates" ("slug")
    `);

    // Создание таблицы service_template_translations
    await queryRunner.query(`
      CREATE TABLE "service_template_translations" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "service_template_id" uuid NOT NULL,
        "language" character varying(10) NOT NULL,
        "name" character varying(255) NOT NULL,
        "description" text,
        "keywords" character varying(50) array NOT NULL DEFAULT '{}',
        "created_at" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "PK_service_template_translations" PRIMARY KEY ("id"),
        CONSTRAINT "UQ_service_template_translation" 
          UNIQUE ("service_template_id", "language"),
        CONSTRAINT "FK_service_template_translations_template" 
          FOREIGN KEY ("service_template_id") 
          REFERENCES "service_templates"("id") 
          ON DELETE CASCADE 
          ON UPDATE NO ACTION
      )
    `);

    // Индексы для service_template_translations
    await queryRunner.query(`
      CREATE INDEX "IDX_service_template_translations_template" 
      ON "service_template_translations" ("service_template_id")
    `);

    await queryRunner.query(`
      CREATE INDEX "IDX_service_template_translations_language" 
      ON "service_template_translations" ("language")
    `);

    // Добавление колонки service_template_id в services
    await queryRunner.query(`
      ALTER TABLE "services" 
      ADD COLUMN "service_template_id" uuid
    `);

    // Индекс для service_template_id в services
    await queryRunner.query(`
      CREATE INDEX "IDX_services_template" 
      ON "services" ("service_template_id")
    `);

    // Внешний ключ для service_template_id
    await queryRunner.query(`
      ALTER TABLE "services" 
      ADD CONSTRAINT "FK_services_template" 
      FOREIGN KEY ("service_template_id") 
      REFERENCES "service_templates"("id") 
      ON DELETE SET NULL 
      ON UPDATE NO ACTION
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // Удаление внешнего ключа и колонки service_template_id из services
    await queryRunner.query(`
      ALTER TABLE "services" 
      DROP CONSTRAINT IF EXISTS "FK_services_template"
    `);

    await queryRunner.query(`
      DROP INDEX IF EXISTS "IDX_services_template"
    `);

    await queryRunner.query(`
      ALTER TABLE "services" 
      DROP COLUMN IF EXISTS "service_template_id"
    `);

    // Удаление индексов service_template_translations
    await queryRunner.query(`
      DROP INDEX IF EXISTS "IDX_service_template_translations_language"
    `);

    await queryRunner.query(`
      DROP INDEX IF EXISTS "IDX_service_template_translations_template"
    `);

    // Удаление таблицы service_template_translations
    await queryRunner.query(`
      DROP TABLE IF EXISTS "service_template_translations"
    `);

    // Удаление индексов service_templates
    await queryRunner.query(`
      DROP INDEX IF EXISTS "IDX_service_templates_slug"
    `);

    await queryRunner.query(`
      DROP INDEX IF EXISTS "IDX_service_templates_active"
    `);

    await queryRunner.query(`
      DROP INDEX IF EXISTS "IDX_service_templates_category"
    `);

    // Удаление таблицы service_templates
    await queryRunner.query(`
      DROP TABLE IF EXISTS "service_templates"
    `);
  }
}
