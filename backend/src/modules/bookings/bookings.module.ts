import { Module, forwardRef } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { BookingsService } from './bookings.service';
import { BookingsController } from './bookings.controller';
import { Booking } from './entities/booking.entity';
import { Service } from '../services/entities/service.entity';
import { User } from '../users/entities/user.entity';
import { MasterProfile } from '../masters/entities/master-profile.entity';
import { Review } from '../reviews/entities/review.entity';
import { ReviewReminder } from '../reviews/entities/review-reminder.entity';
import { PendingReviewsGuard } from '../../common/guards/pending-reviews.guard';
import { NotificationsModule } from '../notifications/notifications.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Booking,
      Service,
      User,
      MasterProfile,
      Review,
      ReviewReminder,
    ]),
    forwardRef(() => NotificationsModule),
  ],
  controllers: [BookingsController],
  providers: [BookingsService, PendingReviewsGuard],
  exports: [BookingsService],
})
export class BookingsModule {}
