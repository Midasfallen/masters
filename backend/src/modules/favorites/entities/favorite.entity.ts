import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
  Index,
} from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';
import { User } from '../../users/entities/user.entity';

export enum FavoriteEntityType {
  MASTER = 'master',
  POST = 'post',
}

@Entity('favorites')
@Index(['user_id'])
@Index(['entity_type'])
@Index(['user_id', 'entity_type'])
@Index(['user_id', 'entity_id', 'entity_type'], { unique: true })
export class Favorite {
  @ApiProperty({ description: 'ID избранного' })
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ApiProperty({ description: 'ID пользователя' })
  @Column({ type: 'uuid' })
  user_id: string;

  @ApiProperty({ description: 'Тип сущности', enum: FavoriteEntityType })
  @Column({
    type: 'enum',
    enum: FavoriteEntityType,
  })
  entity_type: FavoriteEntityType;

  @ApiProperty({ description: 'ID сущности (мастер или пост)' })
  @Column({ type: 'uuid' })
  entity_id: string;

  @ApiProperty({ description: 'Дата добавления в избранное' })
  @CreateDateColumn()
  created_at: Date;

  @ManyToOne(() => User, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: User;
}
