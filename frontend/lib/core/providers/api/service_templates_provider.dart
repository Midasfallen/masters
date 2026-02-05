import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/api/api_endpoints.dart';
import 'package:service_platform/core/api/api_helpers.dart';
import 'package:service_platform/core/api/dio_client.dart';
import 'package:service_platform/core/models/api/service_template_model.dart';

part 'service_templates_provider.g.dart';

/// Service Templates by Category ID Provider
/// Получает шаблоны услуг для категории level 1
@riverpod
Future<ServiceTemplateListResponse> serviceTemplatesByCategoryId(
  ServiceTemplatesByCategoryIdRef ref,
  String categoryId, {
  String? language,
}) async {
  final client = ref.watch(dioClientProvider);

  final queryParams = <String, dynamic>{};
  if (language != null) {
    queryParams['language'] = language;
  }

  final response = await client.get(
    ApiEndpoints.serviceTemplatesByCategoryId(categoryId),
    queryParameters: queryParams.isNotEmpty ? queryParams : null,
  );

  final data = ApiHelpers.parseObjectResponse(response.data);
  return ServiceTemplateListResponse.fromJson(data);
}

/// Service Template by Slug Provider
/// Получает шаблон услуги по slug
@riverpod
Future<ServiceTemplateModel> serviceTemplateBySlug(
  ServiceTemplateBySlugRef ref,
  String slug, {
  String? language,
}) async {
  final client = ref.watch(dioClientProvider);

  final queryParams = <String, dynamic>{};
  if (language != null) {
    queryParams['language'] = language;
  }

  final response = await client.get(
    ApiEndpoints.serviceTemplateBySlug(slug),
    queryParameters: queryParams.isNotEmpty ? queryParams : null,
  );

  final data = ApiHelpers.parseObjectResponse(response.data);
  return ServiceTemplateModel.fromJson(data);
}

/// Service Template by ID Provider
/// Получает шаблон услуги по ID
@riverpod
Future<ServiceTemplateModel> serviceTemplateById(
  ServiceTemplateByIdRef ref,
  String templateId, {
  String? language,
}) async {
  final client = ref.watch(dioClientProvider);

  final queryParams = <String, dynamic>{};
  if (language != null) {
    queryParams['language'] = language;
  }

  final response = await client.get(
    ApiEndpoints.serviceTemplateById(templateId),
    queryParameters: queryParams.isNotEmpty ? queryParams : null,
  );

  final data = ApiHelpers.parseObjectResponse(response.data);
  return ServiceTemplateModel.fromJson(data);
}
