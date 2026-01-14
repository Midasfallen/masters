// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceModelImpl _$$ServiceModelImplFromJson(Map<String, dynamic> json) =>
    _$ServiceModelImpl(
      id: json['id'] as String,
      masterId: json['master_id'] as String,
      categoryId: json['category_id'] as String,
      subcategoryId: json['subcategory_id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      priceFrom: (json['price_from'] as num?)?.toDouble(),
      priceTo: (json['price_to'] as num?)?.toDouble(),
      durationMinutes: (json['duration_minutes'] as num).toInt(),
      isBookableOnline: json['is_bookable_online'] as bool,
      isMobile: json['is_mobile'] as bool,
      isInSalon: json['is_in_salon'] as bool,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      photoUrls: (json['photo_urls'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      bookingsCount: (json['bookings_count'] as num).toInt(),
      averageRating: (json['average_rating'] as num).toDouble(),
      isActive: json['is_active'] as bool,
      displayOrder: (json['display_order'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ServiceModelImplToJson(_$ServiceModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'master_id': instance.masterId,
      'category_id': instance.categoryId,
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
      'photo_urls': instance.photoUrls,
      'bookings_count': instance.bookingsCount,
      'average_rating': instance.averageRating,
      'is_active': instance.isActive,
      'display_order': instance.displayOrder,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$CreateServiceRequestImpl _$$CreateServiceRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateServiceRequestImpl(
      categoryId: json['category_id'] as String,
      subcategoryId: json['subcategory_id'] as String?,
      name: json['name'] as String,
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
