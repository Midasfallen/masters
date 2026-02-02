// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_tree_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryTreeModelImpl _$$CategoryTreeModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CategoryTreeModelImpl(
      id: json['id'] as String,
      slug: json['slug'] as String,
      level: (json['level'] as num).toInt(),
      iconUrl: json['icon_url'] as String?,
      color: json['color'] as String?,
      displayOrder: (json['display_order'] as num).toInt(),
      mastersCount: (json['masters_count'] as num?)?.toInt() ?? 0,
      isPopular: json['is_popular'] as bool? ?? false,
      name: json['name'] as String,
      description: json['description'] as String?,
      children: (json['children'] as List<dynamic>?)
              ?.map(
                  (e) => CategoryTreeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CategoryTreeModelImplToJson(
        _$CategoryTreeModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'level': instance.level,
      'icon_url': instance.iconUrl,
      'color': instance.color,
      'display_order': instance.displayOrder,
      'masters_count': instance.mastersCount,
      'is_popular': instance.isPopular,
      'name': instance.name,
      'description': instance.description,
      'children': instance.children,
    };
