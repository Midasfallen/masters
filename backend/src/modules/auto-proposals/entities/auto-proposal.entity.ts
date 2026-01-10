import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';

export enum ProposalStatus {
  PENDING = 'pending',
  ACCEPTED = 'accepted',
  REJECTED = 'rejected',
  EXPIRED = 'expired',
}

export enum ProposalInterval {
  WEEKLY = 7,
  BIWEEKLY = 14,
  TRIWEEKLY = 21,
  MONTHLY = 30,
}

@Entity('auto_proposals')
@Index(['user_id'])
@Index(['status'])
@Index(['created_at'])
@Index(['expires_at'])
export class AutoProposal {
  @ApiProperty()
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ApiProperty({ description: 'ID пользователя (клиента)' })
  @Column({ type: 'uuid' })
  user_id: string;

  @ApiProperty({ description: 'ID предложенного мастера' })
  @Column({ type: 'uuid' })
  master_id: string;

  @ApiProperty({ description: 'ID услуги' })
  @Column({ type: 'uuid' })
  service_id: string;

  @ApiProperty({ description: 'ID категории услуги' })
  @Column({ type: 'uuid' })
  category_id: string;

  @ApiProperty({ enum: ProposalStatus, description: 'Статус предложения' })
  @Column({
    type: 'enum',
    enum: ProposalStatus,
    default: ProposalStatus.PENDING,
  })
  status: ProposalStatus;

  @ApiProperty({ description: 'Оценка совместимости (0-100)' })
  @Column({ type: 'integer', default: 0 })
  match_score: number;

  @ApiProperty({ description: 'Причины рекомендации', type: 'object' })
  @Column({ type: 'jsonb', nullable: true })
  match_reasons: {
    location_score?: number; // 0-100
    rating_score?: number; // 0-100
    price_score?: number; // 0-100
    availability_score?: number; // 0-100
    history_score?: number; // 0-100 (based on past bookings)
    reasons: string[]; // Human-readable reasons
  };

  @ApiProperty({ description: 'Предложенная дата и время' })
  @Column({ type: 'timestamp', nullable: true })
  proposed_datetime: Date;

  @ApiProperty({ description: 'Дата истечения предложения' })
  @Column({ type: 'timestamp' })
  expires_at: Date;

  @ApiProperty({ description: 'ID созданного бронирования (если принято)' })
  @Column({ type: 'uuid', nullable: true })
  booking_id: string;

  @ApiProperty({ description: 'Метаданные', type: 'object' })
  @Column({ type: 'jsonb', nullable: true })
  metadata: Record<string, any>;

  @ApiProperty()
  @CreateDateColumn()
  created_at: Date;

  @ApiProperty()
  @UpdateDateColumn()
  updated_at: Date;
}
