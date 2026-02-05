import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/models/api/master_model.dart';
import 'package:service_platform/core/models/api/service_model.dart';
import 'package:service_platform/core/repositories/search_repository.dart';

part 'search_provider.g.dart';

/// Search Masters Provider
@riverpod
Future<List<MasterProfileModel>> searchMasters(
  SearchMastersRef ref, {
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
  // Разрешаем поиск без текстового запроса, если есть фильтры по категориям
  if (query.trim().isEmpty && categoryId == null && (categoryIds == null || categoryIds.isEmpty)) {
    return [];
  }

  final repository = ref.watch(searchRepositoryProvider);
  return await repository.searchMasters(
    query: query,
    page: page,
    limit: limit,
    categoryId: categoryId,
    categoryIds: categoryIds,
    lat: lat,
    lng: lng,
    radius: radius,
    minRating: minRating,
    maxPrice: maxPrice,
  );
}

/// Search Services Provider
@riverpod
Future<List<ServiceModel>> searchServices(
  SearchServicesRef ref, {
  String query = '',
  int page = 1,
  int limit = 20,
  String? categoryId,
  List<String>? categoryIds,
  double? minPrice,
  double? maxPrice,
}) async {
  // Разрешаем поиск без текстового запроса, если есть фильтры по категориям
  if (query.trim().isEmpty && categoryId == null && (categoryIds == null || categoryIds.isEmpty)) {
    return [];
  }

  final repository = ref.watch(searchRepositoryProvider);
  return await repository.searchServices(
    query: query,
    page: page,
    limit: limit,
    categoryId: categoryId,
    categoryIds: categoryIds,
    minPrice: minPrice,
    maxPrice: maxPrice,
  );
}
