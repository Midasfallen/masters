import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
  Index,
} from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';
import { User } from '../../users/entities/user.entity';
import { Post } from '../../posts/entities/post.entity';

@Entity('comments')
@Index(['post_id', 'created_at'])
@Index(['author_id'])
@Index(['parent_comment_id'])
export class Comment {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ApiProperty({ description: 'ID поста' })
  @Column({ type: 'uuid' })
  post_id: string;

  @ApiProperty({ description: 'ID автора комментария' })
  @Column({ type: 'uuid' })
  author_id: string;

  @ApiProperty({ example: 'Отличный пост!' })
  @Column({ type: 'text' })
  content: string;

  @ApiProperty({ description: 'ID родительского комментария (для ответов)', nullable: true })
  @Column({ type: 'uuid', nullable: true })
  parent_comment_id: string;

  @ApiProperty({ description: 'Количество лайков', default: 0 })
  @Column({ type: 'integer', default: 0 })
  likes_count: number;

  @ApiProperty({ description: 'Количество ответов', default: 0 })
  @Column({ type: 'integer', default: 0 })
  replies_count: number;

  @ApiProperty({ description: 'Комментарий отредактирован', default: false })
  @Column({ type: 'boolean', default: false })
  is_edited: boolean;

  @ApiProperty()
  @CreateDateColumn()
  created_at: Date;

  @ApiProperty()
  @UpdateDateColumn()
  updated_at: Date;

  // Relations
  @ManyToOne(() => Post, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'post_id' })
  post: Post;

  @ManyToOne(() => User, { eager: false })
  @JoinColumn({ name: 'author_id' })
  author: User;

  @ManyToOne(() => Comment, { nullable: true })
  @JoinColumn({ name: 'parent_comment_id' })
  parent_comment: Comment;
}
