import { PartialType, OmitType } from '@nestjs/swagger';
import { CreateCategoryDto } from './create-category.dto';

// Убираем parent_id из обновления (нельзя менять родителя напрямую)
export class UpdateCategoryDto extends PartialType(
  OmitType(CreateCategoryDto, ['parent_id', 'slug'] as const),
) {}
