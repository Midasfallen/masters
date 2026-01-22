import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/api/api_endpoints.dart';
import 'package:service_platform/core/api/api_exceptions.dart';
import 'package:service_platform/core/api/dio_client.dart';
import 'package:service_platform/core/api/api_helpers.dart';
import 'package:service_platform/core/models/api/notification_model.dart';

part 'notification_repository.g.dart';

class NotificationRepository {
  final DioClient _client;

  NotificationRepository(this._client);

  /// Get all notifications for current user
  Future<List<NotificationModel>> getNotifications({
    int page = 1,
    int limit = 50,
    bool? isRead,
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.notifications,
        queryParameters: {
          'page': page,
          'limit': limit,
          if (isRead != null) 'is_read': isRead,
        },
      );

      final data = ApiHelpers.parseListResponse(response.data);
      return data.map((json) => NotificationModel.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Get notification by ID
  Future<NotificationModel> getNotificationById(String id) async {
    try {
      final response = await _client.get(
        ApiEndpoints.notificationById(int.parse(id)),
      );
      return NotificationModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Mark notification as read
  Future<NotificationModel> markAsRead(String id) async {
    try {
      final response = await _client.patch(
        ApiEndpoints.notificationMarkRead(int.parse(id)),
      );
      return NotificationModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      await _client.patch(ApiEndpoints.notificationMarkAllRead);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Get unread count
  Future<int> getUnreadCount() async {
    try {
      final response = await _client.get(
        ApiEndpoints.notificationsUnreadCount,
      );
      return response.data['count'] ?? 0;
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }
}

@riverpod
NotificationRepository notificationRepository(NotificationRepositoryRef ref) {
  final client = ref.watch(dioClientProvider);
  return NotificationRepository(client);
}
