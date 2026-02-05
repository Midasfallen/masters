import { ServiceTemplate } from './entities/service-template.entity';
import { ServiceTemplateTranslation } from './entities/service-template-translation.entity';
import { ServiceTemplateResponseDto } from './dto/service-template-response.dto';

/**
 * Mapper для преобразования ServiceTemplate Entity → ServiceTemplateResponseDto
 */
export class ServiceTemplatesMapper {
  /**
   * Преобразует ServiceTemplate entity в ServiceTemplateResponseDto
   */
  static toDto(
    template: ServiceTemplate,
    translation?: ServiceTemplateTranslation,
  ): ServiceTemplateResponseDto {
    return {
      id: template.id,
      categoryId: template.category_id,
      slug: template.slug,
      name: translation?.name || template.name,
      description: translation?.description || template.description,
      iconUrl: template.icon_url,
      defaultDurationMinutes: template.default_duration_minutes,
      defaultPriceRangeMin: template.default_price_range_min
        ? Number(template.default_price_range_min)
        : undefined,
      defaultPriceRangeMax: template.default_price_range_max
        ? Number(template.default_price_range_max)
        : undefined,
      isActive: template.is_active,
      displayOrder: template.display_order,
      createdAt: template.created_at,
      updatedAt: template.updated_at,
    };
  }

  /**
   * Преобразует массив шаблонов в DTO
   */
  static toDtoArray(
    templates: ServiceTemplate[],
    translations: ServiceTemplateTranslation[],
  ): ServiceTemplateResponseDto[] {
    return templates.map((template) => {
      const translation = translations.find(
        (t) => t.service_template_id === template.id,
      );
      return this.toDto(template, translation);
    });
  }
}
