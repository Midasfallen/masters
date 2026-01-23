import { MigrationInterface, QueryRunner, Table, TableForeignKey } from "typeorm";

export class AddReviewReminders1769086715332 implements MigrationInterface {

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Создаем таблицу review_reminders для отслеживания напоминаний
        await queryRunner.createTable(
            new Table({
                name: 'review_reminders',
                columns: [
                    {
                        name: 'id',
                        type: 'uuid',
                        isPrimary: true,
                        generationStrategy: 'uuid',
                        default: 'uuid_generate_v4()',
                    },
                    {
                        name: 'user_id',
                        type: 'uuid',
                        isNullable: false,
                    },
                    {
                        name: 'booking_id',
                        type: 'uuid',
                        isNullable: false,
                    },
                    {
                        name: 'reminder_count',
                        type: 'integer',
                        default: 0,
                    },
                    {
                        name: 'grace_skip_allowed',
                        type: 'boolean',
                        default: false,
                    },
                    {
                        name: 'last_reminded_at',
                        type: 'timestamp',
                        isNullable: true,
                    },
                    {
                        name: 'created_at',
                        type: 'timestamp',
                        default: 'CURRENT_TIMESTAMP',
                    },
                    {
                        name: 'updated_at',
                        type: 'timestamp',
                        default: 'CURRENT_TIMESTAMP',
                    },
                ],
                indices: [
                    {
                        name: 'IDX_review_reminders_user_id',
                        columnNames: ['user_id'],
                    },
                    {
                        name: 'IDX_review_reminders_booking_id',
                        columnNames: ['booking_id'],
                    },
                ],
            }),
            true,
        );

        // Добавляем foreign keys
        await queryRunner.createForeignKey(
            'review_reminders',
            new TableForeignKey({
                columnNames: ['user_id'],
                referencedColumnNames: ['id'],
                referencedTableName: 'users',
                onDelete: 'CASCADE',
            }),
        );

        await queryRunner.createForeignKey(
            'review_reminders',
            new TableForeignKey({
                columnNames: ['booking_id'],
                referencedColumnNames: ['id'],
                referencedTableName: 'bookings',
                onDelete: 'CASCADE',
            }),
        );
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.dropTable('review_reminders');
    }

}
