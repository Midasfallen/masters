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
    required String clientId,
    required String masterId,
    required String serviceId,
    required DateTime startTime,
    required DateTime endTime,
    required int durationMinutes,
    required double price,
    required BookingStatus status,
    String? comment,
    String? cancellationReason,
    String? cancelledBy,
    required bool clientReviewLeft,
    required bool masterReviewLeft,
    DateTime? completedAt,
    String? locationAddress,
    double? locationLat,
    double? locationLng,
    required String locationType,
    required bool reminderSent,
    DateTime? reminderSentAt,
    Map<String, dynamic>? metadata,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _BookingModel;

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);
}

/// Create Booking Request
@freezed
class CreateBookingRequest with _$CreateBookingRequest {
  const factory CreateBookingRequest({
    required String masterId,
    required String serviceId,
    required DateTime startTime,
    String? comment,
    String? locationAddress,
    double? locationLat,
    double? locationLng,
    String? locationType,
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
