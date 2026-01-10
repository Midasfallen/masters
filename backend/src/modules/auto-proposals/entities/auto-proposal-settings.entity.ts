import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';
import { ProposalInterval } from './auto-proposal.entity';

@Entity('auto_proposal_settings')
@Index(['user_id'], { unique: true })
export class AutoProposalSettings {
  @ApiProperty()
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ApiProperty({ description: 'ID пользователя' })
  @Column({ type: 'uuid', unique: true })
  user_id: string;

  @ApiProperty({ description: 'Включены ли автоматические предложения', default: true })
  @Column({ type: 'boolean', default: true })
  is_enabled: boolean;

  @ApiProperty({
    description: 'Интервал предложений в днях (7, 14, 21, 30)',
    enum: ProposalInterval,
    default: ProposalInterval.WEEKLY,
  })
  @Column({
    type: 'integer',
    default: ProposalInterval.WEEKLY,
  })
  interval_days: ProposalInterval;

  @ApiProperty({ description: 'Предпочитаемые категории услуг', type: 'array' })
  @Column({ type: 'jsonb', nullable: true })
  preferred_categories: string[];

  @ApiProperty({ description: 'Максимальная цена услуги', required: false })
  @Column({ type: 'decimal', precision: 10, scale: 2, nullable: true })
  max_price: number;

  @ApiProperty({ description: 'Максимальное расстояние в км', default: 10 })
  @Column({ type: 'integer', default: 10 })
  max_distance_km: number;

  @ApiProperty({ description: 'Минимальный рейтинг мастера (0-5)', default: 4.0 })
  @Column({ type: 'decimal', precision: 2, scale: 1, default: 4.0 })
  min_rating: number;

  @ApiProperty({ description: 'Предпочитаемое время для предложений (часы)', type: 'array' })
  @Column({ type: 'jsonb', nullable: true })
  preferred_time_slots: {
    day_of_week: number; // 0 = Sunday, 6 = Saturday
    start_hour: number; // 0-23
    end_hour: number; // 0-23
  }[];

  @ApiProperty({ description: 'Дата последнего предложения' })
  @Column({ type: 'timestamp', nullable: true })
  last_proposal_at: Date;

  @ApiProperty({ description: 'Дата следующего предложения' })
  @Column({ type: 'timestamp', nullable: true })
  next_proposal_at: Date;

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
