import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Booking } from '../../bookings/entities/booking.entity';

@Entity('review_reminders')
@Index(['user_id'])
@Index(['booking_id'])
export class ReviewReminder {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'uuid' })
  user_id: string;

  @Column({ type: 'uuid' })
  booking_id: string;

  @Column({ type: 'integer', default: 0 })
  reminder_count: number;

  @Column({ type: 'boolean', default: false })
  grace_skip_allowed: boolean;

  @Column({ type: 'timestamp', nullable: true })
  last_reminded_at: Date;

  @CreateDateColumn()
  created_at: Date;

  @UpdateDateColumn()
  updated_at: Date;

  // Relations
  @ManyToOne(() => User)
  @JoinColumn({ name: 'user_id' })
  user: User;

  @ManyToOne(() => Booking)
  @JoinColumn({ name: 'booking_id' })
  booking: Booking;
}
