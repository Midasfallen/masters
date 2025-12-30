import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateChatsTables1735544300000 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    // Create chats table
    await queryRunner.query(`
      CREATE TABLE "chats" (
        "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        "type" VARCHAR(20) NOT NULL DEFAULT 'direct',
        "name" VARCHAR(255),
        "avatar_url" TEXT,
        "creator_id" UUID,
        "last_message_id" UUID,
        "last_message_at" TIMESTAMP,
        "created_at" TIMESTAMP NOT NULL DEFAULT now(),
        "updated_at" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "FK_chats_creator" FOREIGN KEY ("creator_id") REFERENCES "users"("id") ON DELETE SET NULL
      );
    `);

    // Create indexes for chats
    await queryRunner.query(`CREATE INDEX "IDX_chats_type" ON "chats" ("type");`);
    await queryRunner.query(`CREATE INDEX "IDX_chats_created_at" ON "chats" ("created_at");`);

    // Create messages table
    await queryRunner.query(`
      CREATE TABLE "messages" (
        "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        "chat_id" UUID NOT NULL,
        "sender_id" UUID NOT NULL,
        "type" VARCHAR(20) NOT NULL DEFAULT 'text',
        "content" TEXT,
        "media_url" TEXT,
        "thumbnail_url" TEXT,
        "media_metadata" JSONB,
        "location_lat" DECIMAL(10, 8),
        "location_lng" DECIMAL(11, 8),
        "location_name" VARCHAR(255),
        "reply_to_id" UUID,
        "read_count" INTEGER NOT NULL DEFAULT 0,
        "is_edited" BOOLEAN NOT NULL DEFAULT false,
        "is_deleted" BOOLEAN NOT NULL DEFAULT false,
        "created_at" TIMESTAMP NOT NULL DEFAULT now(),
        "updated_at" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "FK_messages_chat" FOREIGN KEY ("chat_id") REFERENCES "chats"("id") ON DELETE CASCADE,
        CONSTRAINT "FK_messages_sender" FOREIGN KEY ("sender_id") REFERENCES "users"("id") ON DELETE CASCADE,
        CONSTRAINT "FK_messages_reply" FOREIGN KEY ("reply_to_id") REFERENCES "messages"("id") ON DELETE SET NULL
      );
    `);

    // Create indexes for messages
    await queryRunner.query(`CREATE INDEX "IDX_messages_chat_created" ON "messages" ("chat_id", "created_at");`);
    await queryRunner.query(`CREATE INDEX "IDX_messages_sender" ON "messages" ("sender_id");`);

    // Create chat_participants table
    await queryRunner.query(`
      CREATE TABLE "chat_participants" (
        "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        "chat_id" UUID NOT NULL,
        "user_id" UUID NOT NULL,
        "role" VARCHAR(20) NOT NULL DEFAULT 'member',
        "last_read_message_id" UUID,
        "last_read_at" TIMESTAMP,
        "unread_count" INTEGER NOT NULL DEFAULT 0,
        "notifications_enabled" BOOLEAN NOT NULL DEFAULT true,
        "is_archived" BOOLEAN NOT NULL DEFAULT false,
        "is_removed" BOOLEAN NOT NULL DEFAULT false,
        "joined_at" TIMESTAMP NOT NULL DEFAULT now(),
        "updated_at" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "FK_chat_participants_chat" FOREIGN KEY ("chat_id") REFERENCES "chats"("id") ON DELETE CASCADE,
        CONSTRAINT "FK_chat_participants_user" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE,
        CONSTRAINT "UQ_chat_participants" UNIQUE ("chat_id", "user_id")
      );
    `);

    // Create indexes for chat_participants
    await queryRunner.query(`CREATE INDEX "IDX_chat_participants_chat" ON "chat_participants" ("chat_id");`);
    await queryRunner.query(`CREATE INDEX "IDX_chat_participants_user" ON "chat_participants" ("user_id");`);

    // Add foreign key constraint for last_message_id in chats table
    await queryRunner.query(`
      ALTER TABLE "chats"
      ADD CONSTRAINT "FK_chats_last_message" FOREIGN KEY ("last_message_id") REFERENCES "messages"("id") ON DELETE SET NULL;
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`ALTER TABLE "chats" DROP CONSTRAINT "FK_chats_last_message";`);
    await queryRunner.query(`DROP TABLE "chat_participants";`);
    await queryRunner.query(`DROP TABLE "messages";`);
    await queryRunner.query(`DROP TABLE "chats";`);
  }
}
