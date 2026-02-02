import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/api/api_endpoints.dart';
import 'package:service_platform/core/api/api_helpers.dart';
import 'package:service_platform/core/api/dio_client.dart';
import 'package:service_platform/core/models/api/category_tree_model.dart';

part 'categories_tree_provider.g.dart';

/// Categories Tree Provider
/// Получает дерево категорий из API
@riverpod
Future<List<CategoryTreeModel>> categoriesTree(
  CategoriesTreeRef ref, {
  String? language,
}) async {
  final client = ref.watch(dioClientProvider);

  final queryParams = <String, dynamic>{};
  if (language != null) {
    queryParams['language'] = language;
  }

  final response = await client.get(
    ApiEndpoints.categoriesTree,
    queryParameters: queryParams.isNotEmpty ? queryParams : null,
  );

  final data = ApiHelpers.parseListResponse(response.data);
  return data
      .map((json) => CategoryTreeModel.fromJson(json as Map<String, dynamic>))
      .toList();
}
