import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ForbiddenException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Between, LessThanOrEqual, MoreThanOrEqual } from 'typeorm';
import { Booking, BookingStatus } from './entities/booking.entity';
import { Service } from '../services/entities/service.entity';
import { User } from '../users/entities/user.entity';
import { MasterProfile } from '../masters/entities/master-profile.entity';
import { CreateBookingDto } from './dto/create-booking.dto';
import { UpdateBookingStatusDto } from './dto/update-booking-status.dto';
import { CancelBookingDto } from './dto/cancel-booking.dto';
import { BookingResponseDto } from './dto/booking-response.dto';
import { FilterBookingsDto } from './dto/filter-bookings.dto';

@Injectable()
export class BookingsService {
  constructor(
    @InjectRepository(Booking)
    private readonly bookingRepository: Repository<Booking>,
    @InjectRepository(Service)
    private readonly serviceRepository: Repository<Service>,
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(MasterProfile)
    private readonly masterProfileRepository: Repository<MasterProfile>,
  ) {}

  /**
   * Создание бронирования клиентом
   */
  async create(
    clientId: string,
    createBookingDto: CreateBookingDto,
  ): Promise<BookingResponseDto> {
    // 1. Проверяем существование услуги
    const service = await this.serviceRepository.findOne({
      where: { id: createBookingDto.service_id },
    });

    if (!service) {
      throw new NotFoundException('Услуга не найдена');
    }

    if (!service.is_active) {
      throw new BadRequestException('Услуга недоступна для бронирования');
    }

    // 2. Получаем мастера
    const masterProfile = await this.masterProfileRepository.findOne({
      where: { id: service.master_profile_id },
    });

    if (!masterProfile || !masterProfile.is_active) {
      throw new BadRequestException('Мастер недоступен для бронирования');
    }

    // 3. Валидация времени
    const startTime = new Date(createBookingDto.start_time);
    const now = new Date();

    if (startTime < now) {
      throw new BadRequestException('Нельзя забронировать время в прошлом');
    }

    // Проверяем, что время не слишком далеко в будущем (например, не более 3 месяцев)
    const threeMonthsFromNow = new Date();
    threeMonthsFromNow.setMonth(threeMonthsFromNow.getMonth() + 3);
    if (startTime > threeMonthsFromNow) {
      throw new BadRequestException(
        'Нельзя забронировать время более чем на 3 месяца вперед',
      );
    }

    // 4. Рассчитываем end_time
    const endTime = new Date(startTime);
    endTime.setMinutes(endTime.getMinutes() + service.duration_minutes);

    // 5. Проверяем, нет ли пересечений с другими бронированиями мастера
    const overlappingBookings = await this.bookingRepository
      .createQueryBuilder('booking')
      .where('booking.master_id = :masterId', {
        masterId: masterProfile.user_id,
      })
      .andWhere('booking.status IN (:...statuses)', {
        statuses: [BookingStatus.PENDING, BookingStatus.CONFIRMED],
      })
      .andWhere(
        '(booking.start_time < :endTime AND booking.end_time > :startTime)',
        {
          startTime,
          endTime,
        },
      )
      .getCount();

    if (overlappingBookings > 0) {
      throw new BadRequestException(
        'Это время уже занято. Выберите другое время.',
      );
    }

    // 6. Создаем бронирование
    const booking = this.bookingRepository.create({
      client_id: clientId,
      master_id: masterProfile.user_id,
      service_id: service.id,
      start_time: startTime,
      end_time: endTime,
      duration_minutes: service.duration_minutes,
      price: service.price,
      status: BookingStatus.PENDING,
      comment: createBookingDto.comment,
      location_type: createBookingDto.location_type || 'salon',
      location_address: createBookingDto.location_address,
      location_lat: createBookingDto.location_lat,
      location_lng: createBookingDto.location_lng,
      metadata: createBookingDto.metadata,
    });

    const savedBooking = await this.bookingRepository.save(booking);

    return this.mapToResponseDto(savedBooking);
  }

  /**
   * Подтверждение бронирования мастером
   */
  async confirmBooking(
    masterId: string,
    bookingId: string,
  ): Promise<BookingResponseDto> {
    const booking = await this.findOneOrFail(bookingId);

    // Проверяем, что это мастер данного бронирования
    if (booking.master_id !== masterId) {
      throw new ForbiddenException('Вы не можете подтвердить это бронирование');
    }

    // Проверяем статус
    if (booking.status !== BookingStatus.PENDING) {
      throw new BadRequestException(
        'Можно подтвердить только ожидающее бронирование',
      );
    }

    booking.status = BookingStatus.CONFIRMED;
    const updatedBooking = await this.bookingRepository.save(booking);

    return this.mapToResponseDto(updatedBooking);
  }

  /**
   * Отклонение бронирования мастером
   */
  async rejectBooking(
    masterId: string,
    bookingId: string,
    reason: string,
  ): Promise<BookingResponseDto> {
    const booking = await this.findOneOrFail(bookingId);

    if (booking.master_id !== masterId) {
      throw new ForbiddenException('Вы не можете отклонить это бронирование');
    }

    if (booking.status !== BookingStatus.PENDING) {
      throw new BadRequestException(
        'Можно отклонить только ожидающее бронирование',
      );
    }

    booking.status = BookingStatus.CANCELLED;
    booking.cancellation_reason = reason;
    booking.cancelled_by = masterId;

    const updatedBooking = await this.bookingRepository.save(booking);

    return this.mapToResponseDto(updatedBooking);
  }

  /**
   * Отмена бронирования клиентом или мастером
   */
  async cancelBooking(
    userId: string,
    bookingId: string,
    cancelDto: CancelBookingDto,
  ): Promise<BookingResponseDto> {
    const booking = await this.findOneOrFail(bookingId);

    // Проверяем, что пользователь участник бронирования
    if (booking.client_id !== userId && booking.master_id !== userId) {
      throw new ForbiddenException('Вы не можете отменить это бронирование');
    }

    // Проверяем статус - можно отменить только PENDING или CONFIRMED
    if (
      ![BookingStatus.PENDING, BookingStatus.CONFIRMED].includes(
        booking.status,
      )
    ) {
      throw new BadRequestException(
        'Нельзя отменить завершенное или уже отмененное бронирование',
      );
    }

    // Проверяем, что отмена не происходит слишком поздно (менее чем за 1 час)
    const now = new Date();
    const oneHourBeforeStart = new Date(booking.start_time);
    oneHourBeforeStart.setHours(oneHourBeforeStart.getHours() - 1);

    if (now > oneHourBeforeStart && booking.client_id === userId) {
      throw new BadRequestException(
        'Нельзя отменить бронирование менее чем за 1 час до начала',
      );
    }

    booking.status = BookingStatus.CANCELLED;
    booking.cancellation_reason = cancelDto.cancellation_reason;
    booking.cancelled_by = userId;

    const updatedBooking = await this.bookingRepository.save(booking);

    return this.mapToResponseDto(updatedBooking);
  }

  /**
   * Начало работы (мастер отмечает, что клиент пришел)
   */
  async startBooking(
    masterId: string,
    bookingId: string,
  ): Promise<BookingResponseDto> {
    const booking = await this.findOneOrFail(bookingId);

    if (booking.master_id !== masterId) {
      throw new ForbiddenException('Вы не можете начать это бронирование');
    }

    if (booking.status !== BookingStatus.CONFIRMED) {
      throw new BadRequestException(
        'Можно начать только подтвержденное бронирование',
      );
    }

    booking.status = BookingStatus.IN_PROGRESS;
    const updatedBooking = await this.bookingRepository.save(booking);

    return this.mapToResponseDto(updatedBooking);
  }

  /**
   * Завершение бронирования
   */
  async completeBooking(
    masterId: string,
    bookingId: string,
  ): Promise<BookingResponseDto> {
    const booking = await this.findOneOrFail(bookingId);

    if (booking.master_id !== masterId) {
      throw new ForbiddenException('Вы не можете завершить это бронирование');
    }

    if (booking.status !== BookingStatus.IN_PROGRESS) {
      throw new BadRequestException(
        'Можно завершить только бронирование в процессе',
      );
    }

    booking.status = BookingStatus.COMPLETED;
    booking.completed_at = new Date();

    const updatedBooking = await this.bookingRepository.save(booking);

    return this.mapToResponseDto(updatedBooking);
  }

  /**
   * Получение бронирований с фильтрами
   */
  async findAll(
    userId: string,
    filterDto: FilterBookingsDto,
  ): Promise<{ data: BookingResponseDto[]; total: number; page: number; limit: number }> {
    const { page = 1, limit = 20, sort = 'start_time_desc' } = filterDto;

    const queryBuilder = this.bookingRepository.createQueryBuilder('booking');

    // Фильтруем по пользователю (либо клиент, либо мастер)
    queryBuilder.where(
      '(booking.client_id = :userId OR booking.master_id = :userId)',
      { userId },
    );

    // Фильтр по статусу
    if (filterDto.status) {
      queryBuilder.andWhere('booking.status = :status', {
        status: filterDto.status,
      });
    }

    // Фильтр по услуге
    if (filterDto.service_id) {
      queryBuilder.andWhere('booking.service_id = :serviceId', {
        serviceId: filterDto.service_id,
      });
    }

    // Фильтр по клиенту (для мастера)
    if (filterDto.client_id) {
      queryBuilder.andWhere('booking.client_id = :clientId', {
        clientId: filterDto.client_id,
      });
    }

    // Фильтр по мастеру (для клиента)
    if (filterDto.master_id) {
      queryBuilder.andWhere('booking.master_id = :masterId', {
        masterId: filterDto.master_id,
      });
    }

    // Фильтр по датам
    if (filterDto.start_date && filterDto.end_date) {
      queryBuilder.andWhere('booking.start_time BETWEEN :startDate AND :endDate', {
        startDate: new Date(filterDto.start_date),
        endDate: new Date(filterDto.end_date),
      });
    } else if (filterDto.start_date) {
      queryBuilder.andWhere('booking.start_time >= :startDate', {
        startDate: new Date(filterDto.start_date),
      });
    } else if (filterDto.end_date) {
      queryBuilder.andWhere('booking.start_time <= :endDate', {
        endDate: new Date(filterDto.end_date),
      });
    }

    // Фильтр по необходимости оставить отзыв
    if (filterDto.needs_review === 'true') {
      queryBuilder.andWhere('booking.status = :completedStatus', {
        completedStatus: BookingStatus.COMPLETED,
      });
      queryBuilder.andWhere('booking.client_review_left = :reviewLeft', {
        reviewLeft: false,
      });
      queryBuilder.andWhere('booking.client_id = :userId', { userId });
    }

    // Сортировка
    switch (sort) {
      case 'start_time_asc':
        queryBuilder.orderBy('booking.start_time', 'ASC');
        break;
      case 'start_time_desc':
        queryBuilder.orderBy('booking.start_time', 'DESC');
        break;
      case 'created_at_desc':
        queryBuilder.orderBy('booking.created_at', 'DESC');
        break;
      default:
        queryBuilder.orderBy('booking.start_time', 'DESC');
    }

    // Пагинация
    const skip = (page - 1) * limit;
    queryBuilder.skip(skip).take(limit);

    const [bookings, total] = await queryBuilder.getManyAndCount();

    return {
      data: bookings.map((booking) => this.mapToResponseDto(booking)),
      total,
      page,
      limit,
    };
  }

  /**
   * Получение одного бронирования по ID
   */
  async findOne(
    userId: string,
    bookingId: string,
  ): Promise<BookingResponseDto> {
    const booking = await this.findOneOrFail(bookingId);

    // Проверяем доступ
    if (booking.client_id !== userId && booking.master_id !== userId) {
      throw new ForbiddenException('У вас нет доступа к этому бронированию');
    }

    return this.mapToResponseDto(booking);
  }

  /**
   * Получение бронирований, требующих отзыва
   */
  async getBookingsNeedingReview(
    userId: string,
  ): Promise<BookingResponseDto[]> {
    const bookings = await this.bookingRepository.find({
      where: {
        client_id: userId,
        status: BookingStatus.COMPLETED,
        client_review_left: false,
      },
      order: {
        completed_at: 'DESC',
      },
      take: 10,
    });

    return bookings.map((booking) => this.mapToResponseDto(booking));
  }

  /**
   * Отметка, что клиент оставил отзыв
   */
  async markReviewLeft(bookingId: string, userId: string): Promise<void> {
    const booking = await this.findOneOrFail(bookingId);

    if (booking.client_id === userId) {
      booking.client_review_left = true;
    } else if (booking.master_id === userId) {
      booking.master_review_left = true;
    } else {
      throw new ForbiddenException('У вас нет доступа к этому бронированию');
    }

    await this.bookingRepository.save(booking);
  }

  /**
   * Вспомогательный метод для поиска бронирования
   */
  private async findOneOrFail(bookingId: string): Promise<Booking> {
    const booking = await this.bookingRepository.findOne({
      where: { id: bookingId },
    });

    if (!booking) {
      throw new NotFoundException('Бронирование не найдено');
    }

    return booking;
  }

  /**
   * Маппинг entity в DTO
   */
  private mapToResponseDto(booking: Booking): BookingResponseDto {
    return {
      id: booking.id,
      client_id: booking.client_id,
      master_id: booking.master_id,
      service_id: booking.service_id,
      start_time: booking.start_time,
      end_time: booking.end_time,
      duration_minutes: booking.duration_minutes,
      price: booking.price,
      status: booking.status,
      comment: booking.comment,
      cancellation_reason: booking.cancellation_reason,
      cancelled_by: booking.cancelled_by,
      client_review_left: booking.client_review_left,
      master_review_left: booking.master_review_left,
      completed_at: booking.completed_at,
      location_address: booking.location_address,
      location_lat: booking.location_lat,
      location_lng: booking.location_lng,
      location_type: booking.location_type,
      reminder_sent: booking.reminder_sent,
      reminder_sent_at: booking.reminder_sent_at,
      metadata: booking.metadata,
      created_at: booking.created_at,
      updated_at: booking.updated_at,
    };
  }
}
