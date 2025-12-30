import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_model.freezed.dart';
part 'booking_model.g.dart';

enum BookingStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

@freezed
class BookingModel with _$BookingModel {
  const factory BookingModel({
    required String id,
    @JsonKey(name: 'client_id') required String clientId,
    @JsonKey(name: 'master_id') required String masterId,
    @JsonKey(name: 'service_id') required String serviceId,
    @JsonKey(name: 'start_time') required DateTime startTime,
    @JsonKey(name: 'end_time') required DateTime endTime,
    @JsonKey(name: 'duration_minutes') required int durationMinutes,
    required double price,
    required BookingStatus status,
    String? comment,
    @JsonKey(name: 'cancellation_reason') String? cancellationReason,
    @JsonKey(name: 'cancelled_by') String? cancelledBy,
    @JsonKey(name: 'client_review_left') required bool clientReviewLeft,
    @JsonKey(name: 'master_review_left') required bool masterReviewLeft,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'location_address') String? locationAddress,
    @JsonKey(name: 'location_lat') double? locationLat,
    @JsonKey(name: 'location_lng') double? locationLng,
    @JsonKey(name: 'location_type') required String locationType,
    @JsonKey(name: 'reminder_sent') required bool reminderSent,
    @JsonKey(name: 'reminder_sent_at') DateTime? reminderSentAt,
    Map<String, dynamic>? metadata,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _BookingModel;

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);
}

/// Create Booking Request
@freezed
class CreateBookingRequest with _$CreateBookingRequest {
  const factory CreateBookingRequest({
    @JsonKey(name: 'master_id') required String masterId,
    @JsonKey(name: 'service_id') required String serviceId,
    @JsonKey(name: 'start_time') required DateTime startTime,
    String? comment,
    @JsonKey(name: 'location_address') String? locationAddress,
    @JsonKey(name: 'location_lat') double? locationLat,
    @JsonKey(name: 'location_lng') double? locationLng,
    @JsonKey(name: 'location_type') String? locationType,
  }) = _CreateBookingRequest;

  factory CreateBookingRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateBookingRequestFromJson(json);
}

/// Update Booking Status Request
@freezed
class UpdateBookingStatusRequest with _$UpdateBookingStatusRequest {
  const factory UpdateBookingStatusRequest({
    required BookingStatus status,
  }) = _UpdateBookingStatusRequest;

  factory UpdateBookingStatusRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateBookingStatusRequestFromJson(json);
}

/// Cancel Booking Request
@freezed
class CancelBookingRequest with _$CancelBookingRequest {
  const factory CancelBookingRequest({
    required String reason,
  }) = _CancelBookingRequest;

  factory CancelBookingRequest.fromJson(Map<String, dynamic> json) =>
      _$CancelBookingRequestFromJson(json);
}
