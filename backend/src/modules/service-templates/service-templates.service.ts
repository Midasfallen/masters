import {
  Injectable,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';
import { ServiceTemplate } from './entities/service-template.entity';
import { ServiceTemplateTranslation } from './entities/service-template-translation.entity';
import { Category } from '../categories/entities/category.entity';
import { ServiceTemplateResponseDto, ServiceTemplateListResponseDto } from './dto/service-template-response.dto';
import { ServiceTemplatesMapper } from './service-templates.mapper';

@Injectable()
export class ServiceTemplatesService {
  constructor(
    @InjectRepository(ServiceTemplate)
    private readonly serviceTemplateRepository: Repository<ServiceTemplate>,
    @InjectRepository(ServiceTemplateTranslation)
    private readonly translationRepository: Repository<ServiceTemplateTranslation>,
    @InjectRepository(Category)
    private readonly categoryRepository: Repository<Category>,
  ) {}

  /**
   * Получить шаблоны услуг для категории level 1
   */
  async getByCategoryId(
    categoryId: string,
    language: string = 'ru',
  ): Promise<ServiceTemplateListResponseDto> {
    // Проверяем, что категория существует и является level 1
    const category = await this.categoryRepository.findOne({
      where: { id: categoryId },
    });

    if (!category) {
      throw new NotFoundException('Категория не найдена');
    }

    if (category.level !== 1) {
      throw new BadRequestException(
        'Шаблоны услуг доступны только для категорий level 1',
      );
    }

    // Получаем шаблоны для категории
    const templates = await this.serviceTemplateRepository.find({
      where: {
        category_id: categoryId,
        is_active: true,
      },
      order: {
        display_order: 'ASC',
        name: 'ASC',
      },
    });

    // Получаем переводы
    const translations = await this.translationRepository.find({
      where: {
        service_template_id: In(templates.map((t) => t.id)),
        language,
      },
    });

    const data = ServiceTemplatesMapper.toDtoArray(templates, translations);

    return {
      data,
      total: data.length,
    };
  }

  /**
   * Получить шаблон по slug
   */
  async getBySlug(
    slug: string,
    language: string = 'ru',
  ): Promise<ServiceTemplateResponseDto> {
    const template = await this.serviceTemplateRepository.findOne({
      where: { slug, is_active: true },
    });

    if (!template) {
      throw new NotFoundException('Шаблон услуги не найден');
    }

    const translation = await this.translationRepository.findOne({
      where: {
        service_template_id: template.id,
        language,
      },
    });

    return ServiceTemplatesMapper.toDto(template, translation);
  }

  /**
   * Получить шаблон по ID
   */
  async getById(
    id: string,
    language: string = 'ru',
  ): Promise<ServiceTemplateResponseDto> {
    const template = await this.serviceTemplateRepository.findOne({
      where: { id, is_active: true },
    });

    if (!template) {
      throw new NotFoundException('Шаблон услуги не найден');
    }

    const translation = await this.translationRepository.findOne({
      where: {
        service_template_id: template.id,
        language,
      },
    });

    return ServiceTemplatesMapper.toDto(template, translation);
  }

  /**
   * Получить доступные шаблоны для мастера (на основе его категорий)
   */
  async getAvailableForMaster(
    categoryIds: string[],
    language: string = 'ru',
  ): Promise<ServiceTemplateListResponseDto> {
    if (!categoryIds || categoryIds.length === 0) {
      return { data: [], total: 0 };
    }

    // Получаем шаблоны для категорий мастера
    const templates = await this.serviceTemplateRepository.find({
      where: {
        category_id: In(categoryIds),
        is_active: true,
      },
      order: {
        display_order: 'ASC',
        name: 'ASC',
      },
    });

    // Получаем переводы
    const translations = await this.translationRepository.find({
      where: {
        service_template_id: In(templates.map((t) => t.id)),
        language,
      },
    });

    const data = ServiceTemplatesMapper.toDtoArray(templates, translations);

    return {
      data,
      total: data.length,
    };
  }
}
