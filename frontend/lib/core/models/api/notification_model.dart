import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

/// Notification Model для API
@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String type,
    required String title,
    required String message,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    @JsonKey(name: 'related_id') String? relatedId,
    @JsonKey(name: 'related_type') String? relatedType,
    Map<String, dynamic>? metadata,
    @JsonKey(name: 'action_url') String? actionUrl,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

/// Request для отметки уведомления как прочитанного
@freezed
class MarkNotificationReadRequest with _$MarkNotificationReadRequest {
  const factory MarkNotificationReadRequest({
    @JsonKey(name: 'notification_id') required String notificationId,
  }) = _MarkNotificationReadRequest;

  factory MarkNotificationReadRequest.fromJson(Map<String, dynamic> json) =>
      _$MarkNotificationReadRequestFromJson(json);

  Map<String, dynamic> toJson() => {
        'notification_id': notificationId,
      };
}
