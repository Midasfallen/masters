import { MigrationInterface, QueryRunner, Table, TableIndex } from 'typeorm';

export class AddFavorites1769268000000 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.createTable(
      new Table({
        name: 'favorites',
        columns: [
          {
            name: 'id',
            type: 'uuid',
            isPrimary: true,
            default: 'uuid_generate_v4()',
          },
          {
            name: 'user_id',
            type: 'uuid',
            isNullable: false,
          },
          {
            name: 'entity_type',
            type: 'enum',
            enum: ['master', 'post'],
            isNullable: false,
          },
          {
            name: 'entity_id',
            type: 'uuid',
            isNullable: false,
          },
          {
            name: 'created_at',
            type: 'timestamp',
            default: 'CURRENT_TIMESTAMP',
          },
        ],
        foreignKeys: [
          {
            name: 'FK_favorites_user',
            columnNames: ['user_id'],
            referencedTableName: 'users',
            referencedColumnNames: ['id'],
            onDelete: 'CASCADE',
          },
        ],
      }),
      true,
    );

    // Создаем индексы
    await queryRunner.createIndex(
      'favorites',
      new TableIndex({
        name: 'IDX_favorites_user_id',
        columnNames: ['user_id'],
      }),
    );

    await queryRunner.createIndex(
      'favorites',
      new TableIndex({
        name: 'IDX_favorites_entity_type',
        columnNames: ['entity_type'],
      }),
    );

    await queryRunner.createIndex(
      'favorites',
      new TableIndex({
        name: 'IDX_favorites_user_entity_type',
        columnNames: ['user_id', 'entity_type'],
      }),
    );

    // Уникальный индекс для предотвращения дубликатов
    await queryRunner.createIndex(
      'favorites',
      new TableIndex({
        name: 'IDX_favorites_unique',
        columnNames: ['user_id', 'entity_id', 'entity_type'],
        isUnique: true,
      }),
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropTable('favorites');
  }
}
