import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/models/api/master_model.dart';
import 'package:service_platform/core/models/api/service_model.dart';
import 'package:service_platform/core/repositories/search_repository.dart';

part 'search_provider.g.dart';

/// Search Masters Provider
@riverpod
Future<List<MasterProfileModel>> searchMasters(
  SearchMastersRef ref, {
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
  if (query.trim().isEmpty) {
    return [];
  }

  final repository = ref.watch(searchRepositoryProvider);
  return await repository.searchMasters(
    query: query,
    page: page,
    limit: limit,
    categoryId: categoryId,
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
  required String query,
  int page = 1,
  int limit = 20,
  String? categoryId,
  double? minPrice,
  double? maxPrice,
}) async {
  if (query.trim().isEmpty) {
    return [];
  }

  final repository = ref.watch(searchRepositoryProvider);
  return await repository.searchServices(
    query: query,
    page: page,
    limit: limit,
    categoryId: categoryId,
    minPrice: minPrice,
    maxPrice: maxPrice,
  );
}
