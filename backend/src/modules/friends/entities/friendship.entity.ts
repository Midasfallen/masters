import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
  Index,
  Unique,
} from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';
import { User } from '../../users/entities/user.entity';

export enum FriendshipStatus {
  PENDING = 'pending',
  ACCEPTED = 'accepted',
  DECLINED = 'declined',
  BLOCKED = 'blocked',
}

@Entity('friendships')
@Unique(['requester_id', 'addressee_id'])
@Index(['requester_id', 'status'])
@Index(['addressee_id', 'status'])
export class Friendship {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ApiProperty({ description: 'ID пользователя, отправившего запрос' })
  @Column({ type: 'uuid' })
  requester_id: string;

  @ApiProperty({ description: 'ID пользователя, получившего запрос' })
  @Column({ type: 'uuid' })
  addressee_id: string;

  @ApiProperty({ enum: FriendshipStatus, example: FriendshipStatus.PENDING })
  @Column({
    type: 'enum',
    enum: FriendshipStatus,
    default: FriendshipStatus.PENDING,
  })
  status: FriendshipStatus;

  @ApiProperty()
  @CreateDateColumn()
  created_at: Date;

  @ApiProperty()
  @UpdateDateColumn()
  updated_at: Date;

  // Relations
  @ManyToOne(() => User, { eager: false })
  @JoinColumn({ name: 'requester_id' })
  requester: User;

  @ManyToOne(() => User, { eager: false })
  @JoinColumn({ name: 'addressee_id' })
  addressee: User;
}
