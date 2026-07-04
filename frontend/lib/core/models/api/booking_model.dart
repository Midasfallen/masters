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
  /// Поля устойчивы к null (@Default / nullable), чтобы парсинг ответа не падал
  /// с "JSNull is not a subtype of String" при неполном объекте от бэка.
  const factory BookingModel({
    @Default('') String id,
    @Default('') String clientId,
    @Default('') String masterId,
    @Default('') String serviceId,
    DateTime? startTime,
    DateTime? endTime,
    @Default(0) int durationMinutes,
    @Default(0.0) double price,
    @Default(BookingStatus.pending) BookingStatus status,
    String? comment,
    String? cancellationReason,
    String? cancelledBy,
    @Default(false) bool clientReviewLeft,
    @Default(false) bool masterReviewLeft,
    DateTime? completedAt,
    String? locationAddress,
    double? locationLat,
    double? locationLng,
    @Default('salon') String locationType,
    @Default(false) bool reminderSent,
    DateTime? reminderSentAt,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _BookingModel;

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);
}

/// Create Booking Request
@freezed
class CreateBookingRequest with _$CreateBookingRequest {
  const factory CreateBookingRequest({
    // master_id НЕ отправляется: backend определяет мастера по service_id.
    // ValidationPipe с forbidNonWhitelisted отклонит лишнее поле (400).
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

/// Cancel Booking Request.
/// Backend ждёт поле `cancellation_reason` (мин. 5 символов).
@freezed
class CancelBookingRequest with _$CancelBookingRequest {
  const factory CancelBookingRequest({
    @JsonKey(name: 'cancellation_reason') required String reason,
  }) = _CancelBookingRequest;

  factory CancelBookingRequest.fromJson(Map<String, dynamic> json) =>
      _$CancelBookingRequestFromJson(json);
}
