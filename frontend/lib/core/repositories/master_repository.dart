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

  /// Get master by ID
  Future<MasterProfileModel> getMasterById(String id) async {
    try {
      final response = await _client.get(ApiEndpoints.masterById(int.parse(id)));
      return MasterProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
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
        ApiEndpoints.masterServices(int.parse(masterId)),
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
        ApiEndpoints.masterReviews(int.parse(masterId)),
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
