import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/api/api_endpoints.dart';
import 'package:service_platform/core/api/api_exceptions.dart';
import 'package:service_platform/core/api/dio_client.dart';
import 'package:service_platform/core/config/app_config.dart';
import 'package:service_platform/core/models/api/user_model.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final DioClient _client;
  final FlutterSecureStorage _storage;

  AuthRepository(this._client, this._storage);

  /// Login with email and password
  Future<AuthResponseModel> login(LoginRequest request) async {
    try {
      final response = await _client.post(
        ApiEndpoints.authLogin,
        data: request.toJson(),
      );

      final authResponse = AuthResponseModel.fromJson(response.data);

      // Store tokens
      await _storeTokens(authResponse);

      return authResponse;
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Register new user
  Future<AuthResponseModel> register(RegisterRequest request) async {
    try {
      final response = await _client.post(
        ApiEndpoints.authRegister,
        data: request.toJson(),
      );

      final authResponse = AuthResponseModel.fromJson(response.data);

      // Store tokens
      await _storeTokens(authResponse);

      return authResponse;
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Refresh access token
  Future<AuthResponseModel> refresh() async {
    try {
      final refreshToken = await _storage.read(key: AppConfig.refreshTokenKey);

      if (refreshToken == null) {
        throw UnauthorizedException(message: 'No refresh token');
      }

      final response = await _client.post(
        ApiEndpoints.authRefresh,
        data: {'refresh_token': refreshToken},
      );

      final authResponse = AuthResponseModel.fromJson(response.data);

      // Store new tokens
      await _storeTokens(authResponse);

      return authResponse;
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      // Call logout endpoint
      await _client.post(ApiEndpoints.authLogout);
    } catch (e) {
      // Continue with local logout even if API call fails
    } finally {
      // Clear stored tokens
      await _clearTokens();
    }
  }

  /// Get current user
  Future<UserModel> getMe() async {
    try {
      final response = await _client.get(ApiEndpoints.authMe);
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final accessToken = await _storage.read(key: AppConfig.accessTokenKey);
    return accessToken != null;
  }

  /// Get stored access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: AppConfig.accessTokenKey);
  }

  /// Get stored refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: AppConfig.refreshTokenKey);
  }

  /// Store tokens in secure storage
  Future<void> _storeTokens(AuthResponseModel authResponse) async {
    await _storage.write(
      key: AppConfig.accessTokenKey,
      value: authResponse.accessToken,
    );
    await _storage.write(
      key: AppConfig.refreshTokenKey,
      value: authResponse.refreshToken,
    );
    await _storage.write(
      key: AppConfig.userIdKey,
      value: authResponse.user.id,
    );
  }

  /// Clear stored tokens
  Future<void> _clearTokens() async {
    await _storage.delete(key: AppConfig.accessTokenKey);
    await _storage.delete(key: AppConfig.refreshTokenKey);
    await _storage.delete(key: AppConfig.userIdKey);
  }
}

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final client = ref.watch(dioClientProvider);
  final storage = ref.watch(secureStorageProvider);
  return AuthRepository(client, storage);
}
