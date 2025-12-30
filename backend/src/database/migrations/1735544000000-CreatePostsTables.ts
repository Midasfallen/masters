import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreatePostsTables1735544000000 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    // Create posts table
    await queryRunner.query(`
      CREATE TABLE "posts" (
        "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        "author_id" UUID NOT NULL,
        "type" VARCHAR(20) NOT NULL DEFAULT 'text',
        "content" TEXT,
        "privacy" VARCHAR(20) NOT NULL DEFAULT 'public',
        "repost_of_id" UUID,
        "likes_count" INTEGER NOT NULL DEFAULT 0,
        "comments_count" INTEGER NOT NULL DEFAULT 0,
        "reposts_count" INTEGER NOT NULL DEFAULT 0,
        "views_count" INTEGER NOT NULL DEFAULT 0,
        "location_lat" DECIMAL(10, 8),
        "location_lng" DECIMAL(11, 8),
        "location_name" VARCHAR(255),
        "comments_disabled" BOOLEAN NOT NULL DEFAULT false,
        "is_pinned" BOOLEAN NOT NULL DEFAULT false,
        "created_at" TIMESTAMP NOT NULL DEFAULT now(),
        "updated_at" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "FK_posts_author" FOREIGN KEY ("author_id") REFERENCES "users"("id") ON DELETE CASCADE,
        CONSTRAINT "FK_posts_repost" FOREIGN KEY ("repost_of_id") REFERENCES "posts"("id") ON DELETE SET NULL
      );
    `);

    // Create indexes for posts
    await queryRunner.query(`CREATE INDEX "IDX_posts_author_created" ON "posts" ("author_id", "created_at");`);
    await queryRunner.query(`CREATE INDEX "IDX_posts_created_at" ON "posts" ("created_at");`);
    await queryRunner.query(`CREATE INDEX "IDX_posts_type" ON "posts" ("type");`);

    // Create post_media table
    await queryRunner.query(`
      CREATE TABLE "post_media" (
        "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        "post_id" UUID NOT NULL,
        "type" VARCHAR(20) NOT NULL,
        "url" TEXT NOT NULL,
        "thumbnail_url" TEXT,
        "order" INTEGER NOT NULL DEFAULT 0,
        "width" INTEGER,
        "height" INTEGER,
        "duration" INTEGER,
        CONSTRAINT "FK_post_media_post" FOREIGN KEY ("post_id") REFERENCES "posts"("id") ON DELETE CASCADE
      );
    `);

    // Create index for post_media
    await queryRunner.query(`CREATE INDEX "IDX_post_media_post" ON "post_media" ("post_id");`);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE "post_media";`);
    await queryRunner.query(`DROP TABLE "posts";`);
  }
}
