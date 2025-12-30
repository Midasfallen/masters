import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/api/api_endpoints.dart';
import 'package:service_platform/core/api/api_exceptions.dart';
import 'package:service_platform/core/api/dio_client.dart';
import 'package:service_platform/core/models/api/master_model.dart';
import 'package:service_platform/core/models/api/service_model.dart';

part 'search_repository.g.dart';

class SearchRepository {
  final DioClient _client;

  SearchRepository(this._client);

  /// Search masters
  Future<List<MasterProfileModel>> searchMasters({
    required String query,
    int page = 1,
    int limit = 20,
    String? categoryId,
    double? lat,
    double? lng,
    int? radius,
    double? minRating,
    int? maxPrice,
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.searchMasters,
        queryParameters: {
          'q': query,
          'page': page,
          'limit': limit,
          if (categoryId != null) 'category_id': categoryId,
          if (lat != null) 'lat': lat,
          if (lng != null) 'lng': lng,
          if (radius != null) 'radius': radius,
          if (minRating != null) 'min_rating': minRating,
          if (maxPrice != null) 'max_price': maxPrice,
        },
      );

      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => MasterProfileModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Search services
  Future<List<ServiceModel>> searchServices({
    required String query,
    int page = 1,
    int limit = 20,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.searchServices,
        queryParameters: {
          'q': query,
          'page': page,
          'limit': limit,
          if (categoryId != null) 'category_id': categoryId,
          if (minPrice != null) 'min_price': minPrice,
          if (maxPrice != null) 'max_price': maxPrice,
        },
      );

      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => ServiceModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }
}

@riverpod
SearchRepository searchRepository(SearchRepositoryRef ref) {
  final client = ref.watch(dioClientProvider);
  return SearchRepository(client);
}
