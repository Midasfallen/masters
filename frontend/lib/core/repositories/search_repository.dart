import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/api/api_endpoints.dart';
import 'package:service_platform/core/api/api_exceptions.dart';
import 'package:service_platform/core/api/dio_client.dart';
import 'package:service_platform/core/api/api_helpers.dart';
import 'package:service_platform/core/models/api/master_model.dart';
import 'package:service_platform/core/models/api/service_model.dart';
import 'package:service_platform/core/models/api/search_aggregation_model.dart';

part 'search_repository.g.dart';

class SearchRepository {
  final DioClient _client;

  SearchRepository(this._client);

  /// Агрегированный поиск: мастера, услуги, категории одним запросом
  Future<SearchAggregationModel> searchAll({
    required String query,
    int limit = 10,
    String language = 'ru',
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'q': query.trim(),
        'limit': limit,
        'language': language,
      };
      final response = await _client.get(
        ApiEndpoints.searchAll,
        queryParameters: queryParams,
      );
      final data = response.data as Map<String, dynamic>;
      return SearchAggregationModel.fromJson(data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Search masters
  Future<List<MasterSearchResultModel>> searchMasters({
    String query = '',
    int page = 1,
    int limit = 20,
    String? categoryId,
    List<String>? categoryIds,
    double? lat,
    double? lng,
    int? radius,
    double? minRating,
    int? maxPrice,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (query.isNotEmpty) 'query': query,
        if (categoryIds != null && categoryIds.isNotEmpty) 'category_ids': categoryIds,
        if (categoryId != null && (categoryIds == null || categoryIds.isEmpty)) 'category_id': categoryId,
        if (lat != null) 'lat': lat,
        if (lng != null) 'lng': lng,
        if (radius != null) 'radius_km': radius,
        if (minRating != null) 'min_rating': minRating,
        if (maxPrice != null) 'max_price': maxPrice,
      };

      final response = await _client.get(
        ApiEndpoints.searchMasters,
        queryParameters: queryParams,
      );

      final data = ApiHelpers.parseListResponse(response.data);
      return data.map((json) => MasterSearchResultModel.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Search services
  Future<List<ServiceModel>> searchServices({
    String query = '',
    int page = 1,
    int limit = 20,
    String? categoryId,
    List<String>? categoryIds,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (query.isNotEmpty) 'query': query,
        if (categoryIds != null && categoryIds.isNotEmpty) 'category_ids': categoryIds,
        if (categoryId != null && (categoryIds == null || categoryIds.isEmpty)) 'category_id': categoryId,
        if (minPrice != null) 'min_price': minPrice,
        if (maxPrice != null) 'max_price': maxPrice,
      };

      final response = await _client.get(
        ApiEndpoints.searchServices,
        queryParameters: queryParams,
      );

      final data = ApiHelpers.parseListResponse(response.data);
      return data.map((json) => ServiceModel.fromJson(json as Map<String, dynamic>)).toList();
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
