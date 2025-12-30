import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:service_platform/core/models/api/user_model.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
class PostModel with _$PostModel {
  const factory PostModel({
    required String id,
    @JsonKey(name: 'author_id') required String authorId,
    UserModel? author,
    required String content,
    @JsonKey(name: 'media_urls') required List<String> mediaUrls,
    required List<String> tags,
    @JsonKey(name: 'likes_count') required int likesCount,
    @JsonKey(name: 'comments_count') required int commentsCount,
    @JsonKey(name: 'shares_count') required int sharesCount,
    @JsonKey(name: 'is_liked') required bool isLiked,
    @JsonKey(name: 'location_name') String? locationName,
    @JsonKey(name: 'location_lat') double? locationLat,
    @JsonKey(name: 'location_lng') double? locationLng,
    @JsonKey(name: 'is_pinned') required bool isPinned,
    @JsonKey(name: 'is_archived') required bool isArchived,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
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
    @JsonKey(name: 'post_id') required String postId,
    @JsonKey(name: 'author_id') required String authorId,
    UserModel? author,
    required String content,
    @JsonKey(name: 'parent_id') String? parentId,
    @JsonKey(name: 'likes_count') required int likesCount,
    @JsonKey(name: 'is_liked') required bool isLiked,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
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
