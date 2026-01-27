import { Booking } from './entities/booking.entity';
import { User } from '../users/entities/user.entity';
import { Service } from '../services/entities/service.entity';
import {
  BookingResponseDto,
  BookingUserDto,
  BookingServiceDto,
} from './dto/booking-response.dto';

/**
 * Mapper для преобразования Booking Entity → BookingResponseDto
 */
export class BookingsMapper {
  /**
   * Преобразует User entity в BookingUserDto
   */
  static toUserDto(user: User): BookingUserDto {
    return {
      id: user.id,
      firstName: user.first_name,
      lastName: user.last_name,
      avatarUrl: user.avatar_url,
      phone: user.phone,
    };
  }

  /**
   * Преобразует Service entity в BookingServiceDto
   */
  static toServiceDto(service: Service): BookingServiceDto {
    return {
      id: service.id,
      name: service.name,
      price: Number(service.price),
      durationMinutes: service.duration_minutes,
    };
  }

  /**
   * Преобразует Booking entity в BookingResponseDto
   */
  static toDto(booking: Booking): BookingResponseDto {
    return {
      id: booking.id,
      clientId: booking.client_id,
      masterId: booking.master_id,
      serviceId: booking.service_id,
      startTime: booking.start_time,
      endTime: booking.end_time,
      durationMinutes: booking.duration_minutes,
      price: Number(booking.price),
      status: booking.status,
      comment: booking.comment,
      cancellationReason: booking.cancellation_reason,
      cancelledBy: booking.cancelled_by,
      clientReviewLeft: booking.client_review_left,
      masterReviewLeft: booking.master_review_left,
      completedAt: booking.completed_at,
      locationAddress: booking.location_address,
      locationLat: booking.location_lat ? Number(booking.location_lat) : null,
      locationLng: booking.location_lng ? Number(booking.location_lng) : null,
      locationType: booking.location_type,
      reminderSent: booking.reminder_sent,
      reminderSentAt: booking.reminder_sent_at,
      metadata: booking.metadata,
      createdAt: booking.created_at,
      updatedAt: booking.updated_at,
      // Опциональные связи
      client: booking.client ? this.toUserDto(booking.client) : undefined,
      master: booking.master ? this.toUserDto(booking.master) : undefined,
      service: booking.service ? this.toServiceDto(booking.service) : undefined,
    };
  }

  /**
   * Преобразует массив Booking entities в массив BookingResponseDto
   */
  static toDtoArray(bookings: Booking[]): BookingResponseDto[] {
    return bookings.map((booking) => this.toDto(booking));
  }
}
