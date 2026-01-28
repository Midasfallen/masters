import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:service_platform/core/models/api/user_model.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

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
    double? locationLat,
    double? locationLng,
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
    required String postId,
    required String authorId,
    UserModel? author,
    required String content,
    String? parentId,
    required int likesCount,
    required bool isLiked,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
}

/// Create Comment Request
@freezed
class CreateCommentRequest with _$CreateCommentRequest {
  const factory CreateCommentRequest({
    required String content,
    @JsonKey(name: 'parent_id') String? parentId,
  }) = _CreateCommentRequest;

  factory CreateCommentRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCommentRequestFromJson(json);
}
