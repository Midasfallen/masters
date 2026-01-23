import { MigrationInterface, QueryRunner, TableColumn } from 'typeorm';

export class AddChatPinning1769270000000 implements MigrationInterface {
  name = 'AddChatPinning1769270000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    // Add is_pinned column to chat_participants table
    await queryRunner.addColumn(
      'chat_participants',
      new TableColumn({
        name: 'is_pinned',
        type: 'boolean',
        default: false,
      }),
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropColumn('chat_participants', 'is_pinned');
  }
}
