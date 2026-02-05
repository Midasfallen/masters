// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_aggregation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategorySearchResultModelImpl _$$CategorySearchResultModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CategorySearchResultModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      level: (json['level'] as num).toInt(),
      parentId: json['parent_id'] as String?,
      language: json['language'] as String,
      nameHighlighted: json['name_highlighted'] as String?,
    );

Map<String, dynamic> _$$CategorySearchResultModelImplToJson(
        _$CategorySearchResultModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'level': instance.level,
      'parent_id': instance.parentId,
      'language': instance.language,
      'name_highlighted': instance.nameHighlighted,
    };

_$MasterPreviewInSearchImpl _$$MasterPreviewInSearchImplFromJson(
        Map<String, dynamic> json) =>
    _$MasterPreviewInSearchImpl(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      averageRating: (json['average_rating'] as num).toDouble(),
    );

Map<String, dynamic> _$$MasterPreviewInSearchImplToJson(
        _$MasterPreviewInSearchImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'avatar_url': instance.avatarUrl,
      'average_rating': instance.averageRating,
    };

_$ServiceSearchResultModelImpl _$$ServiceSearchResultModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ServiceSearchResultModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      durationMinutes: (json['duration_minutes'] as num).toInt(),
      categoryName: json['category_name'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      photoUrls: (json['photo_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      master: MasterPreviewInSearch.fromJson(
          json['master'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ServiceSearchResultModelImplToJson(
        _$ServiceSearchResultModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'duration_minutes': instance.durationMinutes,
      'category_name': instance.categoryName,
      'tags': instance.tags,
      'photo_urls': instance.photoUrls,
      'master': instance.master,
    };

_$SearchAggregationModelImpl _$$SearchAggregationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SearchAggregationModelImpl(
      masters: (json['masters'] as List<dynamic>)
          .map((e) =>
              MasterSearchResultModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      services: (json['services'] as List<dynamic>)
          .map((e) =>
              ServiceSearchResultModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      categories: (json['categories'] as List<dynamic>)
          .map((e) =>
              CategorySearchResultModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      query: json['query'] as String,
      processingTimeMs: (json['processing_time_ms'] as num).toInt(),
    );

Map<String, dynamic> _$$SearchAggregationModelImplToJson(
        _$SearchAggregationModelImpl instance) =>
    <String, dynamic>{
      'masters': instance.masters,
      'services': instance.services,
      'categories': instance.categories,
      'query': instance.query,
      'processing_time_ms': instance.processingTimeMs,
    };
