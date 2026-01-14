import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  OneToMany,
  JoinColumn,
  Index,
} from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';
import { User } from '../../users/entities/user.entity';
import { PostMedia } from './post-media.entity';

export enum PostType {
  TEXT = 'text',
  PHOTO = 'photo',
  VIDEO = 'video',
  REPOST = 'repost',
}

export enum PostPrivacy {
  PUBLIC = 'public',
  FRIENDS = 'friends',
  PRIVATE = 'private',
}

@Entity('posts')
@Index(['author_id', 'created_at'])
@Index(['created_at'])
@Index(['type'])
export class Post {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ApiProperty({ description: 'ID автора поста' })
  @Column({ type: 'uuid' })
  author_id: string;

  @ApiProperty({ enum: PostType, example: PostType.TEXT })
  @Column({
    type: 'enum',
    enum: PostType,
    default: PostType.TEXT,
  })
  type: PostType;

  @ApiProperty({ example: 'Привет, мир! Это мой первый пост.' })
  @Column({ type: 'text', nullable: true })
  content: string;

  @ApiProperty({ enum: PostPrivacy, example: PostPrivacy.PUBLIC })
  @Column({
    type: 'enum',
    enum: PostPrivacy,
    default: PostPrivacy.PUBLIC,
  })
  privacy: PostPrivacy;

  @ApiProperty({ description: 'ID репоста (если это repost)', nullable: true })
  @Column({ type: 'uuid', nullable: true })
  repost_of_id: string;

  @ApiProperty({ description: 'Количество лайков', default: 0 })
  @Column({ type: 'integer', default: 0 })
  likes_count: number;

  @ApiProperty({ description: 'Количество комментариев', default: 0 })
  @Column({ type: 'integer', default: 0 })
  comments_count: number;

  @ApiProperty({ description: 'Количество репостов', default: 0 })
  @Column({ type: 'integer', default: 0 })
  reposts_count: number;

  @ApiProperty({ description: 'Количество просмотров', default: 0 })
  @Column({ type: 'integer', default: 0 })
  views_count: number;

  @ApiProperty({ description: 'Геолокация поста', nullable: true })
  @Column({ type: 'decimal', precision: 10, scale: 8, nullable: true })
  location_lat: number;

  @ApiProperty({ description: 'Геолокация поста', nullable: true })
  @Column({ type: 'decimal', precision: 11, scale: 8, nullable: true })
  location_lng: number;

  @ApiProperty({ description: 'Название места', nullable: true })
  @Column({ type: 'varchar', length: 255, nullable: true })
  location_name: string;

  @ApiProperty({ description: 'Комментарии отключены', default: false })
  @Column({ type: 'boolean', default: false })
  comments_disabled: boolean;

  @ApiProperty({ description: 'Пост закреплен', default: false })
  @Column({ type: 'boolean', default: false })
  is_pinned: boolean;

  @ApiProperty()
  @CreateDateColumn()
  created_at: Date;

  @ApiProperty()
  @UpdateDateColumn()
  updated_at: Date;

  // Relations
  @ManyToOne(() => User, { eager: false })
  @JoinColumn({ name: 'author_id' })
  author: User;

  @OneToMany(() => PostMedia, (media) => media.post, {
    cascade: true,
    eager: false,
  })
  media: PostMedia[];

  @ManyToOne(() => Post, { nullable: true })
  @JoinColumn({ name: 'repost_of_id' })
  repost_of: Post;
}
