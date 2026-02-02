// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryTranslationModelImpl _$$CategoryTranslationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CategoryTranslationModelImpl(
      id: json['id'] as String,
      language: json['language'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      keywords: (json['keywords'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CategoryTranslationModelImplToJson(
        _$CategoryTranslationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'language': instance.language,
      'name': instance.name,
      'description': instance.description,
      'keywords': instance.keywords,
    };

_$CategoryModelImpl _$$CategoryModelImplFromJson(Map<String, dynamic> json) =>
    _$CategoryModelImpl(
      id: json['id'] as String,
      parentId: json['parent_id'] as String?,
      slug: json['slug'] as String,
      level: (json['level'] as num).toInt(),
      iconUrl: json['icon_url'] as String?,
      imageUrl: json['image_url'] as String?,
      color: json['color'] as String?,
      displayOrder: (json['display_order'] as num).toInt(),
      mastersCount: (json['masters_count'] as num?)?.toInt() ?? 0,
      servicesCount: (json['services_count'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      isPopular: json['is_popular'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      translations: (json['translations'] as List<dynamic>?)
              ?.map((e) =>
                  CategoryTranslationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      children: (json['children'] as List<dynamic>?)
              ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      parent: json['parent'] == null
          ? null
          : CategoryModel.fromJson(json['parent'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CategoryModelImplToJson(_$CategoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parent_id': instance.parentId,
      'slug': instance.slug,
      'level': instance.level,
      'icon_url': instance.iconUrl,
      'image_url': instance.imageUrl,
      'color': instance.color,
      'display_order': instance.displayOrder,
      'masters_count': instance.mastersCount,
      'services_count': instance.servicesCount,
      'is_active': instance.isActive,
      'is_popular': instance.isPopular,
      'metadata': instance.metadata,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'translations': instance.translations,
      'children': instance.children,
      'parent': instance.parent,
    };
