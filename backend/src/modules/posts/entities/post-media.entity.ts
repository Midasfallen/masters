import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  ManyToOne,
  JoinColumn,
  Index,
} from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';
import { Post } from './post.entity';

export enum MediaType {
  PHOTO = 'photo',
  VIDEO = 'video',
}

@Entity('post_media')
@Index(['post_id'])
export class PostMedia {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ApiProperty({ description: 'ID поста' })
  @Column({ type: 'uuid' })
  post_id: string;

  @ApiProperty({ enum: MediaType, example: MediaType.PHOTO })
  @Column({
    type: 'enum',
    enum: MediaType,
  })
  type: MediaType;

  @ApiProperty({ example: 'https://storage.example.com/posts/photo.jpg' })
  @Column({ type: 'text' })
  url: string;

  @ApiProperty({ example: 'https://storage.example.com/posts/photo_thumb.jpg', nullable: true })
  @Column({ type: 'text', nullable: true })
  thumbnail_url: string;

  @ApiProperty({ description: 'Порядок медиа в посте', default: 0 })
  @Column({ type: 'integer', default: 0 })
  order: number;

  @ApiProperty({ description: 'Ширина изображения/видео в пикселях', nullable: true })
  @Column({ type: 'integer', nullable: true })
  width: number;

  @ApiProperty({ description: 'Высота изображения/видео в пикселях', nullable: true })
  @Column({ type: 'integer', nullable: true })
  height: number;

  @ApiProperty({ description: 'Длительность видео в секундах', nullable: true })
  @Column({ type: 'integer', nullable: true })
  duration: number;

  // Relations
  @ManyToOne(() => Post, (post) => post.media, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'post_id' })
  post: Post;
}
