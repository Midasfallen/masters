import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Service } from './entities/service.entity';
import { User } from '../users/entities/user.entity';
import { MasterProfile } from '../masters/entities/master-profile.entity';
import { Category } from '../categories/entities/category.entity';
import { ServiceTemplate } from '../service-templates/entities/service-template.entity';
import { CreateServiceDto } from './dto/create-service.dto';
import { UpdateServiceDto } from './dto/update-service.dto';
import { FilterServicesDto } from './dto/filter-services.dto';
import { ServiceResponseDto } from './dto/service-response.dto';
import { ServicesMapper } from './services.mapper';
import { PaginatedResponseDto } from '../../common/dto/pagination.dto';

@Injectable()
export class ServicesService {
  constructor(
    @InjectRepository(Service)
    private readonly serviceRepository: Repository<Service>,
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(MasterProfile)
    private readonly masterProfileRepository: Repository<MasterProfile>,
    @InjectRepository(Category)
    private readonly categoryRepository: Repository<Category>,
    @InjectRepository(ServiceTemplate)
    private readonly serviceTemplateRepository: Repository<ServiceTemplate>,
  ) {}

  /**
   * Создать новую услугу
   * Только для мастеров с завершенным профилем
   */
  async create(userId: string, createServiceDto: CreateServiceDto): Promise<ServiceResponseDto> {
    // Проверка, что пользователь - мастер с завершенным профилем
    const user = await this.userRepository.findOne({
      where: { id: userId },
    });

    if (!user || !user.is_master || !user.master_profile_completed) {
      throw new ForbiddenException(
        'Только мастера с завершенным профилем могут создавать услуги',
      );
    }

    // Получаем профиль мастера
    const masterProfile = await this.masterProfileRepository.findOne({
      where: { user_id: userId },
    });

    if (!masterProfile) {
      throw new NotFoundException('Профиль мастера не найден');
    }

    // Валидация категории: должна быть level 1
    const category = await this.categoryRepository.findOne({
      where: { id: createServiceDto.category_id },
    });

    if (!category) {
      throw new NotFoundException('Категория не найдена');
    }

    if (category.level !== 1) {
      throw new BadRequestException(
        'category_id должен ссылаться на категорию level 1',
      );
    }

    // Проверка, что категория услуги есть в профиле мастера
    if (!masterProfile.category_ids.includes(createServiceDto.category_id)) {
      throw new BadRequestException(
        'Категория услуги должна быть в списке категорий вашего профиля',
      );
    }

    // Валидация диапазона цен
    if (createServiceDto.price_from && createServiceDto.price_to) {
      if (createServiceDto.price_from > createServiceDto.price_to) {
        throw new BadRequestException(
          'Минимальная цена не может быть больше максимальной',
        );
      }
    }

    // Логика работы с шаблоном (если передан service_template_id)
    let template: ServiceTemplate | null = null;
    if (createServiceDto.service_template_id) {
      template = await this.serviceTemplateRepository.findOne({
        where: { id: createServiceDto.service_template_id },
      });

      if (!template) {
        throw new NotFoundException('Шаблон услуги не найден');
      }

      // ⚠️ ВАЖНО: Валидация консистентности
      // category_id должен совпадать с category_id шаблона
      if (createServiceDto.category_id !== template.category_id) {
        throw new BadRequestException(
          'category_id услуги должен совпадать с category_id шаблона',
        );
      }
    }

    // Логика переопределения (Override) с приоритетами:
    // 1. Если мастер заполнил поле сам — берем его значение
    // 2. Если поле пустое — подтягиваем из шаблона (fallback)
    const serviceName = createServiceDto.name || template?.name || '';
    const serviceDescription =
      createServiceDto.description || template?.description || null;
    const serviceDurationMinutes =
      createServiceDto.duration_minutes ||
      template?.default_duration_minutes ||
      60;

    // Создание услуги
    const service = this.serviceRepository.create({
      master_id: userId, // Use user_id, not masterProfile.id
      category_id: template?.category_id || createServiceDto.category_id, // Всегда берем из шаблона, если есть
      service_template_id: template?.id || null,
      subcategory_id: null, // Больше не используется
      name: serviceName,
      description: serviceDescription,
      price: createServiceDto.price,
      currency: createServiceDto.currency || 'RUB',
      price_from: createServiceDto.price_from || null,
      price_to: createServiceDto.price_to || null,
      duration_minutes: serviceDurationMinutes,
      is_bookable_online: createServiceDto.is_bookable_online ?? true,
      is_mobile: createServiceDto.is_mobile ?? false,
      is_in_salon: createServiceDto.is_in_salon ?? true,
      tags: createServiceDto.tags || [],
      photo_urls: createServiceDto.photo_urls || [],
      display_order: createServiceDto.display_order || 0,
      is_active: true,
    });

    const savedService = await this.serviceRepository.save(service);
    return ServicesMapper.toDto(savedService);
  }

  /**
   * Получить все услуги текущего мастера
   */
  async getMyServices(
    userId: string,
    filterDto: FilterServicesDto,
  ): Promise<PaginatedResponseDto<ServiceResponseDto>> {
    const masterProfile = await this.masterProfileRepository.findOne({
      where: { user_id: userId },
    });

    if (!masterProfile) {
      throw new NotFoundException('Профиль мастера не найден');
    }

    return this.getServicesByMaster(masterProfile.id, filterDto);
  }

  /**
   * Получить услуги конкретного мастера
   */
  async getServicesByMaster(
    masterId: string,
    filterDto: FilterServicesDto,
  ): Promise<PaginatedResponseDto<ServiceResponseDto>> {
    const query = this.serviceRepository.createQueryBuilder('service');

    query.where('service.master_id = :masterId', { masterId });

    // Фильтры
    if (filterDto.category_id) {
      query.andWhere('service.category_id = :categoryId', {
        categoryId: filterDto.category_id,
      });
    }

    if (filterDto.subcategory_id) {
      query.andWhere('service.subcategory_id = :subcategoryId', {
        subcategoryId: filterDto.subcategory_id,
      });
    }

    if (filterDto.is_active !== undefined) {
      query.andWhere('service.is_active = :isActive', {
        isActive: filterDto.is_active,
      });
    }

    if (filterDto.is_mobile !== undefined) {
      query.andWhere('service.is_mobile = :isMobile', {
        isMobile: filterDto.is_mobile,
      });
    }

    if (filterDto.is_in_salon !== undefined) {
      query.andWhere('service.is_in_salon = :isInSalon', {
        isInSalon: filterDto.is_in_salon,
      });
    }

    // Сортировка
    query.orderBy('service.display_order', 'ASC');
    query.addOrderBy('service.created_at', 'DESC');

    // Пагинация
    const total = await query.getCount();
    const services = await query
      .skip(filterDto.skip)
      .take(filterDto.take)
      .getMany();

    const serviceDtos = ServicesMapper.toDtoArray(services);

    return new PaginatedResponseDto(
      serviceDtos,
      total,
      filterDto.page,
      filterDto.limit,
    );
  }

  /**
   * Получить услугу по ID
   */
  async findById(serviceId: string): Promise<ServiceResponseDto> {
    const service = await this.serviceRepository.findOne({
      where: { id: serviceId },
    });

    if (!service) {
      throw new NotFoundException('Услуга не найдена');
    }

    return ServicesMapper.toDto(service);
  }

  /**
   * Обновить услугу
   * Только владелец может обновлять свои услуги
   */
  async update(
    userId: string,
    serviceId: string,
    updateServiceDto: UpdateServiceDto,
  ): Promise<ServiceResponseDto> {
    // Получаем entity для проверки
    const service = await this.serviceRepository.findOne({
      where: { id: serviceId },
    });

    if (!service) {
      throw new NotFoundException('Услуга не найдена');
    }

    // Проверка владельца
    const masterProfile = await this.masterProfileRepository.findOne({
      where: { user_id: userId },
    });

    if (!masterProfile || service.master_id !== masterProfile.id) {
      throw new ForbiddenException('Вы можете редактировать только свои услуги');
    }

    // Валидация категории (если меняется)
    if (
      updateServiceDto.category_id &&
      !masterProfile.category_ids.includes(updateServiceDto.category_id)
    ) {
      throw new BadRequestException(
        'Категория услуги должна быть в списке категорий вашего профиля',
      );
    }

    // Валидация диапазона цен
    if (updateServiceDto.price_from && updateServiceDto.price_to) {
      if (updateServiceDto.price_from > updateServiceDto.price_to) {
        throw new BadRequestException(
          'Минимальная цена не может быть больше максимальной',
        );
      }
    }

    // Обновление
    Object.assign(service, updateServiceDto);

    const updatedService = await this.serviceRepository.save(service);
    return ServicesMapper.toDto(updatedService);
  }

  /**
   * Удалить услугу
   * Только владелец может удалять свои услуги
   */
  async remove(userId: string, serviceId: string): Promise<void> {
    const service = await this.serviceRepository.findOne({
      where: { id: serviceId },
    });

    if (!service) {
      throw new NotFoundException('Услуга не найдена');
    }

    // Проверка владельца
    const masterProfile = await this.masterProfileRepository.findOne({
      where: { user_id: userId },
    });

    if (!masterProfile || service.master_id !== masterProfile.id) {
      throw new ForbiddenException('Вы можете удалять только свои услуги');
    }

    await this.serviceRepository.remove(service);
  }

  /**
   * Деактивировать услугу (мягкое удаление)
   */
  async deactivate(userId: string, serviceId: string): Promise<ServiceResponseDto> {
    const service = await this.serviceRepository.findOne({
      where: { id: serviceId },
    });

    if (!service) {
      throw new NotFoundException('Услуга не найдена');
    }

    const masterProfile = await this.masterProfileRepository.findOne({
      where: { user_id: userId },
    });

    if (!masterProfile || service.master_id !== masterProfile.id) {
      throw new ForbiddenException('Вы можете деактивировать только свои услуги');
    }

    service.is_active = false;
    const updatedService = await this.serviceRepository.save(service);
    return ServicesMapper.toDto(updatedService);
  }

  /**
   * Активировать услугу
   */
  async activate(userId: string, serviceId: string): Promise<ServiceResponseDto> {
    const service = await this.serviceRepository.findOne({
      where: { id: serviceId },
    });

    if (!service) {
      throw new NotFoundException('Услуга не найдена');
    }

    const masterProfile = await this.masterProfileRepository.findOne({
      where: { user_id: userId },
    });

    if (!masterProfile || service.master_id !== masterProfile.id) {
      throw new ForbiddenException('Вы можете активировать только свои услуги');
    }

    service.is_active = true;
    const updatedService = await this.serviceRepository.save(service);
    return ServicesMapper.toDto(updatedService);
  }

  /**
   * Получить услуги по категориям
   * Публичный метод для фильтрации услуг по категориям
   */
  async findByCategoryIds(categoryIds?: string[]): Promise<ServiceResponseDto[]> {
    const queryBuilder = this.serviceRepository
      .createQueryBuilder('service')
      .where('service.is_active = :isActive', { isActive: true });

    if (categoryIds && categoryIds.length > 0) {
      queryBuilder.andWhere('service.category_id IN (:...categoryIds)', {
        categoryIds,
      });
    }

    const services = await queryBuilder
      .orderBy('service.display_order', 'ASC')
      .addOrderBy('service.created_at', 'DESC')
      .getMany();

    return services.map((service) => ServicesMapper.toDto(service));
  }
}
