import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ForbiddenException,
  ConflictException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, MoreThanOrEqual, LessThanOrEqual, IsNull, Not, LessThan } from 'typeorm';
import { Review, ReviewerType } from './entities/review.entity';
import { ReviewReminder } from './entities/review-reminder.entity';
import { Booking, BookingStatus } from '../bookings/entities/booking.entity';
import { User } from '../users/entities/user.entity';
import { CreateReviewDto } from './dto/create-review.dto';
import { ResponseReviewDto } from './dto/response-review.dto';
import { ReviewResponseDto, ReviewStatsDto } from './dto/review-response.dto';
import { FilterReviewsDto } from './dto/filter-reviews.dto';
import { ReviewsMapper } from './reviews.mapper';

@Injectable()
export class ReviewsService {
  constructor(
    @InjectRepository(Review)
    private readonly reviewRepository: Repository<Review>,
    @InjectRepository(ReviewReminder)
    private readonly reviewReminderRepository: Repository<ReviewReminder>,
    @InjectRepository(Booking)
    private readonly bookingRepository: Repository<Booking>,
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
  ) {}

  /**
   * Создание отзыва после завершения бронирования
   */
  async create(
    userId: string,
    createReviewDto: CreateReviewDto,
  ): Promise<ReviewResponseDto> {
    // 1. Проверяем существование бронирования
    const booking = await this.bookingRepository.findOne({
      where: { id: createReviewDto.booking_id },
    });

    if (!booking) {
      throw new NotFoundException('Бронирование не найдено');
    }

    // 2. Проверяем, что бронирование завершено
    if (booking.status !== BookingStatus.COMPLETED) {
      throw new BadRequestException(
        'Можно оставлять отзывы только на завершенные бронирования',
      );
    }

    // 3. Определяем тип автора и получателя
    let reviewerType: ReviewerType;
    let reviewedUserId: string;

    if (booking.client_id === userId) {
      // Клиент оставляет отзыв мастеру
      reviewerType = ReviewerType.CLIENT;
      reviewedUserId = booking.master_id;

      // Проверяем, что клиент еще не оставил отзыв
      if (booking.client_review_left) {
        throw new ConflictException('Вы уже оставили отзыв на это бронирование');
      }
    } else if (booking.master_id === userId) {
      // Мастер оставляет отзыв клиенту
      reviewerType = ReviewerType.MASTER;
      reviewedUserId = booking.client_id;

      // Проверяем, что мастер еще не оставил отзыв
      if (booking.master_review_left) {
        throw new ConflictException('Вы уже оставили отзыв на это бронирование');
      }
    } else {
      throw new ForbiddenException('Вы не можете оставить отзыв на это бронирование');
    }

    // 4. Валидация фотографий (максимум 5)
    if (createReviewDto.photo_urls && createReviewDto.photo_urls.length > 5) {
      throw new BadRequestException('Максимум 5 фотографий к отзыву');
    }

    // 5. Создаем отзыв
    const review = this.reviewRepository.create({
      booking_id: booking.id,
      reviewer_id: userId,
      reviewed_user_id: reviewedUserId,
      reviewer_type: reviewerType,
      rating: createReviewDto.rating,
      comment: createReviewDto.comment,
      photo_urls: createReviewDto.photo_urls || [],
      is_visible: true,
      is_approved: true, // В будущем можно добавить модерацию
    });

    const savedReview = await this.reviewRepository.save(review);

    // 6. Обновляем статус отзыва в бронировании
    if (reviewerType === ReviewerType.CLIENT) {
      booking.client_review_left = true;
    } else {
      booking.master_review_left = true;
    }
    await this.bookingRepository.save(booking);

    // 7. Обновляем рейтинг пользователя
    await this.updateUserRating(reviewedUserId);

    // 8. Очищаем reminder если он был
    await this.clearReminder(userId, booking.id);

    return this.mapToResponseDto(savedReview);
  }

  /**
   * Ответ на отзыв (только для reviewed_user)
   */
  async respondToReview(
    userId: string,
    reviewId: string,
    responseDto: ResponseReviewDto,
  ): Promise<ReviewResponseDto> {
    const review = await this.reviewRepository.findOne({
      where: { id: reviewId },
    });

    if (!review) {
      throw new NotFoundException('Отзыв не найден');
    }

    // Проверяем, что пользователь - получатель отзыва
    if (review.reviewed_user_id !== userId) {
      throw new ForbiddenException('Вы можете отвечать только на отзывы о себе');
    }

    // Проверяем, что ответ еще не оставлен
    if (review.response) {
      throw new ConflictException('Ответ уже оставлен');
    }

    review.response = responseDto.response;
    review.response_at = new Date();

    const updatedReview = await this.reviewRepository.save(review);

    return this.mapToResponseDto(updatedReview);
  }

  /**
   * Получение отзывов с фильтрами
   */
  async findAll(
    filterDto: FilterReviewsDto,
  ): Promise<{ data: ReviewResponseDto[]; total: number; page: number; limit: number }> {
    const { page = 1, limit = 20, sort = 'created_at_desc' } = filterDto;

    const queryBuilder = this.reviewRepository
      .createQueryBuilder('review')
      .where('review.is_visible = :isVisible', { isVisible: true })
      .andWhere('review.is_approved = :isApproved', { isApproved: true });

    // Фильтр по получателю отзыва
    if (filterDto.reviewed_user_id) {
      queryBuilder.andWhere('review.reviewed_user_id = :reviewedUserId', {
        reviewedUserId: filterDto.reviewed_user_id,
      });
    }

    // Фильтр по автору
    if (filterDto.reviewer_id) {
      queryBuilder.andWhere('review.reviewer_id = :reviewerId', {
        reviewerId: filterDto.reviewer_id,
      });
    }

    // Фильтр по типу автора
    if (filterDto.reviewer_type) {
      queryBuilder.andWhere('review.reviewer_type = :reviewerType', {
        reviewerType: filterDto.reviewer_type,
      });
    }

    // Фильтр по рейтингу
    if (filterDto.min_rating) {
      queryBuilder.andWhere('review.rating >= :minRating', {
        minRating: filterDto.min_rating,
      });
    }

    if (filterDto.max_rating) {
      queryBuilder.andWhere('review.rating <= :maxRating', {
        maxRating: filterDto.max_rating,
      });
    }

    // Только с комментариями
    if (filterDto.with_comments === 'true') {
      queryBuilder.andWhere('review.comment IS NOT NULL');
      queryBuilder.andWhere("review.comment != ''");
    }

    // Только с фото
    if (filterDto.with_photos === 'true') {
      queryBuilder.andWhere('array_length(review.photo_urls, 1) > 0');
    }

    // Сортировка
    switch (sort) {
      case 'created_at_asc':
        queryBuilder.orderBy('review.created_at', 'ASC');
        break;
      case 'rating_desc':
        queryBuilder.orderBy('review.rating', 'DESC');
        break;
      case 'rating_asc':
        queryBuilder.orderBy('review.rating', 'ASC');
        break;
      case 'created_at_desc':
      default:
        queryBuilder.orderBy('review.created_at', 'DESC');
    }

    // Пагинация
    const skip = (page - 1) * limit;
    queryBuilder.skip(skip).take(limit);

    const [reviews, total] = await queryBuilder.getManyAndCount();

    return {
      data: reviews.map((review) => this.mapToResponseDto(review)),
      total,
      page,
      limit,
    };
  }

  /**
   * Получение одного отзыва по ID
   */
  async findOne(reviewId: string): Promise<ReviewResponseDto> {
    const review = await this.reviewRepository.findOne({
      where: { id: reviewId, is_visible: true, is_approved: true },
    });

    if (!review) {
      throw new NotFoundException('Отзыв не найден');
    }

    return this.mapToResponseDto(review);
  }

  /**
   * Получение статистики отзывов пользователя
   */
  async getUserStats(userId: string): Promise<ReviewStatsDto> {
    const reviews = await this.reviewRepository.find({
      where: {
        reviewed_user_id: userId,
        is_visible: true,
        is_approved: true,
      },
    });

    const totalReviews = reviews.length;

    if (totalReviews === 0) {
      return ReviewsMapper.toStatsDto({
        total_reviews: 0,
        average_rating: 0,
        rating_distribution: { 1: 0, 2: 0, 3: 0, 4: 0, 5: 0 },
        reviews_with_comments: 0,
        reviews_with_photos: 0,
      });
    }

    // Средний рейтинг
    const totalRating = reviews.reduce((sum, review) => sum + review.rating, 0);
    const averageRating = parseFloat((totalRating / totalReviews).toFixed(2));

    // Распределение оценок
    const ratingDistribution = { 1: 0, 2: 0, 3: 0, 4: 0, 5: 0 };
    reviews.forEach((review) => {
      ratingDistribution[review.rating]++;
    });

    // Отзывы с комментариями
    const reviewsWithComments = reviews.filter(
      (r) => r.comment && r.comment.length > 0,
    ).length;

    // Отзывы с фото
    const reviewsWithPhotos = reviews.filter(
      (r) => r.photo_urls && r.photo_urls.length > 0,
    ).length;

    return ReviewsMapper.toStatsDto({
      total_reviews: totalReviews,
      average_rating: averageRating,
      rating_distribution: ratingDistribution,
      reviews_with_comments: reviewsWithComments,
      reviews_with_photos: reviewsWithPhotos,
    });
  }

  /**
   * Удаление отзыва (soft delete - скрытие)
   */
  async remove(userId: string, reviewId: string): Promise<void> {
    const review = await this.reviewRepository.findOne({
      where: { id: reviewId },
    });

    if (!review) {
      throw new NotFoundException('Отзыв не найден');
    }

    // Удалить может только автор отзыва или админ (TODO: добавить проверку роли)
    if (review.reviewer_id !== userId) {
      throw new ForbiddenException('Вы можете удалять только свои отзывы');
    }

    // Soft delete
    review.is_visible = false;
    await this.reviewRepository.save(review);
  }

  /**
   * Жалоба на отзыв
   */
  async reportReview(reviewId: string): Promise<void> {
    const review = await this.reviewRepository.findOne({
      where: { id: reviewId },
    });

    if (!review) {
      throw new NotFoundException('Отзыв не найден');
    }

    review.reports_count++;

    // Автоматическое скрытие при большом количестве жалоб
    if (review.reports_count >= 5) {
      review.is_visible = false;
      review.is_approved = false;
    }

    await this.reviewRepository.save(review);
  }

  /**
   * Обновление среднего рейтинга пользователя
   */
  private async updateUserRating(userId: string): Promise<void> {
    const stats = await this.getUserStats(userId);

    const user = await this.userRepository.findOne({
      where: { id: userId },
    });

    if (user) {
      // user.average_rating = stats.averageRating; // TODO: Add average_rating field to User entity
      user.reviews_count = stats.totalReviews;
      await this.userRepository.save(user);
    }
  }

  /**
   * Получение неотзывленных бронирований для пользователя
   */
  async getUnreviewedBookings(userId: string) {
    // Получаем завершенные бронирования где пользователь был клиентом или мастером
    // и где он еще не оставил отзыв
    const bookings = await this.bookingRepository
      .createQueryBuilder('booking')
      .where('booking.status = :status', { status: BookingStatus.COMPLETED })
      .andWhere(
        '((booking.client_id = :userId AND booking.client_review_left = false) OR (booking.master_id = :userId AND booking.master_review_left = false))',
        { userId },
      )
      .leftJoinAndSelect('booking.service', 'service')
      .leftJoinAndSelect('booking.master', 'master')
      .leftJoinAndSelect('booking.client', 'client')
      .orderBy('booking.end_time', 'DESC')
      .getMany();

    // Получаем review reminders для этих бронирований
    const bookingIds = bookings.map((b) => b.id);
    const reminders = await this.reviewReminderRepository.find({
      where: { user_id: userId, booking_id: Not(IsNull()) },
    });

    const reminderMap = new Map(reminders.map((r) => [r.booking_id, r]));

    return bookings.map((booking) => {
      const reminder = reminderMap.get(booking.id);
      const isClient = booking.client_id === userId;

      return {
        id: booking.id,
        service_id: booking.service_id,
        service_name: booking.service?.name,
        master_id: booking.master_id,
        master_name: `${booking.master?.first_name} ${booking.master?.last_name}`,
        client_id: booking.client_id,
        client_name: `${booking.client?.first_name} ${booking.client?.last_name}`,
        start_time: booking.start_time,
        end_time: booking.end_time,
        total_price: booking.price,
        is_client: isClient,
        review_target: isClient ? booking.master_id : booking.client_id,
        review_target_name: isClient
          ? `${booking.master?.first_name} ${booking.master?.last_name}`
          : `${booking.client?.first_name} ${booking.client?.last_name}`,
        reminder_count: reminder?.reminder_count || 0,
        grace_skip_allowed: reminder?.grace_skip_allowed || false,
        last_reminded_at: reminder?.last_reminded_at,
      };
    });
  }

  /**
   * Создание или обновление reminder при пропуске
   */
  async handleSkipReview(userId: string, bookingId: string, isGracePeriod: boolean) {
    // Проверяем что бронирование существует и пользователь связан с ним
    const booking = await this.bookingRepository.findOne({
      where: { id: bookingId },
    });

    if (!booking) {
      throw new NotFoundException('Бронирование не найдено');
    }

    if (booking.client_id !== userId && booking.master_id !== userId) {
      throw new ForbiddenException('Вы не связаны с этим бронированием');
    }

    // Проверяем что отзыв еще не оставлен
    const hasLeftReview =
      (booking.client_id === userId && booking.client_review_left) ||
      (booking.master_id === userId && booking.master_review_left);

    if (hasLeftReview) {
      throw new BadRequestException('Отзыв уже оставлен');
    }

    // Находим или создаем reminder
    let reminder = await this.reviewReminderRepository.findOne({
      where: { user_id: userId, booking_id: bookingId },
    });

    if (!reminder) {
      reminder = this.reviewReminderRepository.create({
        user_id: userId,
        booking_id: bookingId,
        reminder_count: 0,
        grace_skip_allowed: false,
        last_reminded_at: null,
      });
    }

    // Если это grace period skip, разрешаем только один раз
    if (isGracePeriod) {
      if (reminder.grace_skip_allowed) {
        throw new BadRequestException('Вы уже использовали возможность пропустить без последствий');
      }
      reminder.grace_skip_allowed = true;
      reminder.last_reminded_at = new Date();
    } else {
      // Обычный пропуск - увеличиваем счетчик
      reminder.reminder_count += 1;
      reminder.last_reminded_at = new Date();
    }

    await this.reviewReminderRepository.save(reminder);

    return {
      reminder_count: reminder.reminder_count,
      grace_skip_allowed: reminder.grace_skip_allowed,
    };
  }

  /**
   * Очистка reminder после создания отзыва
   */
  private async clearReminder(userId: string, bookingId: string) {
    const reminder = await this.reviewReminderRepository.findOne({
      where: { user_id: userId, booking_id: bookingId },
    });

    if (reminder) {
      await this.reviewReminderRepository.remove(reminder);
    }
  }

  /**
   * Маппинг entity в DTO
   */
  private mapToResponseDto(review: Review): ReviewResponseDto {
    return ReviewsMapper.toDto(review);
  }
}
