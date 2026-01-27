import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';
import { MediaType } from '../entities/post-media.entity';

export class PostMediaResponseDto {
  @Expose()
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id: string;

  @Expose()
  @ApiProperty({ description: 'ID поста' })
  postId: string;

  @Expose()
  @ApiProperty({ enum: MediaType, example: MediaType.PHOTO })
  type: MediaType;

  @Expose()
  @ApiProperty({ example: 'https://storage.example.com/posts/photo.jpg' })
  url: string;

  @Expose()
  @ApiProperty({
    example: 'https://storage.example.com/posts/photo_thumb.jpg',
    nullable: true
  })
  thumbnailUrl: string | null;

  @Expose()
  @ApiProperty({ description: 'Порядок медиа в посте', default: 0 })
  order: number;

  @Expose()
  @ApiProperty({
    description: 'Ширина изображения/видео в пикселях',
    nullable: true
  })
  width: number | null;

  @Expose()
  @ApiProperty({
    description: 'Высота изображения/видео в пикселях',
    nullable: true
  })
  height: number | null;

  @Expose()
  @ApiProperty({
    description: 'Длительность видео в секундах',
    nullable: true
  })
  duration: number | null;
}
