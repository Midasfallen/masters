import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/api/api_endpoints.dart';
import 'package:service_platform/core/api/api_helpers.dart';
import 'package:service_platform/core/api/dio_client.dart';
import 'package:service_platform/core/models/api/service_model.dart';

part 'services_provider.g.dart';

/// Services by Category IDs Provider
/// Получает услуги, отфильтрованные по категориям
@riverpod
Future<List<ServiceModel>> servicesByCategoryIds(
  ServicesByCategoryIdsRef ref,
  List<String> categoryIds,
) async {
  if (categoryIds.isEmpty) {
    return [];
  }

  final client = ref.watch(dioClientProvider);
  final response = await client.get(
    ApiEndpoints.services,
    queryParameters: {'category_ids': categoryIds},
  );

  final data = ApiHelpers.parseListResponse(response.data);
  return data
      .map((json) => ServiceModel.fromJson(json as Map<String, dynamic>))
      .toList();
}
