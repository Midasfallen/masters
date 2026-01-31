import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/api/api_endpoints.dart';
import 'package:service_platform/core/api/api_exceptions.dart';
import 'package:service_platform/core/api/dio_client.dart';
import 'package:service_platform/core/api/api_helpers.dart';
import 'package:service_platform/core/models/api/master_model.dart';
import 'package:service_platform/core/models/api/service_model.dart';
import 'package:service_platform/core/models/api/review_model.dart';

part 'master_repository.g.dart';

class MasterRepository {
  final DioClient _client;

  MasterRepository(this._client);

  /// Get all masters
  Future<List<MasterProfileModel>> getMasters({
    int page = 1,
    int limit = 20,
    String? categoryId,
    double? lat,
    double? lng,
    int? radius,
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.masters,
        queryParameters: {
          'page': page,
          'limit': limit,
          if (categoryId != null) 'category_id': categoryId,
          if (lat != null) 'lat': lat,
          if (lng != null) 'lng': lng,
          if (radius != null) 'radius': radius,
        },
      );

      final data = ApiHelpers.parseListResponse(response.data);
      return data.map((json) => MasterProfileModel.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Get master by ID (master profile ID)
  Future<MasterProfileModel> getMasterById(String id) async {
    try {
      final response = await _client.get(ApiEndpoints.masterById(id));
      
      // Жесткая проверка на null перед парсингом
      if (response.data == null) {
        throw ApiException(
          message: 'Профиль мастера не найден (ответ сервера: null)',
          statusCode: 404,
        );
      }
      
      // Проверяем, что это объект, а не массив или другой тип
      if (response.data is! Map<String, dynamic>) {
        throw ApiException(
          message: 'Некорректный формат ответа от сервера. Ожидался объект, получен: ${response.data.runtimeType}',
          statusCode: 500,
          data: response.data,
        );
      }
      
      final data = response.data as Map<String, dynamic>;
      
      // Дополнительная проверка: убеждаемся, что есть обязательные поля
      if (data['id'] == null || data['userId'] == null) {
        throw ApiException(
          message: 'Профиль мастера не найден (отсутствуют обязательные поля)',
          statusCode: 404,
          data: data,
        );
      }
      
      return MasterProfileModel.fromJson(data);
    } on DioException catch (e) {
      // Если это 404 от Dio, преобразуем в ApiException
      if (e.response?.statusCode == 404) {
        throw ApiException(
          message: e.response?.data?['message'] ?? 'Профиль мастера не найден',
          statusCode: 404,
          data: e.response?.data,
        );
      }
      throw ApiExceptionHandler.handleDioError(e);
    } catch (e) {
      // Обработка ошибок парсинга (TypeError: null и т.д.)
      final errorString = e.toString();
      if (errorString.contains('null') || 
          errorString.contains('Null') ||
          errorString.contains('is not a subtype')) {
        throw ApiException(
          message: 'Профиль мастера не найден или данные некорректны. Ошибка парсинга: $errorString',
          statusCode: 404,
        );
      }
      rethrow;
    }
  }

  /// Get master profile by user ID
  /// 
  /// Использует тот же эндпоинт GET /masters/:id, который теперь поддерживает
  /// поиск как по ID профиля мастера, так и по user_id.
  Future<MasterProfileModel> getMasterByUserId(String userId) async {
    // Используем тот же метод, что и для masterId - бэкенд теперь умеет искать по user_id
    return getMasterById(userId);
  }

  /// Create master profile
  Future<MasterProfileModel> createMasterProfile(
    CreateMasterProfileRequest request,
  ) async {
    try {
      final response = await _client.post(
        ApiEndpoints.masterCreate,
        data: request.toJson(),
      );
      return MasterProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Update master profile
  Future<MasterProfileModel> updateMasterProfile(
    UpdateMasterProfileRequest request,
  ) async {
    try {
      final response = await _client.patch(
        ApiEndpoints.masterUpdate,
        data: request.toJson(),
      );
      return MasterProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Get master services
  Future<List<ServiceModel>> getMasterServices(String masterId) async {
    try {
      final response = await _client.get(
        ApiEndpoints.masterServices(masterId),
      );

      final data = ApiHelpers.parseListResponse(response.data);
      return data.map((json) => ServiceModel.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Get master reviews
  Future<List<ReviewModel>> getMasterReviews(
    String masterId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.masterReviews(masterId),
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      final data = ApiHelpers.parseListResponse(response.data);
      return data.map((json) => ReviewModel.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Get current user's master profile
  Future<MasterProfileModel> getMyMasterProfile() async {
    try {
      final response = await _client.get(ApiEndpoints.masterMe);
      return MasterProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }
}

@riverpod
MasterRepository masterRepository(MasterRepositoryRef ref) {
  final client = ref.watch(dioClientProvider);
  return MasterRepository(client);
}
