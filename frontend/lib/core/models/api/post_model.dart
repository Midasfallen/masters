import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:service_platform/core/models/api/user_model.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
class PostModel with _$PostModel {
  const factory PostModel({
    required String id,
    required String authorId,
    UserModel? author,
    required String content,
    required List<String> mediaUrls,
    required List<String> tags,
    required int likesCount,
    required int commentsCount,
    required int sharesCount,
    required bool isLiked,
    String? locationName,
    double? locationLat,
    double? locationLng,
    required bool isPinned,
    required bool isArchived,
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
    List<String>? mediaUrls,
    List<String>? tags,
    String? locationName,
    double? locationLat,
    double? locationLng,
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
    bool? isPinned,
    bool? isArchived,
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
    String? parentId,
  }) = _CreateCommentRequest;

  factory CreateCommentRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCommentRequestFromJson(json);
}
