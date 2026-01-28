// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostMediaModelImpl _$$PostMediaModelImplFromJson(Map<String, dynamic> json) =>
    _$PostMediaModelImpl(
      id: json['id'] as String,
      type: $enumDecode(_$MediaTypeEnumMap, json['type']),
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toInt(),
      order: (json['order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$PostMediaModelImplToJson(
        _$PostMediaModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$MediaTypeEnumMap[instance.type]!,
      'url': instance.url,
      'thumbnailUrl': instance.thumbnailUrl,
      'width': instance.width,
      'height': instance.height,
      'duration': instance.duration,
      'order': instance.order,
    };

const _$MediaTypeEnumMap = {
  MediaType.photo: 'photo',
  MediaType.video: 'video',
};

_$PostModelImpl _$$PostModelImplFromJson(Map<String, dynamic> json) =>
    _$PostModelImpl(
      id: json['id'] as String,
      authorId: json['authorId'] as String,
      author: json['author'] == null
          ? null
          : UserModel.fromJson(json['author'] as Map<String, dynamic>),
      content: json['content'] as String?,
      media: (json['media'] as List<dynamic>?)
              ?.map((e) => PostMediaModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
      commentsCount: (json['commentsCount'] as num?)?.toInt() ?? 0,
      sharesCount: (json['sharesCount'] as num?)?.toInt() ?? 0,
      repostsCount: (json['repostsCount'] as num?)?.toInt() ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      locationName: json['locationName'] as String?,
      locationLat: (json['locationLat'] as num?)?.toDouble(),
      locationLng: (json['locationLng'] as num?)?.toDouble(),
      isPinned: json['isPinned'] as bool? ?? false,
      isArchived: json['isArchived'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$PostModelImplToJson(_$PostModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'authorId': instance.authorId,
      'author': instance.author,
      'content': instance.content,
      'media': instance.media,
      'tags': instance.tags,
      'likesCount': instance.likesCount,
      'commentsCount': instance.commentsCount,
      'sharesCount': instance.sharesCount,
      'repostsCount': instance.repostsCount,
      'isLiked': instance.isLiked,
      'locationName': instance.locationName,
      'locationLat': instance.locationLat,
      'locationLng': instance.locationLng,
      'isPinned': instance.isPinned,
      'isArchived': instance.isArchived,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
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
      postId: json['postId'] as String,
      authorId: json['authorId'] as String,
      author: json['author'] == null
          ? null
          : UserModel.fromJson(json['author'] as Map<String, dynamic>),
      content: json['content'] as String,
      parentId: json['parentId'] as String?,
      likesCount: (json['likesCount'] as num).toInt(),
      isLiked: json['isLiked'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$CommentModelImplToJson(_$CommentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'authorId': instance.authorId,
      'author': instance.author,
      'content': instance.content,
      'parentId': instance.parentId,
      'likesCount': instance.likesCount,
      'isLiked': instance.isLiked,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
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
