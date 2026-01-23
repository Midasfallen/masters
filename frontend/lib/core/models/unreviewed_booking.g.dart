// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unreviewed_booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnreviewedBooking _$UnreviewedBookingFromJson(Map<String, dynamic> json) =>
    UnreviewedBooking(
      id: json['id'] as String,
      serviceId: json['service_id'] as String,
      serviceName: json['service_name'] as String?,
      masterId: json['master_id'] as String,
      masterName: json['master_name'] as String,
      clientId: json['client_id'] as String,
      clientName: json['client_name'] as String,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      totalPrice: (json['total_price'] as num).toDouble(),
      isClient: json['is_client'] as bool,
      reviewTarget: json['review_target'] as String,
      reviewTargetName: json['review_target_name'] as String,
      reminderCount: (json['reminder_count'] as num).toInt(),
      graceSkipAllowed: json['grace_skip_allowed'] as bool,
      lastRemindedAt: json['last_reminded_at'] == null
          ? null
          : DateTime.parse(json['last_reminded_at'] as String),
    );

Map<String, dynamic> _$UnreviewedBookingToJson(UnreviewedBooking instance) =>
    <String, dynamic>{
      'id': instance.id,
      'service_id': instance.serviceId,
      'service_name': instance.serviceName,
      'master_id': instance.masterId,
      'master_name': instance.masterName,
      'client_id': instance.clientId,
      'client_name': instance.clientName,
      'start_time': instance.startTime.toIso8601String(),
      'end_time': instance.endTime.toIso8601String(),
      'total_price': instance.totalPrice,
      'is_client': instance.isClient,
      'review_target': instance.reviewTarget,
      'review_target_name': instance.reviewTargetName,
      'reminder_count': instance.reminderCount,
      'grace_skip_allowed': instance.graceSkipAllowed,
      'last_reminded_at': instance.lastRemindedAt?.toIso8601String(),
    };
