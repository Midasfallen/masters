import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/api/api_endpoints.dart';
import 'package:service_platform/core/api/api_exceptions.dart';
import 'package:service_platform/core/api/dio_client.dart';
import 'package:service_platform/core/models/api/service_model.dart';

part 'service_repository.g.dart';

/// Репозиторий услуг мастера (создание/управление).
/// Используется визардом «Стать мастером» для сохранения услуг после
/// финализации профиля (POST /services требует master_profile_completed=true).
class ServiceRepository {
  final DioClient _client;

  ServiceRepository(this._client);

  /// Создать услугу. master_id определяется бэком из токена.
  /// category_id должен быть level 1 и входить в profile.category_ids.
  Future<ServiceModel> createService(CreateServiceRequest request) async {
    try {
      final response = await _client.post(
        ApiEndpoints.serviceCreate,
        data: request.toJson(),
      );
      return ServiceModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }
}

@riverpod
ServiceRepository serviceRepository(ServiceRepositoryRef ref) {
  final client = ref.watch(dioClientProvider);
  return ServiceRepository(client);
}
