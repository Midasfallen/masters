// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingModelImpl _$$BookingModelImplFromJson(Map<String, dynamic> json) =>
    _$BookingModelImpl(
      id: json['id'] as String? ?? '',
      clientId: json['clientId'] as String? ?? '',
      masterId: json['masterId'] as String? ?? '',
      serviceId: json['serviceId'] as String? ?? '',
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      status: $enumDecodeNullable(_$BookingStatusEnumMap, json['status']) ??
          BookingStatus.pending,
      comment: json['comment'] as String?,
      cancellationReason: json['cancellationReason'] as String?,
      cancelledBy: json['cancelledBy'] as String?,
      clientReviewLeft: json['clientReviewLeft'] as bool? ?? false,
      masterReviewLeft: json['masterReviewLeft'] as bool? ?? false,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      locationAddress: json['locationAddress'] as String?,
      locationLat: (json['locationLat'] as num?)?.toDouble(),
      locationLng: (json['locationLng'] as num?)?.toDouble(),
      locationType: json['locationType'] as String? ?? 'salon',
      reminderSent: json['reminderSent'] as bool? ?? false,
      reminderSentAt: json['reminderSentAt'] == null
          ? null
          : DateTime.parse(json['reminderSentAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$BookingModelImplToJson(_$BookingModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'masterId': instance.masterId,
      'serviceId': instance.serviceId,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'durationMinutes': instance.durationMinutes,
      'price': instance.price,
      'status': _$BookingStatusEnumMap[instance.status]!,
      'comment': instance.comment,
      'cancellationReason': instance.cancellationReason,
      'cancelledBy': instance.cancelledBy,
      'clientReviewLeft': instance.clientReviewLeft,
      'masterReviewLeft': instance.masterReviewLeft,
      'completedAt': instance.completedAt?.toIso8601String(),
      'locationAddress': instance.locationAddress,
      'locationLat': instance.locationLat,
      'locationLng': instance.locationLng,
      'locationType': instance.locationType,
      'reminderSent': instance.reminderSent,
      'reminderSentAt': instance.reminderSentAt?.toIso8601String(),
      'metadata': instance.metadata,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
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
      reason: json['cancellation_reason'] as String,
    );

Map<String, dynamic> _$$CancelBookingRequestImplToJson(
        _$CancelBookingRequestImpl instance) =>
    <String, dynamic>{
      'cancellation_reason': instance.reason,
    };
