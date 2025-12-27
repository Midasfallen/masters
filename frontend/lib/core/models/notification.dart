import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

@freezed
class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    required String type, // 'like', 'comment', 'friend_request', 'message', 'booking', etc.
    required String title,
    required String body,
    required DateTime createdAt,
    required bool isRead,
    String? userId,
    String? userAvatar,
    String? actionUrl,
    Map<String, dynamic>? metadata,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) => _$AppNotificationFromJson(json);
}
