// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingModelImpl _$$BookingModelImplFromJson(Map<String, dynamic> json) =>
    _$BookingModelImpl(
      id: json['id'] as String,
      clientId: json['client_id'] as String,
      masterId: json['master_id'] as String,
      serviceId: json['service_id'] as String,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      durationMinutes: (json['duration_minutes'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      status: $enumDecode(_$BookingStatusEnumMap, json['status']),
      comment: json['comment'] as String?,
      cancellationReason: json['cancellation_reason'] as String?,
      cancelledBy: json['cancelled_by'] as String?,
      clientReviewLeft: json['client_review_left'] as bool,
      masterReviewLeft: json['master_review_left'] as bool,
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      locationAddress: json['location_address'] as String?,
      locationLat: (json['location_lat'] as num?)?.toDouble(),
      locationLng: (json['location_lng'] as num?)?.toDouble(),
      locationType: json['location_type'] as String,
      reminderSent: json['reminder_sent'] as bool,
      reminderSentAt: json['reminder_sent_at'] == null
          ? null
          : DateTime.parse(json['reminder_sent_at'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$BookingModelImplToJson(_$BookingModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'client_id': instance.clientId,
      'master_id': instance.masterId,
      'service_id': instance.serviceId,
      'start_time': instance.startTime.toIso8601String(),
      'end_time': instance.endTime.toIso8601String(),
      'duration_minutes': instance.durationMinutes,
      'price': instance.price,
      'status': _$BookingStatusEnumMap[instance.status]!,
      'comment': instance.comment,
      'cancellation_reason': instance.cancellationReason,
      'cancelled_by': instance.cancelledBy,
      'client_review_left': instance.clientReviewLeft,
      'master_review_left': instance.masterReviewLeft,
      'completed_at': instance.completedAt?.toIso8601String(),
      'location_address': instance.locationAddress,
      'location_lat': instance.locationLat,
      'location_lng': instance.locationLng,
      'location_type': instance.locationType,
      'reminder_sent': instance.reminderSent,
      'reminder_sent_at': instance.reminderSentAt?.toIso8601String(),
      'metadata': instance.metadata,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$BookingStatusEnumMap = {
  BookingStatus.pending: 'pending',
  BookingStatus.confirmed: 'confirmed',
  BookingStatus.inProgress: 'in_progress',
  BookingStatus.completed: 'completed',
  BookingStatus.cancelled: 'cancelled',
};

_$CreateBookingRequestImpl _$$CreateBookingRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateBookingRequestImpl(
      masterId: json['master_id'] as String,
      serviceId: json['service_id'] as String,
      startTime: DateTime.parse(json['start_time'] as String),
      comment: json['comment'] as String?,
      locationAddress: json['location_address'] as String?,
      locationLat: (json['location_lat'] as num?)?.toDouble(),
      locationLng: (json['location_lng'] as num?)?.toDouble(),
      locationType: json['location_type'] as String?,
    );

Map<String, dynamic> _$$CreateBookingRequestImplToJson(
        _$CreateBookingRequestImpl instance) =>
    <String, dynamic>{
      'master_id': instance.masterId,
      'service_id': instance.serviceId,
      'start_time': instance.startTime.toIso8601String(),
      'comment': instance.comment,
      'location_address': instance.locationAddress,
      'location_lat': instance.locationLat,
      'location_lng': instance.locationLng,
      'location_type': instance.locationType,
    };

_$UpdateBookingStatusRequestImpl _$$UpdateBookingStatusRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateBookingStatusRequestImpl(
      status: $enumDecode(_$BookingStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$$UpdateBookingStatusRequestImplToJson(
        _$UpdateBookingStatusRequestImpl instance) =>
    <String, dynamic>{
      'status': _$BookingStatusEnumMap[instance.status]!,
    };

_$CancelBookingRequestImpl _$$CancelBookingRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CancelBookingRequestImpl(
      reason: json['reason'] as String,
    );

Map<String, dynamic> _$$CancelBookingRequestImplToJson(
        _$CancelBookingRequestImpl instance) =>
    <String, dynamic>{
      'reason': instance.reason,
    };
