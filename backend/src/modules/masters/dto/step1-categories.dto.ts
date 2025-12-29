import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsArray, IsNotEmpty, IsUUID } from 'class-validator';

/**
 * ШАГ 1: Выбор категорий и подкатегорий услуг
 * Мастер выбирает, в каких категориях он работает
 */
export class Step1CategoriesDto {
  @ApiProperty({
    description: 'UUID категорий, в которых работает мастер',
    type: [String],
    example: ['550e8400-e29b-41d4-a716-446655440000'],
  })
  @IsArray()
  @IsNotEmpty({ each: true })
  @IsUUID('4', { each: true })
  category_ids: string[];

  @ApiPropertyOptional({
    description: 'UUID подкатегорий (опционально)',
    type: [String],
    example: ['660e8400-e29b-41d4-a716-446655440001'],
  })
  @IsArray()
  @IsUUID('4', { each: true })
  subcategory_ids?: string[];
}
