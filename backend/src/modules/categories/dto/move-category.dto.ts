import { ApiProperty } from '@nestjs/swagger';
import { IsUUID, IsOptional } from 'class-validator';

export class MoveCategoryDto {
  @ApiProperty({
    description: 'ID новой родительской категории (NULL для перемещения в корень)',
    required: false,
  })
  @IsOptional()
  @IsUUID('4')
  new_parent_id?: string;
}
