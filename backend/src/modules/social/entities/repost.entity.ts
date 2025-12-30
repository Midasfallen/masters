import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
  Index,
  Unique,
} from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';
import { User } from '../../users/entities/user.entity';
import { Post } from '../../posts/entities/post.entity';

@Entity('reposts')
@Unique(['user_id', 'post_id'])
@Index(['post_id', 'created_at'])
@Index(['user_id'])
export class Repost {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ApiProperty({ description: 'ID пользователя, который сделал репост' })
  @Column({ type: 'uuid' })
  user_id: string;

  @ApiProperty({ description: 'ID оригинального поста' })
  @Column({ type: 'uuid' })
  post_id: string;

  @ApiProperty({ description: 'Комментарий к репосту', nullable: true })
  @Column({ type: 'text', nullable: true })
  comment: string;

  @ApiProperty()
  @CreateDateColumn()
  created_at: Date;

  // Relations
  @ManyToOne(() => User, { eager: false })
  @JoinColumn({ name: 'user_id' })
  user: User;

  @ManyToOne(() => Post, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'post_id' })
  post: Post;
}
