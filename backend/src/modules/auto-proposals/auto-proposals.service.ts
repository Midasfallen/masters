import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  Logger,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, LessThan, MoreThan } from 'typeorm';
import { Cron, CronExpression } from '@nestjs/schedule';
import {
  AutoProposal,
  ProposalStatus,
  ProposalInterval,
} from './entities/auto-proposal.entity';
import { AutoProposalSettings } from './entities/auto-proposal-settings.entity';
import { User } from '../users/entities/user.entity';
import { MasterProfile } from '../masters/entities/master-profile.entity';
import { Service } from '../services/entities/service.entity';
import { Booking, BookingStatus } from '../bookings/entities/booking.entity';
import { UpdateAutoProposalSettingsDto } from './dto/update-settings.dto';
import { ProposalResponseDto } from './dto/proposal-response.dto';
import { SettingsResponseDto } from './dto/settings-response.dto';
import { AcceptProposalDto } from './dto/accept-proposal.dto';
import { NotificationsService } from '../notifications/notifications.service';

@Injectable()
export class AutoProposalsService {
  private readonly logger = new Logger(AutoProposalsService.name);

  constructor(
    @InjectRepository(AutoProposal)
    private readonly autoProposalRepository: Repository<AutoProposal>,
    @InjectRepository(AutoProposalSettings)
    private readonly settingsRepository: Repository<AutoProposalSettings>,
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(MasterProfile)
    private readonly masterProfileRepository: Repository<MasterProfile>,
    @InjectRepository(Service)
    private readonly serviceRepository: Repository<Service>,
    @InjectRepository(Booking)
    private readonly bookingRepository: Repository<Booking>,
    private readonly notificationsService: NotificationsService,
  ) {}

  // ============ SETTINGS MANAGEMENT ============

  /**
   * Получить настройки автопредложений пользователя
   */
  async getSettings(userId: string): Promise<SettingsResponseDto> {
    const settings = await this.getSettingsEntity(userId);
    return this.mapSettingsToDto(settings);
  }

  private async getSettingsEntity(userId: string): Promise<AutoProposalSettings> {
    let settings = await this.settingsRepository.findOne({
      where: { user_id: userId },
    });

    // Создать дефолтные настройки если их нет
    if (!settings) {
      settings = this.settingsRepository.create({
        user_id: userId,
        is_enabled: true,
        interval_days: ProposalInterval.WEEKLY,
        max_distance_km: 10,
        min_rating: 4.0,
      });
      await this.settingsRepository.save(settings);
    }

    return settings;
  }

  /**
   * Обновить настройки автопредложений
   */
  async updateSettings(
    userId: string,
    updateDto: UpdateAutoProposalSettingsDto,
  ): Promise<SettingsResponseDto> {
    let settings = await this.settingsRepository.findOne({
      where: { user_id: userId },
    });

    if (!settings) {
      settings = this.settingsRepository.create({
        user_id: userId,
        ...updateDto,
      });
    } else {
      Object.assign(settings, updateDto);
    }

    // Если изменился интервал, пересчитать next_proposal_at
    if (updateDto.interval_days && settings.last_proposal_at) {
      const nextDate = new Date(settings.last_proposal_at);
      nextDate.setDate(nextDate.getDate() + updateDto.interval_days);
      settings.next_proposal_at = nextDate;
    }

    const saved: AutoProposalSettings = await this.settingsRepository.save(settings);
    return this.mapSettingsToDto(saved);
  }

  // ============ PROPOSAL MANAGEMENT ============

  /**
   * Получить активные предложения пользователя
   */
  async getUserProposals(
    userId: string,
    status?: ProposalStatus,
  ): Promise<ProposalResponseDto[]> {
    const queryBuilder = this.autoProposalRepository
      .createQueryBuilder('proposal')
      .leftJoinAndSelect('proposal.master_id', 'master')
      .leftJoinAndSelect('proposal.service_id', 'service')
      .where('proposal.user_id = :userId', { userId });

    if (status) {
      queryBuilder.andWhere('proposal.status = :status', { status });
    }

    queryBuilder.orderBy('proposal.created_at', 'DESC');

    const proposals = await queryBuilder.getMany();

    return Promise.all(
      proposals.map((p) => this.mapToResponseDto(p)),
    );
  }

  /**
   * Получить одно предложение
   */
  async getProposal(
    userId: string,
    proposalId: string,
  ): Promise<ProposalResponseDto> {
    const proposal = await this.autoProposalRepository.findOne({
      where: { id: proposalId },
    });

    if (!proposal) {
      throw new NotFoundException('Предложение не найдено');
    }

    if (proposal.user_id !== userId) {
      throw new ForbiddenException('Нет доступа к этому предложению');
    }

    return this.mapToResponseDto(proposal);
  }

  /**
   * Принять предложение (создать бронирование)
   */
  async acceptProposal(
    userId: string,
    proposalId: string,
    acceptDto: AcceptProposalDto,
  ): Promise<{ proposal: ProposalResponseDto; bookingId: string }> {
    const proposal = await this.autoProposalRepository.findOne({
      where: { id: proposalId },
    });

    if (!proposal) {
      throw new NotFoundException('Предложение не найдено');
    }

    if (proposal.user_id !== userId) {
      throw new ForbiddenException('Нет доступа к этому предложению');
    }

    if (proposal.status !== ProposalStatus.PENDING) {
      throw new BadRequestException(
        `Предложение уже ${proposal.status === ProposalStatus.ACCEPTED ? 'принято' : 'отклонено'}`,
      );
    }

    if (new Date() > proposal.expires_at) {
      proposal.status = ProposalStatus.EXPIRED;
      await this.autoProposalRepository.save(proposal);
      throw new BadRequestException('Предложение истекло');
    }

    // Создать бронирование
    const booking = this.bookingRepository.create({
      client_id: userId,
      master_id: proposal.master_id,
      service_id: proposal.service_id,
      start_time:
        acceptDto.preferred_datetime
          ? new Date(acceptDto.preferred_datetime)
          : proposal.proposed_datetime,
      status: BookingStatus.PENDING,
      comment: acceptDto.comment,
    });

    const savedBooking = await this.bookingRepository.save(booking);

    // Обновить предложение
    proposal.status = ProposalStatus.ACCEPTED;
    proposal.booking_id = savedBooking.id;
    await this.autoProposalRepository.save(proposal);

    this.logger.log(
      `Proposal ${proposalId} accepted by user ${userId}, created booking ${savedBooking.id}`,
    );

    // Отправить уведомление мастеру
    const user = await this.userRepository.findOne({ where: { id: userId } });
    const service = await this.serviceRepository.findOne({
      where: { id: proposal.service_id },
    });

    if (user && service) {
      await this.notificationsService.notifyBookingCreated(
        proposal.master_id,
        savedBooking.id,
        `${user.first_name} ${user.last_name}`,
        service.name,
        savedBooking.start_time,
      );
    }

    return {
      proposal: await this.mapToResponseDto(proposal),
      bookingId: savedBooking.id,
    };
  }

  /**
   * Отклонить предложение
   */
  async rejectProposal(
    userId: string,
    proposalId: string,
  ): Promise<ProposalResponseDto> {
    const proposal = await this.autoProposalRepository.findOne({
      where: { id: proposalId },
    });

    if (!proposal) {
      throw new NotFoundException('Предложение не найдено');
    }

    if (proposal.user_id !== userId) {
      throw new ForbiddenException('Нет доступа к этому предложению');
    }

    if (proposal.status !== ProposalStatus.PENDING) {
      throw new BadRequestException('Предложение уже обработано');
    }

    proposal.status = ProposalStatus.REJECTED;
    await this.autoProposalRepository.save(proposal);

    this.logger.log(`Proposal ${proposalId} rejected by user ${userId}`);

    return this.mapToResponseDto(proposal);
  }

  // ============ AUTO PROPOSAL GENERATION ============

  /**
   * Сгенерировать предложения для пользователя вручную
   */
  async generateProposalForUser(userId: string): Promise<ProposalResponseDto[]> {
    const settings = await this.getSettingsEntity(userId);

    if (!settings.is_enabled) {
      throw new BadRequestException('Автопредложения отключены');
    }

    const proposals = await this.createProposalsForUser(userId, settings);

    // Обновить last_proposal_at и next_proposal_at
    settings.last_proposal_at = new Date();
    const nextDate = new Date();
    nextDate.setDate(nextDate.getDate() + settings.interval_days);
    settings.next_proposal_at = nextDate;
    await this.settingsRepository.save(settings);

    return Promise.all(proposals.map((p) => this.mapToResponseDto(p)));
  }

  /**
   * CRON: Автоматическая генерация предложений каждый день в 10:00
   */
  @Cron(CronExpression.EVERY_DAY_AT_10AM)
  async handleDailyProposalGeneration(): Promise<void> {
    this.logger.log('🤖 Starting daily auto-proposal generation...');

    try {
      const now = new Date();

      // Найти всех пользователей, у которых пора генерировать предложения
      const usersForProposals = await this.settingsRepository.find({
        where: {
          is_enabled: true,
          next_proposal_at: LessThan(now),
        },
      });

      this.logger.log(
        `Found ${usersForProposals.length} users eligible for proposals`,
      );

      for (const settings of usersForProposals) {
        try {
          await this.createProposalsForUser(settings.user_id, settings);

          // Обновить даты
          settings.last_proposal_at = now;
          const nextDate = new Date(now);
          nextDate.setDate(nextDate.getDate() + settings.interval_days);
          settings.next_proposal_at = nextDate;
          await this.settingsRepository.save(settings);

          this.logger.log(
            `✅ Generated proposals for user ${settings.user_id}`,
          );
        } catch (error) {
          this.logger.error(
            `Failed to generate proposals for user ${settings.user_id}:`,
            error,
          );
        }
      }

      this.logger.log('✅ Daily auto-proposal generation completed');
    } catch (error) {
      this.logger.error('❌ Daily auto-proposal generation failed:', error);
    }
  }

  /**
   * CRON: Автоматическая очистка истекших предложений каждую ночь
   */
  @Cron(CronExpression.EVERY_DAY_AT_MIDNIGHT)
  async handleExpiredProposalsCleanup(): Promise<void> {
    this.logger.log('🗑️  Starting expired proposals cleanup...');

    try {
      const now = new Date();

      const result = await this.autoProposalRepository.update(
        {
          status: ProposalStatus.PENDING,
          expires_at: LessThan(now),
        },
        { status: ProposalStatus.EXPIRED },
      );

      this.logger.log(`✅ Marked ${result.affected} proposals as expired`);
    } catch (error) {
      this.logger.error('❌ Failed to cleanup expired proposals:', error);
    }
  }

  // ============ PRIVATE METHODS ============

  /**
   * Создать предложения для конкретного пользователя
   */
  private async createProposalsForUser(
    userId: string,
    settings: AutoProposalSettings,
  ): Promise<AutoProposal[]> {
    // Получить данные пользователя
    const user = await this.userRepository.findOne({ where: { id: userId } });
    if (!user) {
      throw new NotFoundException('Пользователь не найден');
    }

    // Определить предпочитаемые категории (из настроек)
    let categoryIds = settings.preferred_categories || [];

    // Найти подходящих мастеров
    const masters = await this.findSuitableMasters(
      userId,
      user,
      settings,
      categoryIds,
    );

    // Создать предложения (максимум 3)
    const proposals: AutoProposal[] = [];
    const topMasters = masters.slice(0, 3);

    for (const masterData of topMasters) {
      const proposal = this.autoProposalRepository.create({
        user_id: userId,
        master_id: masterData.master.id,
        service_id: masterData.service.id,
        category_id: masterData.service.category_id,
        status: ProposalStatus.PENDING,
        match_score: masterData.score,
        match_reasons: masterData.reasons,
        proposed_datetime: this.suggestDateTime(settings),
        expires_at: this.calculateExpirationDate(),
      });

      const saved = await this.autoProposalRepository.save(proposal);
      proposals.push(saved);

      // Отправить уведомление пользователю
      await this.notificationsService.notifySystem(
        userId,
        'Новое предложение мастера',
        `Мы подобрали для вас мастера ${masterData.master.user.first_name} ${masterData.master.user.last_name} (рейтинг ${masterData.master.rating}/5)`,
        `/proposals/${saved.id}`,
      );
    }

    return proposals;
  }

  /**
   * Найти подходящих мастеров на основе настроек и истории
   */
  private async findSuitableMasters(
    userId: string,
    user: User,
    settings: AutoProposalSettings,
    categoryIds: string[],
  ): Promise<
    Array<{
      master: MasterProfile & { user: User };
      service: Service;
      score: number;
      reasons: any;
    }>
  > {
    const queryBuilder = this.masterProfileRepository
      .createQueryBuilder('master')
      .leftJoinAndSelect('master.user', 'user')
      .leftJoinAndSelect('master.services', 'service')
      .where('master.is_active = :isActive', { isActive: true });

    // Фильтр по рейтингу
    if (settings.min_rating) {
      queryBuilder.andWhere('master.rating >= :minRating', {
        minRating: settings.min_rating,
      });
    }

    // Фильтр по категориям
    if (categoryIds.length > 0) {
      queryBuilder.andWhere('service.category_id IN (:...categoryIds)', {
        categoryIds,
      });
    }

    // Фильтр по цене
    if (settings.max_price) {
      queryBuilder.andWhere('service.price <= :maxPrice', {
        maxPrice: settings.max_price,
      });
    }

    // Геолокация (если у пользователя есть координаты)
    if (user.last_location_lat && user.last_location_lng && settings.max_distance_km) {
      queryBuilder.andWhere(
        `(6371 * acos(cos(radians(:userLat)) * cos(radians(master.location_lat)) * cos(radians(master.location_lng) - radians(:userLng)) + sin(radians(:userLat)) * sin(radians(master.location_lat)))) <= :maxDistance`,
        {
          userLat: user.last_location_lat,
          userLng: user.last_location_lng,
          maxDistance: settings.max_distance_km,
        },
      );
    }

    const masters = await queryBuilder.getMany();

    // Рассчитать оценку совместимости для каждого мастера
    const scoredMasters = masters
      .map((master) => {
        if (!master.services || master.services.length === 0) {
          return null;
        }

        const service = master.services[0]; // Берем первую услугу
        const scoreData = this.calculateMatchScore(master, service, user, settings);

        return {
          master,
          service,
          score: scoreData.total_score,
          reasons: scoreData.reasons,
        };
      })
      .filter(Boolean)
      .sort((a, b) => b!.score - a!.score);

    return scoredMasters as Array<{
      master: MasterProfile & { user: User };
      service: Service;
      score: number;
      reasons: any;
    }>;
  }

  /**
   * Рассчитать оценку совместимости мастера с клиентом
   */
  private calculateMatchScore(
    master: MasterProfile & { user: User },
    service: Service,
    user: User,
    settings: AutoProposalSettings,
  ): {
    total_score: number;
    reasons: {
      location_score?: number;
      rating_score?: number;
      price_score?: number;
      availability_score?: number;
      reasons: string[];
    };
  } {
    let totalScore = 0;
    const reasons: string[] = [];
    const scores: any = {};

    // 1. Оценка рейтинга (0-30 баллов)
    if (master.rating) {
      const ratingScore = (master.rating / 5) * 30;
      totalScore += ratingScore;
      scores.rating_score = Math.round(ratingScore);
      if (master.rating >= 4.5) {
        reasons.push(`Высокий рейтинг: ${master.rating}/5`);
      }
    }

    // 2. Оценка цены (0-20 баллов)
    if (settings.max_price && service.price) {
      const priceRatio = service.price / settings.max_price;
      const priceScore = Math.max(0, 20 * (1 - priceRatio));
      totalScore += priceScore;
      scores.price_score = Math.round(priceScore);
      if (priceRatio < 0.8) {
        reasons.push('Доступная цена');
      }
    }

    // 3. Оценка расстояния (0-30 баллов)
    if (
      user.last_location_lat &&
      user.last_location_lng &&
      master.location_lat &&
      master.location_lng
    ) {
      const distance = this.calculateDistance(
        user.last_location_lat,
        user.last_location_lng,
        master.location_lat,
        master.location_lng,
      );

      const locationScore = Math.max(
        0,
        30 * (1 - distance / settings.max_distance_km),
      );
      totalScore += locationScore;
      scores.location_score = Math.round(locationScore);
      if (distance < 3) {
        reasons.push(`Рядом с вами (${distance.toFixed(1)} км)`);
      }
    }

    // 4. Оценка доступности (0-20 баллов)
    // TODO: Реализовать когда будет calendar
    scores.availability_score = 10;
    totalScore += 10;

    return {
      total_score: Math.round(totalScore),
      reasons: { ...scores, reasons },
    };
  }

  /**
   * Рассчитать расстояние между двумя точками (формула Haversine)
   */
  private calculateDistance(
    lat1: number,
    lng1: number,
    lat2: number,
    lng2: number,
  ): number {
    const R = 6371; // Радиус Земли в км
    const dLat = this.toRadians(lat2 - lat1);
    const dLng = this.toRadians(lng2 - lng1);
    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(this.toRadians(lat1)) *
        Math.cos(this.toRadians(lat2)) *
        Math.sin(dLng / 2) *
        Math.sin(dLng / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
  }

  private toRadians(degrees: number): number {
    return degrees * (Math.PI / 180);
  }

  /**
   * Маппинг entity в SettingsResponseDto
   */
  private mapSettingsToDto(settings: AutoProposalSettings): SettingsResponseDto {
    return {
      id: settings.id,
      userId: settings.user_id,
      isEnabled: settings.is_enabled,
      intervalDays: settings.interval_days,
      preferredCategories: settings.preferred_categories || [],
      maxPrice: settings.max_price,
      maxDistanceKm: settings.max_distance_km,
      minRating: settings.min_rating,
      preferredTimeSlots: settings.preferred_time_slots
        ? settings.preferred_time_slots.map((slot) => ({
            dayOfWeek: slot.day_of_week,
            startHour: slot.start_hour,
            endHour: slot.end_hour,
          }))
        : null,
      lastProposalAt: settings.last_proposal_at,
      nextProposalAt: settings.next_proposal_at,
      createdAt: settings.created_at,
      updatedAt: settings.updated_at,
    };
  }

  /**
   * Предложить дату и время на основе предпочтений
   */
  private suggestDateTime(settings: AutoProposalSettings): Date {
    const now = new Date();
    const suggested = new Date(now);

    // Предложить на 3 дня вперед
    suggested.setDate(suggested.getDate() + 3);

    // Если есть предпочитаемые слоты, использовать их
    if (settings.preferred_time_slots && settings.preferred_time_slots.length > 0) {
      const firstSlot = settings.preferred_time_slots[0];
      suggested.setHours(firstSlot.start_hour, 0, 0, 0);
    } else {
      // Дефолт: 10:00
      suggested.setHours(10, 0, 0, 0);
    }

    return suggested;
  }

  /**
   * Рассчитать дату истечения предложения (7 дней)
   */
  private calculateExpirationDate(): Date {
    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + 7);
    return expiresAt;
  }

  /**
   * Маппинг entity в DTO
   */
  private async mapToResponseDto(
    proposal: AutoProposal,
  ): Promise<ProposalResponseDto> {
    // Загрузить дополнительную информацию о мастере и услуге
    const master = await this.masterProfileRepository.findOne({
      where: { id: proposal.master_id },
      relations: ['user'],
    });

    const service = await this.serviceRepository.findOne({
      where: { id: proposal.service_id },
    });

    return {
      id: proposal.id,
      userId: proposal.user_id,
      masterId: proposal.master_id,
      serviceId: proposal.service_id,
      categoryId: proposal.category_id,
      status: proposal.status,
      matchScore: proposal.match_score,
      matchReasons: proposal.match_reasons
        ? {
            locationScore: proposal.match_reasons.location_score,
            ratingScore: proposal.match_reasons.rating_score,
            priceScore: proposal.match_reasons.price_score,
            availabilityScore: proposal.match_reasons.availability_score,
            historyScore: proposal.match_reasons.history_score,
            reasons: proposal.match_reasons.reasons || [],
          }
        : { reasons: [] },
      proposedDatetime: proposal.proposed_datetime,
      expiresAt: proposal.expires_at,
      bookingId: proposal.booking_id,
      createdAt: proposal.created_at,
      master: master
        ? {
            id: master.id,
            firstName: master.user.first_name,
            lastName: master.user.last_name,
            avatarUrl: master.user.avatar_url,
            rating: master.rating,
          }
        : undefined,
      service: service
        ? {
            id: service.id,
            title: service.name,
            price: service.price,
            durationMinutes: service.duration_minutes,
          }
        : undefined,
    };
  }
}
