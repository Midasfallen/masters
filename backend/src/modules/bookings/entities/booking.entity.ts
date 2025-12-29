import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';

export enum BookingStatus {
  PENDING = 'pending',
  CONFIRMED = 'confirmed',
  IN_PROGRESS = 'in_progress',
  COMPLETED = 'completed',
  CANCELLED = 'cancelled',
}

@Entity('bookings')
@Index(['client_id'])
@Index(['master_id'])
@Index(['service_id'])
@Index(['status'])
@Index(['start_time'])
@Index(['client_id', 'client_review_left'])
export class Booking {
  @ApiProperty()
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ApiProperty({ description: 'ID клиента' })
  @Column({ type: 'uuid' })
  @Index()
  client_id: string;

  @ApiProperty({ description: 'ID мастера' })
  @Column({ type: 'uuid' })
  @Index()
  master_id: string;

  @ApiProperty({ description: 'ID услуги' })
  @Column({ type: 'uuid' })
  @Index()
  service_id: string;

  @ApiProperty({ example: '2025-01-06T14:00:00Z' })
  @Column({ type: 'timestamp' })
  @Index()
  start_time: Date;

  @ApiProperty({ example: '2025-01-06T15:30:00Z' })
  @Column({ type: 'timestamp' })
  end_time: Date;

  @ApiProperty({ description: 'Длительность в минутах', example: 90 })
  @Column({ type: 'integer' })
  duration_minutes: number;

  @ApiProperty({ description: 'Итоговая цена', example: 1500 })
  @Column({ type: 'decimal', precision: 10, scale: 2 })
  price: number;

  @ApiProperty({ enum: BookingStatus, default: BookingStatus.PENDING })
  @Column({
    type: 'enum',
    enum: BookingStatus,
    default: BookingStatus.PENDING,
  })
  @Index()
  status: BookingStatus;

  @ApiProperty({ description: 'Комментарий клиента', required: false })
  @Column({ type: 'text', nullable: true })
  comment: string;

  @ApiProperty({ description: 'Причина отмены', required: false })
  @Column({ type: 'text', nullable: true })
  cancellation_reason: string;

  @ApiProperty({ description: 'Кто отменил запись', required: false })
  @Column({ type: 'uuid', nullable: true })
  cancelled_by: string;

  @ApiProperty({ description: 'Клиент оставил отзыв', default: false })
  @Column({ type: 'boolean', default: false })
  client_review_left: boolean;

  @ApiProperty({ description: 'Мастер оставил отзыв', default: false })
  @Column({ type: 'boolean', default: false })
  master_review_left: boolean;

  @ApiProperty({ description: 'Дата завершения услуги', required: false })
  @Column({ type: 'timestamp', nullable: true })
  completed_at: Date;

  @ApiProperty({ description: 'Адрес (если выезд)', required: false })
  @Column({ type: 'text', nullable: true })
  location_address: string;

  @ApiProperty({ description: 'Широта', required: false })
  @Column({ type: 'decimal', precision: 10, scale: 8, nullable: true })
  location_lat: number;

  @ApiProperty({ description: 'Долгота', required: false })
  @Column({ type: 'decimal', precision: 11, scale: 8, nullable: true })
  location_lng: number;

  @ApiProperty({ description: 'Тип локации: salon, client_location, online', example: 'salon' })
  @Column({ type: 'varchar', length: 20, default: 'salon' })
  location_type: string;

  @ApiProperty({ description: 'Напоминание отправлено', default: false })
  @Column({ type: 'boolean', default: false })
  reminder_sent: boolean;

  @ApiProperty({ description: 'Когда отправлено напоминание', required: false })
  @Column({ type: 'timestamp', nullable: true })
  reminder_sent_at: Date;

  @ApiProperty({ description: 'Метаданные (дополнительная информация)' })
  @Column({ type: 'jsonb', nullable: true })
  metadata: Record<string, any>;

  @ApiProperty()
  @CreateDateColumn()
  created_at: Date;

  @ApiProperty()
  @UpdateDateColumn()
  updated_at: Date;

  // Relations will be added later:
  // @ManyToOne(() => User, user => user.clientBookings)
  // @JoinColumn({ name: 'client_id' })
  // client: User;
  //
  // @ManyToOne(() => User, user => user.masterBookings)
  // @JoinColumn({ name: 'master_id' })
  // master: User;
  //
  // @ManyToOne(() => Service)
  // @JoinColumn({ name: 'service_id' })
  // service: Service;
}
