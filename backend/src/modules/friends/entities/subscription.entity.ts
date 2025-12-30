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

@Entity('subscriptions')
@Unique(['subscriber_id', 'target_id'])
@Index(['subscriber_id'])
@Index(['target_id'])
export class Subscription {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ApiProperty({ description: 'ID подписчика' })
  @Column({ type: 'uuid' })
  subscriber_id: string;

  @ApiProperty({ description: 'ID пользователя, на которого подписались' })
  @Column({ type: 'uuid' })
  target_id: string;

  @ApiProperty({ description: 'Включены уведомления о новых постах', default: true })
  @Column({ type: 'boolean', default: true })
  notifications_enabled: boolean;

  @ApiProperty()
  @CreateDateColumn()
  created_at: Date;

  // Relations
  @ManyToOne(() => User, { eager: false })
  @JoinColumn({ name: 'subscriber_id' })
  subscriber: User;

  @ManyToOne(() => User, { eager: false })
  @JoinColumn({ name: 'target_id' })
  target: User;
}
