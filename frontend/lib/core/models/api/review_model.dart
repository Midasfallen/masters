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
    required String bookingId,
    required String reviewerId,
    required String reviewedUserId,
    required ReviewerType reviewerType,
    required int rating,
    String? comment,
    required List<String> photoUrls,
    String? response,
    DateTime? responseAt,
    required bool isVisible,
    required int reportsCount,
    required bool isApproved,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ReviewModel;

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);
}

/// Create Review Request
@freezed
class CreateReviewRequest with _$CreateReviewRequest {
  const factory CreateReviewRequest({
    required String bookingId,
    required int rating,
    String? comment,
    List<String>? photoUrls,
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
