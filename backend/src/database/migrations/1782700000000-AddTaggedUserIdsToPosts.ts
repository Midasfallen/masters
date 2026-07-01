import { MigrationInterface, QueryRunner } from 'typeorm';

export class AddTaggedUserIdsToPosts1782700000000 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    // Отмеченные (tagged) пользователи поста — массив UUID (users.id).
    // По аналогии с category_ids: колонка-массив, без junction-таблицы.
    await queryRunner.query(`
      ALTER TABLE "posts"
      ADD COLUMN IF NOT EXISTS "tagged_user_ids" UUID[] DEFAULT '{}';
    `);

    // GIN-индекс для эффективного поиска постов, где отмечён пользователь
    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS "IDX_posts_tagged_user_ids"
      ON "posts" USING gin("tagged_user_ids");
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP INDEX IF EXISTS "IDX_posts_tagged_user_ids";`);
    await queryRunner.query(`ALTER TABLE "posts" DROP COLUMN IF EXISTS "tagged_user_ids";`);
  }
}
