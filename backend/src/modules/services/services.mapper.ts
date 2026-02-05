import { Service } from './entities/service.entity';
import { ServiceResponseDto } from './dto/service-response.dto';

/**
 * Mapper для преобразования Service Entity → ServiceResponseDto
 */
export class ServicesMapper {
  /**
   * Преобразует Service entity в ServiceResponseDto
   */
  static toDto(service: Service): ServiceResponseDto {
    return {
      id: service.id,
      masterId: service.master_id,
      categoryId: service.category_id,
      serviceTemplateId: service.service_template_id || null,
      subcategoryId: service.subcategory_id,
      name: service.name,
      description: service.description,
      price: Number(service.price),
      currency: service.currency,
      priceFrom: service.price_from ? Number(service.price_from) : null,
      priceTo: service.price_to ? Number(service.price_to) : null,
      durationMinutes: service.duration_minutes,
      isBookableOnline: service.is_bookable_online,
      isMobile: service.is_mobile,
      isInSalon: service.is_in_salon,
      tags: service.tags || [],
      photoUrls: service.photo_urls || [],
      bookingsCount: service.bookings_count,
      averageRating: Number(service.average_rating),
      isActive: service.is_active,
      displayOrder: service.display_order,
      createdAt: service.created_at,
      updatedAt: service.updated_at,
    };
  }

  /**
   * Преобразует массив Service entities в массив ServiceResponseDto
   */
  static toDtoArray(services: Service[]): ServiceResponseDto[] {
    return services.map((service) => this.toDto(service));
  }
}
