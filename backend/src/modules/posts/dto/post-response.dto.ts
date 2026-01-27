import { ApiProperty } from '@nestjs/swagger';
import { Expose, Type } from 'class-transformer';
import { PostType, PostPrivacy } from '../entities/post.entity';
import { PostMediaResponseDto } from './post-media-response.dto';
import { AuthUserDto } from '../../auth/dto/auth-response.dto';

export class PostResponseDto {
  @Expose()
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id: string;

  @Expose()
  @ApiProperty({ description: 'ID автора поста' })
  authorId: string;

  @Expose()
  @ApiProperty({ enum: PostType, example: PostType.TEXT })
  type: PostType;

  @Expose()
  @ApiProperty({ example: 'Привет, мир! Это мой первый пост.' })
  content: string;

  @Expose()
  @ApiProperty({ enum: PostPrivacy, example: PostPrivacy.PUBLIC })
  privacy: PostPrivacy;

  @Expose()
  @ApiProperty({
    description: 'ID репоста (если это repost)',
    nullable: true
  })
  repostOfId: string | null;

  @Expose()
  @ApiProperty({ description: 'Количество лайков', default: 0 })
  likesCount: number;

  @Expose()
  @ApiProperty({ description: 'Количество комментариев', default: 0 })
  commentsCount: number;

  @Expose()
  @ApiProperty({ description: 'Количество репостов', default: 0 })
  repostsCount: number;

  @Expose()
  @ApiProperty({ description: 'Количество просмотров', default: 0 })
  viewsCount: number;

  @Expose()
  @ApiProperty({ description: 'Геолокация поста', nullable: true })
  locationLat: number | null;

  @Expose()
  @ApiProperty({ description: 'Геолокация поста', nullable: true })
  locationLng: number | null;

  @Expose()
  @ApiProperty({ description: 'Название места', nullable: true })
  locationName: string | null;

  @Expose()
  @ApiProperty({ description: 'Комментарии отключены', default: false })
  commentsDisabled: boolean;

  @Expose()
  @ApiProperty({ description: 'Пост закреплен', default: false })
  isPinned: boolean;

  @Expose()
  @ApiProperty()
  createdAt: Date;

  @Expose()
  @ApiProperty()
  updatedAt: Date;

  // Relations
  @Expose()
  @Type(() => AuthUserDto)
  @ApiProperty({ description: 'Автор поста', type: AuthUserDto })
  author: AuthUserDto;

  @Expose()
  @Type(() => PostMediaResponseDto)
  @ApiProperty({
    description: 'Медиа файлы поста',
    type: [PostMediaResponseDto]
  })
  media: PostMediaResponseDto[];

  @Expose()
  @Type(() => PostResponseDto)
  @ApiProperty({
    description: 'Оригинальный пост (для репостов)',
    type: PostResponseDto,
    nullable: true
  })
  repostOf: PostResponseDto | null;
}
