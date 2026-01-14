// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      isRead: json['is_read'] as bool? ?? false,
      relatedId: json['related_id'] as String?,
      relatedType: json['related_type'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      actionUrl: json['action_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$NotificationModelImplToJson(
        _$NotificationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'type': instance.type,
      'title': instance.title,
      'message': instance.message,
      'is_read': instance.isRead,
      'related_id': instance.relatedId,
      'related_type': instance.relatedType,
      'metadata': instance.metadata,
      'action_url': instance.actionUrl,
      'created_at': instance.createdAt.toIso8601String(),
    };

_$MarkNotificationReadRequestImpl _$$MarkNotificationReadRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$MarkNotificationReadRequestImpl(
      notificationId: json['notification_id'] as String,
    );

Map<String, dynamic> _$$MarkNotificationReadRequestImplToJson(
        _$MarkNotificationReadRequestImpl instance) =>
    <String, dynamic>{
      'notification_id': instance.notificationId,
    };
