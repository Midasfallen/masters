// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      isRead: json['isRead'] as bool? ?? false,
      relatedId: json['relatedId'] as String?,
      relatedType: json['relatedType'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      actionUrl: json['actionUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$NotificationModelImplToJson(
        _$NotificationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': instance.type,
      'title': instance.title,
      'message': instance.message,
      'isRead': instance.isRead,
      'relatedId': instance.relatedId,
      'relatedType': instance.relatedType,
      'metadata': instance.metadata,
      'actionUrl': instance.actionUrl,
      'createdAt': instance.createdAt.toIso8601String(),
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
