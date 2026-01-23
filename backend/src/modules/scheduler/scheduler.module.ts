import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ReviewRemindersScheduler } from './review-reminders.scheduler';
import { ReviewReminder } from '../reviews/entities/review-reminder.entity';
import { Booking } from '../bookings/entities/booking.entity';
import { NotificationsModule } from '../notifications/notifications.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([ReviewReminder, Booking]),
    NotificationsModule,
  ],
  providers: [ReviewRemindersScheduler],
  exports: [ReviewRemindersScheduler],
})
export class SchedulerModule {}
