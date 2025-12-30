import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateFriendsTables1735544200000 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    // Create friendships table
    await queryRunner.query(`
      CREATE TABLE "friendships" (
        "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        "requester_id" UUID NOT NULL,
        "addressee_id" UUID NOT NULL,
        "status" VARCHAR(20) NOT NULL DEFAULT 'pending',
        "created_at" TIMESTAMP NOT NULL DEFAULT now(),
        "updated_at" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "FK_friendships_requester" FOREIGN KEY ("requester_id") REFERENCES "users"("id") ON DELETE CASCADE,
        CONSTRAINT "FK_friendships_addressee" FOREIGN KEY ("addressee_id") REFERENCES "users"("id") ON DELETE CASCADE,
        CONSTRAINT "UQ_friendships_users" UNIQUE ("requester_id", "addressee_id")
      );
    `);

    // Create indexes for friendships
    await queryRunner.query(`CREATE INDEX "IDX_friendships_requester_status" ON "friendships" ("requester_id", "status");`);
    await queryRunner.query(`CREATE INDEX "IDX_friendships_addressee_status" ON "friendships" ("addressee_id", "status");`);

    // Create subscriptions table
    await queryRunner.query(`
      CREATE TABLE "subscriptions" (
        "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        "subscriber_id" UUID NOT NULL,
        "target_id" UUID NOT NULL,
        "notifications_enabled" BOOLEAN NOT NULL DEFAULT true,
        "created_at" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "FK_subscriptions_subscriber" FOREIGN KEY ("subscriber_id") REFERENCES "users"("id") ON DELETE CASCADE,
        CONSTRAINT "FK_subscriptions_target" FOREIGN KEY ("target_id") REFERENCES "users"("id") ON DELETE CASCADE,
        CONSTRAINT "UQ_subscriptions_users" UNIQUE ("subscriber_id", "target_id")
      );
    `);

    // Create indexes for subscriptions
    await queryRunner.query(`CREATE INDEX "IDX_subscriptions_subscriber" ON "subscriptions" ("subscriber_id");`);
    await queryRunner.query(`CREATE INDEX "IDX_subscriptions_target" ON "subscriptions" ("target_id");`);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE "subscriptions";`);
    await queryRunner.query(`DROP TABLE "friendships";`);
  }
}
