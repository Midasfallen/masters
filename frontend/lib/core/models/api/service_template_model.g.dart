// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_template_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceTemplateModelImpl _$$ServiceTemplateModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ServiceTemplateModelImpl(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String,
      slug: json['slug'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      iconUrl: json['iconUrl'] as String?,
      defaultDurationMinutes: (json['defaultDurationMinutes'] as num?)?.toInt(),
      defaultPriceRangeMin: (json['defaultPriceRangeMin'] as num?)?.toDouble(),
      defaultPriceRangeMax: (json['defaultPriceRangeMax'] as num?)?.toDouble(),
      isActive: json['isActive'] as bool? ?? true,
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ServiceTemplateModelImplToJson(
        _$ServiceTemplateModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categoryId': instance.categoryId,
      'slug': instance.slug,
      'name': instance.name,
      'description': instance.description,
      'iconUrl': instance.iconUrl,
      'defaultDurationMinutes': instance.defaultDurationMinutes,
      'defaultPriceRangeMin': instance.defaultPriceRangeMin,
      'defaultPriceRangeMax': instance.defaultPriceRangeMax,
      'isActive': instance.isActive,
      'displayOrder': instance.displayOrder,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
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
