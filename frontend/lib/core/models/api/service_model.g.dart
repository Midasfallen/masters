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
      if (instance.serviceTemplateId case final value?)
        'service_template_id': value,
      if (instance.subcategoryId case final value?) 'subcategory_id': value,
      if (instance.name case final value?) 'name': value,
      if (instance.description case final value?) 'description': value,
      'price': instance.price,
      if (instance.currency case final value?) 'currency': value,
      if (instance.priceFrom case final value?) 'price_from': value,
      if (instance.priceTo case final value?) 'price_to': value,
      'duration_minutes': instance.durationMinutes,
      if (instance.isBookableOnline case final value?)
        'is_bookable_online': value,
      if (instance.isMobile case final value?) 'is_mobile': value,
      if (instance.isInSalon case final value?) 'is_in_salon': value,
      if (instance.tags case final value?) 'tags': value,
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
      if (instance.name case final value?) 'name': value,
      if (instance.description case final value?) 'description': value,
      if (instance.price case final value?) 'price': value,
      if (instance.priceFrom case final value?) 'price_from': value,
      if (instance.priceTo case final value?) 'price_to': value,
      if (instance.durationMinutes case final value?) 'duration_minutes': value,
      if (instance.isBookableOnline case final value?)
        'is_bookable_online': value,
      if (instance.isMobile case final value?) 'is_mobile': value,
      if (instance.isInSalon case final value?) 'is_in_salon': value,
      if (instance.tags case final value?) 'tags': value,
      if (instance.isActive case final value?) 'is_active': value,
      if (instance.displayOrder case final value?) 'display_order': value,
    };
