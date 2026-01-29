import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/api/api_endpoints.dart';
import 'package:service_platform/core/api/api_exceptions.dart';
import 'package:service_platform/core/api/dio_client.dart';
import 'package:service_platform/core/api/api_helpers.dart';
import 'package:service_platform/core/models/api/user_model.dart';

part 'user_repository.g.dart';

class UserRepository {
  final DioClient _client;

  UserRepository(this._client);

  /// Get current user profile
  Future<UserModel> getMe() async {
    try {
      final response = await _client.get(ApiEndpoints.userMe);
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Get user by ID
  Future<UserModel> getUserById(String id) async {
    try {
      final response = await _client.get(ApiEndpoints.userById(id));
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Update user profile
  Future<UserModel> updateUser(UpdateUserRequest request) async {
    try {
      final response = await _client.patch(
        ApiEndpoints.userUpdate,
        data: request.toJson(),
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Upload user avatar
  Future<UserModel> uploadAvatar(String filePath) async {
    try {
      final response = await _client.uploadFile(
        ApiEndpoints.userAvatar,
        filePath,
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Get list of users (for search, etc.)
  Future<List<UserModel>> getUsers({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.users,
        queryParameters: {
          'page': page,
          'limit': limit,
          if (search != null) 'search': search,
        },
      );

      final data = ApiHelpers.parseListResponse(response.data);
      return data.map((json) => UserModel.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }
}

@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  final client = ref.watch(dioClientProvider);
  return UserRepository(client);
}
