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

export enum LikableType {
  POST = 'post',
  COMMENT = 'comment',
}

@Entity('likes')
@Unique(['user_id', 'likable_type', 'likable_id'])
@Index(['likable_type', 'likable_id'])
@Index(['user_id'])
export class Like {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ApiProperty({ description: 'ID пользователя, который поставил лайк' })
  @Column({ type: 'uuid' })
  user_id: string;

  @ApiProperty({ enum: LikableType, example: LikableType.POST })
  @Column({
    type: 'enum',
    enum: LikableType,
  })
  likable_type: LikableType;

  @ApiProperty({ description: 'ID объекта (поста или комментария)' })
  @Column({ type: 'uuid' })
  likable_id: string;

  @ApiProperty()
  @CreateDateColumn()
  created_at: Date;

  // Relations
  @ManyToOne(() => User, { eager: false })
  @JoinColumn({ name: 'user_id' })
  user: User;

  // Polymorphic relations (будут использоваться программно)
  // @ManyToOne(() => Post)
  // @JoinColumn({ name: 'likable_id' })
  // post: Post;

  // @ManyToOne(() => Comment)
  // @JoinColumn({ name: 'likable_id' })
  // comment: Comment;
}
