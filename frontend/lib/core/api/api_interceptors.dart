import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:service_platform/core/api/api_endpoints.dart';
import 'package:service_platform/core/api/api_exceptions.dart';
import 'package:service_platform/core/config/app_config.dart';

/// JWT Authentication Interceptor
/// Adds access token to all requests
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;

  AuthInterceptor(this._storage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip adding token for auth endpoints
    if (_isAuthEndpoint(options.path)) {
      return handler.next(options);
    }

    // Get access token from secure storage
    final accessToken = await _storage.read(key: AppConfig.accessTokenKey);

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return handler.next(options);
  }

  bool _isAuthEndpoint(String path) {
    return path.contains(ApiEndpoints.authLogin) ||
        path.contains(ApiEndpoints.authRegister) ||
        path.contains(ApiEndpoints.authRefresh);
  }
}

/// Token Refresh Interceptor
/// Automatically refreshes access token when it expires
class RefreshTokenInterceptor extends Interceptor {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  // Mutex to prevent concurrent refresh token requests
  Future<String?>? _refreshFuture;

  RefreshTokenInterceptor(this._dio, this._storage);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Check if error is 401 and not from refresh endpoint
    if (err.response?.statusCode == 401 &&
        !err.requestOptions.path.contains(ApiEndpoints.authRefresh)) {
      try {
        // Use mutex to prevent concurrent refresh requests
        // If refresh is already in progress, wait for it
        final newToken = await _getOrRefreshToken();

        if (newToken != null) {
          // Retry original request with new token
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newToken';

          final response = await _dio.fetch(options);
          return handler.resolve(response);
        }
      } catch (e) {
        // Refresh failed, clear tokens
        await _clearTokens();
        _refreshFuture = null;
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  /// Get or refresh token with mutex to prevent concurrent requests
  Future<String?> _getOrRefreshToken() async {
    // If refresh is already in progress, wait for it
    if (_refreshFuture != null) {
      return await _refreshFuture;
    }

    // Start new refresh operation
    _refreshFuture = _refreshToken();

    try {
      final token = await _refreshFuture;
      return token;
    } finally {
      // Clear refresh future after completion
      _refreshFuture = null;
    }
  }

  Future<String?> _refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: AppConfig.refreshTokenKey);

      if (refreshToken == null) {
        throw UnauthorizedException(message: 'No refresh token');
      }

      final response = await _dio.post(
        ApiEndpoints.authRefresh,
        data: {'refresh_token': refreshToken},
      );

      final newAccessToken = response.data['access_token'] as String?;
      final newRefreshToken = response.data['refresh_token'] as String?;

      if (newAccessToken != null) {
        await _storage.write(
          key: AppConfig.accessTokenKey,
          value: newAccessToken,
        );
      }

      if (newRefreshToken != null) {
        await _storage.write(
          key: AppConfig.refreshTokenKey,
          value: newRefreshToken,
        );
      }

      return newAccessToken;
    } catch (e) {
      return null;
    }
  }

  Future<void> _clearTokens() async {
    await _storage.delete(key: AppConfig.accessTokenKey);
    await _storage.delete(key: AppConfig.refreshTokenKey);
    await _storage.delete(key: AppConfig.userIdKey);
  }
}

/// Logging Interceptor
/// Logs all requests and responses for debugging
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('┌──────────────────────────────────────────────────────────');
    debugPrint('│ REQUEST: ${options.method} ${options.uri}');
    debugPrint('│ Headers: ${options.headers}');
    if (options.data != null) {
      debugPrint('│ Data: ${options.data}');
    }
    if (options.queryParameters.isNotEmpty) {
      debugPrint('│ Query: ${options.queryParameters}');
    }
    debugPrint('└──────────────────────────────────────────────────────────');
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('┌──────────────────────────────────────────────────────────');
    debugPrint('│ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
    debugPrint('│ Data: ${response.data}');
    debugPrint('└──────────────────────────────────────────────────────────');
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('┌──────────────────────────────────────────────────────────');
    debugPrint('│ ERROR: ${err.message}');
    debugPrint('│ URI: ${err.requestOptions.uri}');
    if (err.response != null) {
      debugPrint('│ Status: ${err.response?.statusCode}');
      debugPrint('│ Data: ${err.response?.data}');
    }
    debugPrint('└──────────────────────────────────────────────────────────');
    return handler.next(err);
  }
}

/// Retry Interceptor
/// Automatically retries failed requests
class RetryInterceptor extends Interceptor {
  final Dio _dio;
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor(
    this._dio, {
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Only retry on connection errors
    if (!_shouldRetry(err)) {
      return handler.next(err);
    }

    final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;

    if (retryCount >= maxRetries) {
      return handler.next(err);
    }

    // Wait before retrying
    await Future.delayed(retryDelay * (retryCount + 1));

    // Increment retry count
    err.requestOptions.extra['retryCount'] = retryCount + 1;

    try {
      // Retry the request using the same Dio instance with all configurations
      final response = await _dio.fetch(err.requestOptions);
      return handler.resolve(response);
    } catch (e) {
      return handler.next(err);
    }
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError;
  }
}

/// Error Handler Interceptor
/// Converts Dio errors to custom ApiExceptions
class ErrorHandlerInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = ApiExceptionHandler.handleDioError(err);
    return handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: exception,
        response: err.response,
        type: err.type,
      ),
    );
  }
}
