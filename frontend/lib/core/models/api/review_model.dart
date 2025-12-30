import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_model.freezed.dart';
part 'review_model.g.dart';

enum ReviewerType {
  @JsonValue('client')
  client,
  @JsonValue('master')
  master,
}

@freezed
class ReviewModel with _$ReviewModel {
  const factory ReviewModel({
    required String id,
    @JsonKey(name: 'booking_id') required String bookingId,
    @JsonKey(name: 'reviewer_id') required String reviewerId,
    @JsonKey(name: 'reviewed_user_id') required String reviewedUserId,
    @JsonKey(name: 'reviewer_type') required ReviewerType reviewerType,
    required int rating,
    String? comment,
    @JsonKey(name: 'photo_urls') required List<String> photoUrls,
    String? response,
    @JsonKey(name: 'response_at') DateTime? responseAt,
    @JsonKey(name: 'is_visible') required bool isVisible,
    @JsonKey(name: 'reports_count') required int reportsCount,
    @JsonKey(name: 'is_approved') required bool isApproved,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ReviewModel;

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);
}

/// Create Review Request
@freezed
class CreateReviewRequest with _$CreateReviewRequest {
  const factory CreateReviewRequest({
    @JsonKey(name: 'booking_id') required String bookingId,
    required int rating,
    String? comment,
    @JsonKey(name: 'photo_urls') List<String>? photoUrls,
  }) = _CreateReviewRequest;

  factory CreateReviewRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateReviewRequestFromJson(json);
}

/// Update Review Request
@freezed
class UpdateReviewRequest with _$UpdateReviewRequest {
  const factory UpdateReviewRequest({
    int? rating,
    String? comment,
  }) = _UpdateReviewRequest;

  factory UpdateReviewRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateReviewRequestFromJson(json);
}

/// Review Response Request
@freezed
class ReviewResponseRequest with _$ReviewResponseRequest {
  const factory ReviewResponseRequest({
    required String response,
  }) = _ReviewResponseRequest;

  factory ReviewResponseRequest.fromJson(Map<String, dynamic> json) =>
      _$ReviewResponseRequestFromJson(json);
}
