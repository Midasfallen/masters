// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FavoriteImpl _$$FavoriteImplFromJson(Map<String, dynamic> json) =>
    _$FavoriteImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      entityType: $enumDecode(_$FavoriteEntityTypeEnumMap, json['entity_type']),
      entityId: json['entity_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      entity: json['entity'],
    );

Map<String, dynamic> _$$FavoriteImplToJson(_$FavoriteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'entity_type': _$FavoriteEntityTypeEnumMap[instance.entityType]!,
      'entity_id': instance.entityId,
      'created_at': instance.createdAt.toIso8601String(),
      'entity': instance.entity,
    };

const _$FavoriteEntityTypeEnumMap = {
  FavoriteEntityType.master: 'master',
  FavoriteEntityType.post: 'post',
};

_$AddFavoriteRequestImpl _$$AddFavoriteRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$AddFavoriteRequestImpl(
      entityType: $enumDecode(_$FavoriteEntityTypeEnumMap, json['entity_type']),
      entityId: json['entity_id'] as String,
    );

Map<String, dynamic> _$$AddFavoriteRequestImplToJson(
        _$AddFavoriteRequestImpl instance) =>
    <String, dynamic>{
      'entity_type': _$FavoriteEntityTypeEnumMap[instance.entityType]!,
      'entity_id': instance.entityId,
    };
