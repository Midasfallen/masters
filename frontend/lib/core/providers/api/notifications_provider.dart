import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/models/api/notification_model.dart';
import 'package:service_platform/core/repositories/notification_repository.dart';

part 'notifications_provider.g.dart';

/// Notifications List Provider
@riverpod
Future<List<NotificationModel>> notificationsList(
  NotificationsListRef ref, {
  int page = 1,
  int limit = 50,
  bool? isRead,
  String? type,
}) async {
  final repository = ref.watch(notificationRepositoryProvider);
  return await repository.getNotifications(
    page: page,
    limit: limit,
    isRead: isRead,
    type: type,
  );
}

/// Notification by ID Provider
@riverpod
Future<NotificationModel> notificationById(
  NotificationByIdRef ref,
  String notificationId,
) async {
  final repository = ref.watch(notificationRepositoryProvider);
  return await repository.getNotificationById(notificationId);
}

/// Unread Count Provider
@riverpod
Future<int> notificationsUnreadCount(NotificationsUnreadCountRef ref) async {
  final repository = ref.watch(notificationRepositoryProvider);
  return await repository.getUnreadCount();
}

/// Notification Notifier for mutations
@riverpod
class NotificationNotifier extends _$NotificationNotifier {
  @override
  FutureOr<NotificationModel?> build() async {
    return null;
  }

  /// Mark notification as read
  Future<NotificationModel> markAsRead(String notificationId) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(notificationRepositoryProvider);
      final notification = await repository.markAsRead(notificationId);

      // Invalidate notifications list
      ref.invalidate(notificationsListProvider);
      ref.invalidate(notificationsUnreadCountProvider);

      return notification;
    }).then((asyncValue) {
      state = asyncValue;
      return asyncValue.requireValue;
    });
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    state = const AsyncValue.loading();

    await AsyncValue.guard(() async {
      final repository = ref.read(notificationRepositoryProvider);
      await repository.markAllAsRead();

      // Invalidate notifications list
      ref.invalidate(notificationsListProvider);
      ref.invalidate(notificationsUnreadCountProvider);
    }).then((asyncValue) {
      state = asyncValue as AsyncValue<NotificationModel?>;
    });
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    state = const AsyncValue.loading();

    await AsyncValue.guard(() async {
      final repository = ref.read(notificationRepositoryProvider);
      await repository.deleteNotification(notificationId);

      // Инвалидировать список уведомлений и счетчик
      ref.invalidate(notificationsListProvider);
      ref.invalidate(notificationsUnreadCountProvider);
    }).then((asyncValue) {
      state = asyncValue as AsyncValue<NotificationModel?>;
    });
  }
}
