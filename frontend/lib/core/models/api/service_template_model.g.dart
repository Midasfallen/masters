// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_template_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceTemplateModelImpl _$$ServiceTemplateModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ServiceTemplateModelImpl(
      id: json['id'] as String,
      categoryId: json['category_id'] as String,
      slug: json['slug'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      iconUrl: json['icon_url'] as String?,
      defaultDurationMinutes:
          (json['default_duration_minutes'] as num?)?.toInt(),
      defaultPriceRangeMin:
          (json['default_price_range_min'] as num?)?.toDouble(),
      defaultPriceRangeMax:
          (json['default_price_range_max'] as num?)?.toDouble(),
      isActive: json['is_active'] as bool? ?? true,
      displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ServiceTemplateModelImplToJson(
        _$ServiceTemplateModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category_id': instance.categoryId,
      'slug': instance.slug,
      'name': instance.name,
      'description': instance.description,
      'icon_url': instance.iconUrl,
      'default_duration_minutes': instance.defaultDurationMinutes,
      'default_price_range_min': instance.defaultPriceRangeMin,
      'default_price_range_max': instance.defaultPriceRangeMax,
      'is_active': instance.isActive,
      'display_order': instance.displayOrder,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$ServiceTemplateListResponseImpl _$$ServiceTemplateListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ServiceTemplateListResponseImpl(
      data: (json['data'] as List<dynamic>)
          .map((e) => ServiceTemplateModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$$ServiceTemplateListResponseImplToJson(
        _$ServiceTemplateListResponseImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'total': instance.total,
    };
