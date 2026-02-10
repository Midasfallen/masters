import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ForbiddenException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';
import { MasterProfile } from './entities/master-profile.entity';
import { User } from '../users/entities/user.entity';
import { Category } from '../categories/entities/category.entity';
import { MasterProfileResponseDto } from './dto/master-profile-response.dto';
import { MastersMapper } from './masters.mapper';
import { Step1CategoriesDto } from './dto/step1-categories.dto';
import { Step2ProfileInfoDto } from './dto/step2-profile-info.dto';
import { Step3PortfolioDto } from './dto/step3-portfolio.dto';
import { Step4LocationDto } from './dto/step4-location.dto';
import { Step5ScheduleDto } from './dto/step5-schedule.dto';

@Injectable()
export class MastersService {
  constructor(
    @InjectRepository(MasterProfile)
    private readonly masterProfileRepository: Repository<MasterProfile>,
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(Category)
    private readonly categoryRepository: Repository<Category>,
  ) {}

  /**
   * Инициализация профиля мастера
   * Создает пустой профиль с setup_step = 0
   */
  async initializeProfile(userId: string): Promise<MasterProfileResponseDto> {
    // Проверка, нет ли уже профиля
    const existingProfile = await this.masterProfileRepository.findOne({
      where: { user_id: userId },
    });

    if (existingProfile) {
      throw new BadRequestException('Профиль мастера уже создан');
    }

    // Создание профиля
    const masterProfile = this.masterProfileRepository.create({
      user_id: userId,
      setup_step: 0,
      is_active: false, // Профиль неактивен до завершения настройки
      is_approved: false,
    });

    const saved = await this.masterProfileRepository.save(masterProfile);
    return MastersMapper.toDto(saved);
  }

  /**
   * ШАГ 1: Выбор категорий
   */
  async updateStep1(
    userId: string,
    step1Dto: Step1CategoriesDto,
  ): Promise<MasterProfileResponseDto> {
    const profile = await this.masterProfileRepository.findOne({
      where: { user_id: userId },
    });

    if (!profile) {
      throw new NotFoundException('Профиль мастера не найден. Начните создание профиля.');
    }

    // Проверка последовательности шагов
    if (profile.setup_step > 1) {
      throw new BadRequestException(
        'Шаг 1 уже завершен. Используйте обновление профиля.',
      );
    }

    // Валидация: category_ids только level 0 и level 1
    const allCategoryIds = [
      ...step1Dto.category_ids,
      ...(step1Dto.subcategory_ids || []),
    ];
    if (allCategoryIds.length > 0) {
      const categories = await this.categoryRepository.find({
        where: { id: In(allCategoryIds) },
        select: ['id', 'level'],
      });
      const foundIds = new Set(categories.map((c) => c.id));
      const invalidLevel = categories.find((c) => c.level !== 0 && c.level !== 1);
      if (invalidLevel) {
        throw new BadRequestException(
          'category_ids и subcategory_ids должны ссылаться только на категории level 0 или level 1.',
        );
      }
      const notFound = allCategoryIds.filter((id) => !foundIds.has(id));
      if (notFound.length > 0) {
        throw new BadRequestException(
          `Категории не найдены: ${notFound.join(', ')}`,
        );
      }
    }

    // Обновление данных
    profile.category_ids = step1Dto.category_ids;
    if (step1Dto.subcategory_ids) {
      profile.subcategory_ids = step1Dto.subcategory_ids;
    }
    profile.setup_step = 1;

    const saved = await this.masterProfileRepository.save(profile);
    return MastersMapper.toDto(saved);
  }

  /**
   * ШАГ 2: Базовая информация профиля
   */
  async updateStep2(
    userId: string,
    step2Dto: Step2ProfileInfoDto,
  ): Promise<MasterProfileResponseDto> {
    const profile = await this.masterProfileRepository.findOne({
      where: { user_id: userId },
    });

    if (!profile) {
      throw new NotFoundException('Профиль мастера не найден. Начните создание профиля.');
    }

    if (profile.setup_step < 1) {
      throw new BadRequestException('Сначала завершите шаг 1 (категории)');
    }

    // Обновление данных
    profile.bio = step2Dto.bio;
    if (step2Dto.years_of_experience) {
      profile.years_of_experience = step2Dto.years_of_experience;
    }
    if (step2Dto.languages) {
      profile.languages = step2Dto.languages;
    }
    if (step2Dto.is_mobile !== undefined) {
      profile.is_mobile = step2Dto.is_mobile;
    }
    if (step2Dto.has_location !== undefined) {
      profile.has_location = step2Dto.has_location;
    }
    if (step2Dto.is_online_only !== undefined) {
      profile.is_online_only = step2Dto.is_online_only;
    }

    profile.setup_step = Math.max(profile.setup_step, 2);

    const saved = await this.masterProfileRepository.save(profile);
    return MastersMapper.toDto(saved);
  }

  /**
   * ШАГ 3: Портфолио
   */
  async updateStep3(
    userId: string,
    step3Dto: Step3PortfolioDto,
  ): Promise<MasterProfileResponseDto> {
    const profile = await this.masterProfileRepository.findOne({
      where: { user_id: userId },
    });

    if (!profile) {
      throw new NotFoundException('Профиль мастера не найден. Начните создание профиля.');
    }

    if (profile.setup_step < 2) {
      throw new BadRequestException('Сначала завершите шаг 2 (информация о профиле)');
    }

    // Обновление портфолио
    if (step3Dto.portfolio_urls) {
      profile.portfolio_urls = step3Dto.portfolio_urls;
    }
    if (step3Dto.video_urls) {
      profile.video_urls = step3Dto.video_urls;
    }
    if (step3Dto.certificates) {
      profile.certificates = step3Dto.certificates;
    }

    profile.setup_step = Math.max(profile.setup_step, 3);

    const saved = await this.masterProfileRepository.save(profile);
    return MastersMapper.toDto(saved);
  }

  /**
   * ШАГ 4: География работы
   */
  async updateStep4(
    userId: string,
    step4Dto: Step4LocationDto,
  ): Promise<MasterProfileResponseDto> {
    const profile = await this.masterProfileRepository.findOne({
      where: { user_id: userId },
    });

    if (!profile) {
      throw new NotFoundException('Профиль мастера не найден. Начните создание профиля.');
    }

    if (profile.setup_step < 3) {
      throw new BadRequestException('Сначала завершите шаг 3 (портфолио)');
    }

    // Обновление локации
    if (step4Dto.location_lat !== undefined) {
      profile.location_lat = step4Dto.location_lat;
    }
    if (step4Dto.location_lng !== undefined) {
      profile.location_lng = step4Dto.location_lng;
    }
    if (step4Dto.location_address) {
      profile.location_address = step4Dto.location_address;
    }
    if (step4Dto.location_name) {
      profile.location_name = step4Dto.location_name;
    }
    if (step4Dto.service_radius_km !== undefined) {
      profile.service_radius_km = step4Dto.service_radius_km;
    }
    if (step4Dto.is_mobile !== undefined) {
      profile.is_mobile = step4Dto.is_mobile;
    }
    if (step4Dto.has_location !== undefined) {
      profile.has_location = step4Dto.has_location;
    }

    profile.setup_step = Math.max(profile.setup_step, 4);

    const saved = await this.masterProfileRepository.save(profile);
    return MastersMapper.toDto(saved);
  }

  /**
   * ШАГ 5: Расписание (ФИНАЛЬНЫЙ ШАГ)
   * После завершения:
   * - user.is_master = true
   * - user.master_profile_completed = true
   * - master_profile.setup_step = 5
   * - master_profile.is_active = true
   */
  async updateStep5(
    userId: string,
    step5Dto: Step5ScheduleDto,
  ): Promise<MasterProfileResponseDto> {
    const profile = await this.masterProfileRepository.findOne({
      where: { user_id: userId },
    });

    if (!profile) {
      throw new NotFoundException('Профиль мастера не найден. Начните создание профиля.');
    }

    if (profile.setup_step < 4) {
      throw new BadRequestException('Сначала завершите шаг 4 (локация)');
    }

    // Обновление расписания
    if (step5Dto.working_hours) {
      profile.working_hours = step5Dto.working_hours;
    }
    if (step5Dto.min_booking_hours !== undefined) {
      profile.min_booking_hours = step5Dto.min_booking_hours;
    }
    if (step5Dto.max_bookings_per_day !== undefined) {
      profile.max_bookings_per_day = step5Dto.max_bookings_per_day;
    }
    if (step5Dto.auto_confirm !== undefined) {
      profile.auto_confirm = step5Dto.auto_confirm;
    }
    if (step5Dto.social_links) {
      profile.social_links = step5Dto.social_links;
    }

    // ФИНАЛИЗАЦИЯ ПРОФИЛЯ
    profile.setup_step = 5;
    profile.is_active = true; // Профиль становится активным

    const saved = await this.masterProfileRepository.save(profile);

    // Обновление статуса пользователя
    const user = await this.userRepository.findOne({
      where: { id: userId },
    });

    if (user) {
      user.is_master = true;
      user.master_profile_completed = true;
      await this.userRepository.save(user);
    }

    return MastersMapper.toDto(saved);
  }

  /**
   * Получить профиль мастера текущего пользователя
   */
  async getMyProfile(userId: string): Promise<MasterProfileResponseDto> {
    const profile = await this.masterProfileRepository.findOne({
      where: { user_id: userId },
    });

    if (!profile) {
      throw new NotFoundException(
        'Профиль мастера не найден. Начните создание профиля.',
      );
    }

    return MastersMapper.toDto(profile);
  }

  /**
   * Получить профиль мастера по ID профиля или по user_id
   * Сначала пытается найти по id профиля, если не находит - ищет по user_id
   */
  async getProfileById(id: string): Promise<MasterProfileResponseDto> {
    // Сначала пытаемся найти по id профиля мастера
    let profile = await this.masterProfileRepository.findOne({
      where: { id: id },
      relations: ['user'], // Загружаем связанного пользователя
    });

    // Если не нашли, пробуем найти по user_id
    if (!profile) {
      profile = await this.masterProfileRepository.findOne({
        where: { user_id: id },
        relations: ['user'], // Загружаем связанного пользователя
      });
    }

    if (!profile) {
      // Проверяем, существует ли пользователь с таким ID
      const user = await this.userRepository.findOne({
        where: { id: id },
      });

      if (user) {
        throw new NotFoundException(
          `Профиль мастера не найден для пользователя ${user.first_name} ${user.last_name} (ID: ${id}). ` +
            `Пользователь существует, но профиль мастера не создан. Проверьте таблицу master_profiles.`,
        );
      } else {
        throw new NotFoundException(
          `Профиль мастера не найден для ID: ${id}. ` +
            `Проверьте, что пользователь существует и для него создан профиль мастера в таблице master_profiles.`,
        );
      }
    }

    return MastersMapper.toDto(profile);
  }

  /**
   * Обновить профиль мастера (только после завершения всех 5 шагов)
   */
  async updateProfile(
    userId: string,
    updateData: Partial<MasterProfile>,
  ): Promise<MasterProfileResponseDto> {
    const profile = await this.masterProfileRepository.findOne({
      where: { user_id: userId },
    });

    if (!profile) {
      throw new NotFoundException('Профиль мастера не найден. Начните создание профиля.');
    }

    if (profile.setup_step < 5) {
      throw new ForbiddenException(
        'Завершите все 5 шагов создания профиля перед обновлением',
      );
    }

    // Запрещаем изменение критических полей
    delete updateData.user_id;
    delete updateData.setup_step;
    delete updateData.id;

    Object.assign(profile, updateData);

    const saved = await this.masterProfileRepository.save(profile);
    return MastersMapper.toDto(saved);
  }

  /**
   * Удалить профиль мастера
   */
  async deleteProfile(userId: string): Promise<void> {
    const profile = await this.masterProfileRepository.findOne({
      where: { user_id: userId },
    });

    if (!profile) {
      throw new NotFoundException('Профиль мастера не найден. Начните создание профиля.');
    }

    await this.masterProfileRepository.remove(profile);

    // Обновляем статус пользователя
    const user = await this.userRepository.findOne({
      where: { id: userId },
    });

    if (user) {
      user.is_master = false;
      user.master_profile_completed = false;
      await this.userRepository.save(user);
    }
  }
}
