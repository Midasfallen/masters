import { MigrationInterface, QueryRunner } from 'typeorm';

/**
 * Один booking допускает ДВА отзыва: клиент->мастер и мастер->клиент.
 * Старый UNIQUE(booking_id) позволял только один и ронял POST /reviews
 * второго участника с 500. Меняем на UNIQUE(booking_id, reviewer_type).
 */
export class ReviewUniquePerReviewerType1783500000000 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `ALTER TABLE "reviews" DROP CONSTRAINT IF EXISTS "UQ_bbd6ac6e3e6a8f8c6e0e8692d63"`,
    );
    await queryRunner.query(
      `DROP INDEX IF EXISTS "IDX_bbd6ac6e3e6a8f8c6e0e8692d6"`,
    );
    await queryRunner.query(
      `CREATE UNIQUE INDEX "UQ_reviews_booking_reviewer_type" ON "reviews" ("booking_id", "reviewer_type")`,
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `DROP INDEX IF EXISTS "UQ_reviews_booking_reviewer_type"`,
    );
    await queryRunner.query(
      `CREATE UNIQUE INDEX "IDX_bbd6ac6e3e6a8f8c6e0e8692d6" ON "reviews" ("booking_id")`,
    );
    await queryRunner.query(
      `ALTER TABLE "reviews" ADD CONSTRAINT "UQ_bbd6ac6e3e6a8f8c6e0e8692d63" UNIQUE ("booking_id")`,
    );
  }
}
