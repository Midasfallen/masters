// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostModelImpl _$$PostModelImplFromJson(Map<String, dynamic> json) =>
    _$PostModelImpl(
      id: json['id'] as String,
      authorId: json['author_id'] as String,
      author: json['author'] == null
          ? null
          : UserModel.fromJson(json['author'] as Map<String, dynamic>),
      content: json['content'] as String,
      mediaUrls: (json['media_urls'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      likesCount: (json['likes_count'] as num).toInt(),
      commentsCount: (json['comments_count'] as num).toInt(),
      sharesCount: (json['shares_count'] as num).toInt(),
      isLiked: json['is_liked'] as bool,
      locationName: json['location_name'] as String?,
      locationLat: (json['location_lat'] as num?)?.toDouble(),
      locationLng: (json['location_lng'] as num?)?.toDouble(),
      isPinned: json['is_pinned'] as bool,
      isArchived: json['is_archived'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$PostModelImplToJson(_$PostModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author_id': instance.authorId,
      'author': instance.author,
      'content': instance.content,
      'media_urls': instance.mediaUrls,
      'tags': instance.tags,
      'likes_count': instance.likesCount,
      'comments_count': instance.commentsCount,
      'shares_count': instance.sharesCount,
      'is_liked': instance.isLiked,
      'location_name': instance.locationName,
      'location_lat': instance.locationLat,
      'location_lng': instance.locationLng,
      'is_pinned': instance.isPinned,
      'is_archived': instance.isArchived,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$CreatePostRequestImpl _$$CreatePostRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreatePostRequestImpl(
      content: json['content'] as String,
      mediaUrls: (json['media_urls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      locationName: json['location_name'] as String?,
      locationLat: (json['location_lat'] as num?)?.toDouble(),
      locationLng: (json['location_lng'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$CreatePostRequestImplToJson(
        _$CreatePostRequestImpl instance) =>
    <String, dynamic>{
      'content': instance.content,
      'media_urls': instance.mediaUrls,
      'tags': instance.tags,
      'location_name': instance.locationName,
      'location_lat': instance.locationLat,
      'location_lng': instance.locationLng,
    };

_$UpdatePostRequestImpl _$$UpdatePostRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdatePostRequestImpl(
      content: json['content'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      isPinned: json['is_pinned'] as bool?,
      isArchived: json['is_archived'] as bool?,
    );

Map<String, dynamic> _$$UpdatePostRequestImplToJson(
        _$UpdatePostRequestImpl instance) =>
    <String, dynamic>{
      'content': instance.content,
      'tags': instance.tags,
      'is_pinned': instance.isPinned,
      'is_archived': instance.isArchived,
    };

_$CommentModelImpl _$$CommentModelImplFromJson(Map<String, dynamic> json) =>
    _$CommentModelImpl(
      id: json['id'] as String,
      postId: json['post_id'] as String,
      authorId: json['author_id'] as String,
      author: json['author'] == null
          ? null
          : UserModel.fromJson(json['author'] as Map<String, dynamic>),
      content: json['content'] as String,
      parentId: json['parent_id'] as String?,
      likesCount: (json['likes_count'] as num).toInt(),
      isLiked: json['is_liked'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$CommentModelImplToJson(_$CommentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'post_id': instance.postId,
      'author_id': instance.authorId,
      'author': instance.author,
      'content': instance.content,
      'parent_id': instance.parentId,
      'likes_count': instance.likesCount,
      'is_liked': instance.isLiked,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$CreateCommentRequestImpl _$$CreateCommentRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateCommentRequestImpl(
      content: json['content'] as String,
      parentId: json['parent_id'] as String?,
    );

Map<String, dynamic> _$$CreateCommentRequestImplToJson(
        _$CreateCommentRequestImpl instance) =>
    <String, dynamic>{
      'content': instance.content,
      'parent_id': instance.parentId,
    };
