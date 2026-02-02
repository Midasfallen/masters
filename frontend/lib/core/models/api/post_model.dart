import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:service_platform/core/models/api/user_model.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

/// Converter for nullable double (handles API returning numbers as strings from DECIMAL)
class NullableStringToDoubleConverter implements JsonConverter<double?, dynamic> {
  const NullableStringToDoubleConverter();

  @override
  double? fromJson(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  @override
  dynamic toJson(double? value) => value;
}

enum MediaType {
  @JsonValue('photo')
  photo,
  @JsonValue('video')
  video,
}

@freezed
class PostMediaModel with _$PostMediaModel {
  const factory PostMediaModel({
    required String id,
    required MediaType type,
    required String url,
    String? thumbnailUrl,
    int? width,
    int? height,
    int? duration,
    @Default(0) int order,
  }) = _PostMediaModel;

  factory PostMediaModel.fromJson(Map<String, dynamic> json) =>
      _$PostMediaModelFromJson(json);
}

@freezed
class PostModel with _$PostModel {
  const factory PostModel({
    required String id,
    required String authorId,
    UserModel? author,
    String? content,
    @Default([]) List<PostMediaModel> media,
    @Default([]) List<String> tags,
    @Default(0) int likesCount,
    @Default(0) int commentsCount,
    @Default(0) int sharesCount,
    @Default(0) int repostsCount,
    @Default(false) bool isLiked,
    String? locationName,
    @NullableStringToDoubleConverter() @JsonKey(name: 'locationLat') double? locationLat,
    @NullableStringToDoubleConverter() @JsonKey(name: 'locationLng') double? locationLng,
    @JsonKey(name: 'custom_service_name') String? customServiceName,
    @Default(false) bool isPinned,
    @Default(false) bool isArchived,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}

/// Create Post Request
@freezed
class CreatePostRequest with _$CreatePostRequest {
  const factory CreatePostRequest({
    required String content,
    @JsonKey(name: 'media_urls') List<String>? mediaUrls,
    List<String>? tags,
    @JsonKey(name: 'location_name') String? locationName,
    @JsonKey(name: 'location_lat') double? locationLat,
    @JsonKey(name: 'location_lng') double? locationLng,
    @JsonKey(name: 'service_ids') List<String>? serviceIds,
    @JsonKey(name: 'custom_service_name') String? customServiceName,
  }) = _CreatePostRequest;

  factory CreatePostRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePostRequestFromJson(json);
}

/// Update Post Request
@freezed
class UpdatePostRequest with _$UpdatePostRequest {
  const factory UpdatePostRequest({
    String? content,
    List<String>? tags,
    @JsonKey(name: 'is_pinned') bool? isPinned,
    @JsonKey(name: 'is_archived') bool? isArchived,
  }) = _UpdatePostRequest;

  factory UpdatePostRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdatePostRequestFromJson(json);
}

/// Comment Model
@freezed
class CommentModel with _$CommentModel {
  const factory CommentModel({
    required String id,
    @JsonKey(name: 'postId') required String postId,
    @JsonKey(name: 'authorId') required String authorId,
    UserModel? author,
    required String content,
    @JsonKey(name: 'parentCommentId') String? parentId,
    @JsonKey(name: 'likesCount', defaultValue: 0) @Default(0) int likesCount,
    @JsonKey(name: 'isLiked', defaultValue: false) @Default(false) bool isLiked,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'updatedAt') required DateTime updatedAt,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    // Обрабатываем отсутствующие поля и маппинг
    final jsonWithDefaults = Map<String, dynamic>.from(json);
    
    // Маппим parentCommentId -> parentId (сервер возвращает parentCommentId)
    if (json.containsKey('parentCommentId') && !json.containsKey('parentId')) {
      jsonWithDefaults['parentId'] = json['parentCommentId'];
    }
    
    // Устанавливаем дефолтные значения для отсутствующих полей
    jsonWithDefaults['isLiked'] ??= false;
    jsonWithDefaults['likesCount'] ??= 0;
    
    return CommentModel(
      id: jsonWithDefaults['id'] as String,
      postId: jsonWithDefaults['postId'] as String,
      authorId: jsonWithDefaults['authorId'] as String,
      author: jsonWithDefaults['author'] == null
          ? null
          : UserModel.fromJson(jsonWithDefaults['author'] as Map<String, dynamic>),
      content: jsonWithDefaults['content'] as String,
      parentId: jsonWithDefaults['parentId'] as String?,
      likesCount: (jsonWithDefaults['likesCount'] as num?)?.toInt() ?? 0,
      isLiked: jsonWithDefaults['isLiked'] as bool? ?? false,
      createdAt: DateTime.parse(jsonWithDefaults['createdAt'] as String),
      updatedAt: DateTime.parse(jsonWithDefaults['updatedAt'] as String),
    );
  }
}

/// Create Comment Request
@freezed
class CreateCommentRequest with _$CreateCommentRequest {
  const factory CreateCommentRequest({
    required String content,
    @JsonKey(name: 'parent_id', includeIfNull: false) String? parentId,
  }) = _CreateCommentRequest;

  factory CreateCommentRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCommentRequestFromJson(json);
}
