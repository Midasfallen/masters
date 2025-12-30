import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';

export enum ReviewerType {
  CLIENT = 'client',
  MASTER = 'master',
}

@Entity('reviews')
@Index(['booking_id'], { unique: true })
@Index(['reviewer_id'])
@Index(['reviewed_user_id'])
@Index(['reviewer_type'])
@Index(['rating'])
export class Review {
  @ApiProperty()
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ApiProperty({ description: 'ID записи' })
  @Column({ type: 'uuid', unique: true })
  @Index()
  booking_id: string;

  @ApiProperty({ description: 'Кто оставил отзыв (user_id)' })
  @Column({ type: 'uuid' })
  @Index()
  reviewer_id: string;

  @ApiProperty({ description: 'Кому оставлен отзыв (user_id)' })
  @Column({ type: 'uuid' })
  @Index()
  reviewed_user_id: string;

  @ApiProperty({ enum: ReviewerType, description: 'Тип автора отзыва' })
  @Column({
    type: 'enum',
    enum: ReviewerType,
  })
  @Index()
  reviewer_type: ReviewerType;

  @ApiProperty({ description: 'Оценка (1-5)', example: 5, minimum: 1, maximum: 5 })
  @Column({ type: 'integer' })
  @Index()
  rating: number;

  @ApiProperty({ description: 'Текст отзыва (опционально)' })
  @Column({ type: 'text', nullable: true })
  comment: string;

  @ApiProperty({ description: 'Фото к отзыву', type: [String] })
  @Column({ type: 'text', array: true, default: '{}' })
  photo_urls: string[];

  @ApiProperty({ description: 'Ответ на отзыв (от reviewed_user)', required: false })
  @Column({ type: 'text', nullable: true })
  response: string;

  @ApiProperty({ description: 'Дата ответа', required: false })
  @Column({ type: 'timestamp', nullable: true })
  response_at: Date;

  @ApiProperty({ description: 'Отзыв видимый (не удален)', default: true })
  @Column({ type: 'boolean', default: true })
  is_visible: boolean;

  @ApiProperty({ description: 'Жалобы на отзыв', example: 0 })
  @Column({ type: 'integer', default: 0 })
  reports_count: number;

  @ApiProperty({ description: 'Модерация пройдена', default: true })
  @Column({ type: 'boolean', default: true })
  is_approved: boolean;

  @ApiProperty()
  @CreateDateColumn()
  created_at: Date;

  @ApiProperty()
  @UpdateDateColumn()
  updated_at: Date;

  // Relations will be added later:
  // @ManyToOne(() => Booking)
  // @JoinColumn({ name: 'booking_id' })
  // booking: Booking;
  //
  // @ManyToOne(() => User)
  // @JoinColumn({ name: 'reviewer_id' })
  // reviewer: User;
  //
  // @ManyToOne(() => User)
  // @JoinColumn({ name: 'reviewed_user_id' })
  // reviewedUser: User;
}
