import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/api/api_endpoints.dart';
import 'package:service_platform/core/api/api_exceptions.dart';
import 'package:service_platform/core/api/dio_client.dart';
import 'package:service_platform/core/api/api_helpers.dart';
import 'package:service_platform/core/models/api/friend_model.dart';
import 'package:service_platform/core/models/api/user_model.dart';

part 'subscription_repository.g.dart';

class SubscriptionRepository {
  final DioClient _client;

  SubscriptionRepository(this._client);

  /// Get my subscriptions (пользователи, на которых я подписан)
  Future<List<UserModel>> getMySubscriptions({
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.subscriptionsList,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      final data = ApiHelpers.parseListResponse(response.data);
      return data.map((json) => UserModel.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Get my subscribers (пользователи, которые подписаны на меня)
  Future<List<UserModel>> getMySubscribers({
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.subscribersList,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      final data = ApiHelpers.parseListResponse(response.data);
      return data.map((json) => UserModel.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Subscribe to user
  Future<SubscriptionModel> subscribe(String userId) async {
    try {
      final response = await _client.post(
        ApiEndpoints.subscriptions,
        data: {
          'target_id': userId, // КРИТИЧНО: target_id должен быть String, не объект
          'notifications_enabled': true,
        },
      );
      return SubscriptionModel.fromJson(response.data);
    } on DioException catch (e) {
      // КРИТИЧНО: Dio по умолчанию кидает исключение на статусы > 300
      // Поэтому проверка 409 должна быть здесь, а не до try-catch
      
      // Логирование для отладки
      debugPrint('DEBUG: Subscribe DioException: status=${e.response?.statusCode}, data=${e.response?.data}');
      
      // При 409 бэкенд возвращает {message, error, statusCode}, а не SubscriptionModel
      // ApiExceptionHandler должен правильно извлечь message из e.response?.data['message']
      // Просто пробрасываем исключение - ApiExceptionHandler обработает его корректно
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Unsubscribe from user
  Future<void> unsubscribe(String userId) async {
    try {
      await _client.delete(
        ApiEndpoints.subscriptionRemove(userId),
      );
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Get subscription by ID
  Future<SubscriptionModel> getSubscriptionById(String subscriptionId) async {
    try {
      final response = await _client.get(
        '${ApiEndpoints.subscriptionsList}/$subscriptionId',
      );
      return SubscriptionModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Toggle notifications for subscription
  Future<SubscriptionModel> toggleNotifications(
    String subscriptionId,
    bool enabled,
  ) async {
    try {
      final response = await _client.patch(
        '${ApiEndpoints.subscriptionsList}/$subscriptionId/notifications',
        data: {'enabled': enabled},
      );
      return SubscriptionModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Check if following user
  /// [targetUserId] - ID пользователя, на которого проверяем подписку (targetId)
  Future<bool> checkSubscription(String targetUserId) async {
    try {
      final response = await _client.get(
        ApiEndpoints.subscriptionCheck(targetUserId), // targetUserId передается как targetId в URL
      );
      // Предполагаемый формат ответа: {is_following: boolean}
      return response.data['is_following'] as bool? ?? false;
    } on DioException catch (e) {
      // Если endpoint не существует (404), вернуть false
      if (e.response?.statusCode == 404) {
        return false;
      }
      throw ApiExceptionHandler.handleDioError(e);
    }
  }
}

@riverpod
SubscriptionRepository subscriptionRepository(SubscriptionRepositoryRef ref) {
  final client = ref.watch(dioClientProvider);
  return SubscriptionRepository(client);
}
