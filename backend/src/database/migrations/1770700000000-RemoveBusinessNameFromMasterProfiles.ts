import { MigrationInterface, QueryRunner } from 'typeorm';

export class RemoveBusinessNameFromMasterProfiles1770700000000
  implements MigrationInterface
{
  name = 'RemoveBusinessNameFromMasterProfiles1770700000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `ALTER TABLE "master_profiles" DROP COLUMN IF EXISTS "business_name"`,
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `ALTER TABLE "master_profiles" ADD COLUMN "business_name" VARCHAR(255)`,
    );
  }
}
