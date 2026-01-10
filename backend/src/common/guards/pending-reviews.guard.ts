import {
  Injectable,
  CanActivate,
  ExecutionContext,
  ForbiddenException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Booking, BookingStatus } from '../../modules/bookings/entities/booking.entity';

@Injectable()
export class PendingReviewsGuard implements CanActivate {
  constructor(
    @InjectRepository(Booking)
    private readonly bookingRepository: Repository<Booking>,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const userId = request.user?.id;

    if (!userId) {
      // Если нет userId, пропускаем проверку (JwtAuthGuard должен обработать это)
      return true;
    }

    // Проверяем, есть ли у клиента завершенные записи без отзывов
    const pendingReviews = await this.bookingRepository.find({
      where: {
        client_id: userId,
        status: BookingStatus.COMPLETED,
        client_review_left: false,
      },
      order: {
        completed_at: 'DESC',
      },
      take: 1,
    });

    if (pendingReviews.length > 0) {
      const booking = pendingReviews[0];
      throw new ForbiddenException({
        statusCode: 403,
        message: 'Вы должны оставить отзыв о предыдущей записи, прежде чем создать новую',
        error: 'PENDING_REVIEW_REQUIRED',
        data: {
          booking_id: booking.id,
          master_id: booking.master_id,
          service_id: booking.service_id,
          completed_at: booking.completed_at,
        },
      });
    }

    return true;
  }
}
