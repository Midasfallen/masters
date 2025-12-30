import { ApiProperty } from '@nestjs/swagger';
import { BookingStatus } from '../entities/booking.entity';

export class BookingResponseDto {
  @ApiProperty()
  id: string;

  @ApiProperty({ description: 'ID клиента' })
  client_id: string;

  @ApiProperty({ description: 'ID мастера' })
  master_id: string;

  @ApiProperty({ description: 'ID услуги' })
  service_id: string;

  @ApiProperty({ description: 'Время начала' })
  start_time: Date;

  @ApiProperty({ description: 'Время окончания' })
  end_time: Date;

  @ApiProperty({ description: 'Длительность в минутах' })
  duration_minutes: number;

  @ApiProperty({ description: 'Цена' })
  price: number;

  @ApiProperty({ enum: BookingStatus })
  status: BookingStatus;

  @ApiProperty({ description: 'Комментарий', required: false })
  comment?: string;

  @ApiProperty({ description: 'Причина отмены', required: false })
  cancellation_reason?: string;

  @ApiProperty({ description: 'Кто отменил', required: false })
  cancelled_by?: string;

  @ApiProperty({ description: 'Клиент оставил отзыв' })
  client_review_left: boolean;

  @ApiProperty({ description: 'Мастер оставил отзыв' })
  master_review_left: boolean;

  @ApiProperty({ description: 'Дата завершения', required: false })
  completed_at?: Date;

  @ApiProperty({ description: 'Адрес', required: false })
  location_address?: string;

  @ApiProperty({ description: 'Широта', required: false })
  location_lat?: number;

  @ApiProperty({ description: 'Долгота', required: false })
  location_lng?: number;

  @ApiProperty({ description: 'Тип локации' })
  location_type: string;

  @ApiProperty({ description: 'Напоминание отправлено' })
  reminder_sent: boolean;

  @ApiProperty({ description: 'Когда отправлено напоминание', required: false })
  reminder_sent_at?: Date;

  @ApiProperty({ description: 'Метаданные', required: false })
  metadata?: Record<string, any>;

  @ApiProperty()
  created_at: Date;

  @ApiProperty()
  updated_at: Date;

  // Опциональные связанные данные для расширенных ответов
  @ApiProperty({ required: false, description: 'Информация о клиенте' })
  client?: {
    id: string;
    first_name: string;
    last_name: string;
    avatar_url?: string;
    phone?: string;
  };

  @ApiProperty({ required: false, description: 'Информация о мастере' })
  master?: {
    id: string;
    first_name: string;
    last_name: string;
    avatar_url?: string;
    phone?: string;
  };

  @ApiProperty({ required: false, description: 'Информация об услуге' })
  service?: {
    id: string;
    name: string;
    price: number;
    duration_minutes: number;
  };
}
