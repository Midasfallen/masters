// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceModelImpl _$$ServiceModelImplFromJson(Map<String, dynamic> json) =>
    _$ServiceModelImpl(
      id: json['id'] as String,
      masterId: json['masterId'] as String,
      categoryId: json['categoryId'] as String,
      serviceTemplateId: json['service_template_id'] as String?,
      subcategoryId: json['subcategoryId'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      priceFrom: (json['priceFrom'] as num?)?.toDouble(),
      priceTo: (json['priceTo'] as num?)?.toDouble(),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      isBookableOnline: json['isBookableOnline'] as bool,
      isMobile: json['isMobile'] as bool,
      isInSalon: json['isInSalon'] as bool,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      photoUrls:
          (json['photoUrls'] as List<dynamic>).map((e) => e as String).toList(),
      bookingsCount: (json['bookingsCount'] as num).toInt(),
      averageRating: (json['averageRating'] as num).toDouble(),
      isActive: json['isActive'] as bool,
      displayOrder: (json['displayOrder'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ServiceModelImplToJson(_$ServiceModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'masterId': instance.masterId,
      'categoryId': instance.categoryId,
      'service_template_id': instance.serviceTemplateId,
      'subcategoryId': instance.subcategoryId,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'currency': instance.currency,
      'priceFrom': instance.priceFrom,
      'priceTo': instance.priceTo,
      'durationMinutes': instance.durationMinutes,
      'isBookableOnline': instance.isBookableOnline,
      'isMobile': instance.isMobile,
      'isInSalon': instance.isInSalon,
      'tags': instance.tags,
      'photoUrls': instance.photoUrls,
      'bookingsCount': instance.bookingsCount,
      'averageRating': instance.averageRating,
      'isActive': instance.isActive,
      'displayOrder': instance.displayOrder,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$CreateServiceRequestImpl _$$CreateServiceRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateServiceRequestImpl(
      categoryId: json['category_id'] as String,
      serviceTemplateId: json['service_template_id'] as String?,
      subcategoryId: json['subcategory_id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String?,
      priceFrom: (json['price_from'] as num?)?.toDouble(),
      priceTo: (json['price_to'] as num?)?.toDouble(),
      durationMinutes: (json['duration_minutes'] as num).toInt(),
      isBookableOnline: json['is_bookable_online'] as bool?,
      isMobile: json['is_mobile'] as bool?,
      isInSalon: json['is_in_salon'] as bool?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$CreateServiceRequestImplToJson(
        _$CreateServiceRequestImpl instance) =>
    <String, dynamic>{
      'category_id': instance.categoryId,
      'service_template_id': instance.serviceTemplateId,
      'subcategory_id': instance.subcategoryId,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'currency': instance.currency,
      'price_from': instance.priceFrom,
      'price_to': instance.priceTo,
      'duration_minutes': instance.durationMinutes,
      'is_bookable_online': instance.isBookableOnline,
      'is_mobile': instance.isMobile,
      'is_in_salon': instance.isInSalon,
      'tags': instance.tags,
    };

_$UpdateServiceRequestImpl _$$UpdateServiceRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateServiceRequestImpl(
      name: json['name'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      priceFrom: (json['price_from'] as num?)?.toDouble(),
      priceTo: (json['price_to'] as num?)?.toDouble(),
      durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
      isBookableOnline: json['is_bookable_online'] as bool?,
      isMobile: json['is_mobile'] as bool?,
      isInSalon: json['is_in_salon'] as bool?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      isActive: json['is_active'] as bool?,
      displayOrder: (json['display_order'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$UpdateServiceRequestImplToJson(
        _$UpdateServiceRequestImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'price_from': instance.priceFrom,
      'price_to': instance.priceTo,
      'duration_minutes': instance.durationMinutes,
      'is_bookable_online': instance.isBookableOnline,
      'is_mobile': instance.isMobile,
      'is_in_salon': instance.isInSalon,
      'tags': instance.tags,
      'is_active': instance.isActive,
      'display_order': instance.displayOrder,
    };
