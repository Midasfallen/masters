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
import { MasterProfile } from '../modules/masters/entities/master-profile.entity';
import { CreateServiceDto } from './dto/create-service.dto';
import { UpdateServiceDto } from './dto/update-service.dto';
import { FilterServicesDto } from './dto/filter-services.dto';
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
  ) {}

  /**
   * Создать новую услугу
   * Только для мастеров с завершенным профилем
   */
  async create(userId: string, createServiceDto: CreateServiceDto): Promise<Service> {
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

    // Создание услуги
    const service = this.serviceRepository.create({
      ...createServiceDto,
      master_id: masterProfile.id,
      currency: createServiceDto.currency || 'RUB',
      is_bookable_online: createServiceDto.is_bookable_online ?? true,
      is_mobile: createServiceDto.is_mobile ?? false,
      is_in_salon: createServiceDto.is_in_salon ?? true,
      tags: createServiceDto.tags || [],
      photo_urls: createServiceDto.photo_urls || [],
      display_order: createServiceDto.display_order || 0,
      is_active: true,
    });

    return this.serviceRepository.save(service);
  }

  /**
   * Получить все услуги текущего мастера
   */
  async getMyServices(
    userId: string,
    filterDto: FilterServicesDto,
  ): Promise<PaginatedResponseDto<Service>> {
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
  ): Promise<PaginatedResponseDto<Service>> {
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

    return new PaginatedResponseDto(
      services,
      total,
      filterDto.page,
      filterDto.limit,
    );
  }

  /**
   * Получить услугу по ID
   */
  async findById(serviceId: string): Promise<Service> {
    const service = await this.serviceRepository.findOne({
      where: { id: serviceId },
    });

    if (!service) {
      throw new NotFoundException('Услуга не найдена');
    }

    return service;
  }

  /**
   * Обновить услугу
   * Только владелец может обновлять свои услуги
   */
  async update(
    userId: string,
    serviceId: string,
    updateServiceDto: UpdateServiceDto,
  ): Promise<Service> {
    const service = await this.findById(serviceId);

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

    return this.serviceRepository.save(service);
  }

  /**
   * Удалить услугу
   * Только владелец может удалять свои услуги
   */
  async remove(userId: string, serviceId: string): Promise<void> {
    const service = await this.findById(serviceId);

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
  async deactivate(userId: string, serviceId: string): Promise<Service> {
    const service = await this.findById(serviceId);

    const masterProfile = await this.masterProfileRepository.findOne({
      where: { user_id: userId },
    });

    if (!masterProfile || service.master_id !== masterProfile.id) {
      throw new ForbiddenException('Вы можете деактивировать только свои услуги');
    }

    service.is_active = false;
    return this.serviceRepository.save(service);
  }

  /**
   * Активировать услугу
   */
  async activate(userId: string, serviceId: string): Promise<Service> {
    const service = await this.findById(serviceId);

    const masterProfile = await this.masterProfileRepository.findOne({
      where: { user_id: userId },
    });

    if (!masterProfile || service.master_id !== masterProfile.id) {
      throw new ForbiddenException('Вы можете активировать только свои услуги');
    }

    service.is_active = true;
    return this.serviceRepository.save(service);
  }
}
