import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateSocialTables1735544100000 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    // Create likes table
    await queryRunner.query(`
      CREATE TABLE "likes" (
        "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        "user_id" UUID NOT NULL,
        "likable_type" VARCHAR(20) NOT NULL,
        "likable_id" UUID NOT NULL,
        "created_at" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "FK_likes_user" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE,
        CONSTRAINT "UQ_likes_user_likable" UNIQUE ("user_id", "likable_type", "likable_id")
      );
    `);

    // Create indexes for likes
    await queryRunner.query(`CREATE INDEX "IDX_likes_likable" ON "likes" ("likable_type", "likable_id");`);
    await queryRunner.query(`CREATE INDEX "IDX_likes_user" ON "likes" ("user_id");`);

    // Create comments table
    await queryRunner.query(`
      CREATE TABLE "comments" (
        "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        "post_id" UUID NOT NULL,
        "author_id" UUID NOT NULL,
        "content" TEXT NOT NULL,
        "parent_comment_id" UUID,
        "likes_count" INTEGER NOT NULL DEFAULT 0,
        "replies_count" INTEGER NOT NULL DEFAULT 0,
        "is_edited" BOOLEAN NOT NULL DEFAULT false,
        "created_at" TIMESTAMP NOT NULL DEFAULT now(),
        "updated_at" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "FK_comments_post" FOREIGN KEY ("post_id") REFERENCES "posts"("id") ON DELETE CASCADE,
        CONSTRAINT "FK_comments_author" FOREIGN KEY ("author_id") REFERENCES "users"("id") ON DELETE CASCADE,
        CONSTRAINT "FK_comments_parent" FOREIGN KEY ("parent_comment_id") REFERENCES "comments"("id") ON DELETE CASCADE
      );
    `);

    // Create indexes for comments
    await queryRunner.query(`CREATE INDEX "IDX_comments_post_created" ON "comments" ("post_id", "created_at");`);
    await queryRunner.query(`CREATE INDEX "IDX_comments_author" ON "comments" ("author_id");`);
    await queryRunner.query(`CREATE INDEX "IDX_comments_parent" ON "comments" ("parent_comment_id");`);

    // Create reposts table
    await queryRunner.query(`
      CREATE TABLE "reposts" (
        "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        "user_id" UUID NOT NULL,
        "post_id" UUID NOT NULL,
        "comment" TEXT,
        "created_at" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "FK_reposts_user" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE,
        CONSTRAINT "FK_reposts_post" FOREIGN KEY ("post_id") REFERENCES "posts"("id") ON DELETE CASCADE,
        CONSTRAINT "UQ_reposts_user_post" UNIQUE ("user_id", "post_id")
      );
    `);

    // Create indexes for reposts
    await queryRunner.query(`CREATE INDEX "IDX_reposts_post_created" ON "reposts" ("post_id", "created_at");`);
    await queryRunner.query(`CREATE INDEX "IDX_reposts_user" ON "reposts" ("user_id");`);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE "reposts";`);
    await queryRunner.query(`DROP TABLE "comments";`);
    await queryRunner.query(`DROP TABLE "likes";`);
  }
}
