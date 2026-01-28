import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/api/dio_client.dart';
import 'package:service_platform/core/api/api_endpoints.dart';
import 'package:service_platform/core/models/api/auto_proposal_model.dart';

part 'auto_proposal_repository.g.dart';

@riverpod
AutoProposalRepository autoProposalRepository(AutoProposalRepositoryRef ref) {
  return AutoProposalRepository(ref.read(dioClientProvider));
}

class AutoProposalRepository {
  final DioClient _client;

  AutoProposalRepository(this._client);

  // ============ SETTINGS ============

  /// Получить настройки автопредложений
  Future<AutoProposalSettingsModel> getSettings() async {
    final response = await _client.get(ApiEndpoints.autoProposalSettings);
    return AutoProposalSettingsModel.fromJson(response.data);
  }

  /// Обновить настройки автопредложений
  Future<AutoProposalSettingsModel> updateSettings(
    UpdateAutoProposalSettingsDto dto,
  ) async {
    final response = await _client.patch(
      ApiEndpoints.autoProposalSettings,
      data: dto.toJson(),
    );
    return AutoProposalSettingsModel.fromJson(response.data);
  }

  // ============ PROPOSALS ============

  /// Получить все предложения пользователя
  Future<List<AutoProposalModel>> getProposals() async {
    final response = await _client.get(ApiEndpoints.autoProposalsList);
    final List<dynamic> data = response.data is List
        ? response.data
        : response.data['data'] ?? [];
    return data.map((json) => AutoProposalModel.fromJson(json)).toList();
  }

  /// Получить активные (PENDING) предложения
  Future<List<AutoProposalModel>> getActiveProposals() async {
    final response = await _client.get(ApiEndpoints.autoProposalsActive);
    final List<dynamic> data = response.data is List
        ? response.data
        : response.data['data'] ?? [];
    return data.map((json) => AutoProposalModel.fromJson(json)).toList();
  }

  /// Получить одно предложение по ID
  Future<AutoProposalModel> getProposalById(String proposalId) async {
    final response = await _client.get(
      ApiEndpoints.autoProposalById(proposalId),
    );
    return AutoProposalModel.fromJson(response.data);
  }

  /// Принять предложение (создать бронирование)
  Future<Map<String, dynamic>> acceptProposal(
    String proposalId,
    AcceptProposalDto dto,
  ) async {
    final response = await _client.post(
      ApiEndpoints.autoProposalAccept(proposalId),
      data: dto.toJson(),
    );
    return {
      'proposal': AutoProposalModel.fromJson(response.data['proposal']),
      'bookingId': response.data['bookingId'] as String,
    };
  }

  /// Отклонить предложение
  Future<AutoProposalModel> rejectProposal(String proposalId) async {
    final response = await _client.post(
      ApiEndpoints.autoProposalReject(proposalId),
    );
    return AutoProposalModel.fromJson(response.data);
  }

  /// Запросить генерацию предложений вручную
  Future<List<AutoProposalModel>> generateProposals() async {
    final response = await _client.post(ApiEndpoints.autoProposalGenerate);
    final List<dynamic> data = response.data is List
        ? response.data
        : response.data['data'] ?? [];
    return data.map((json) => AutoProposalModel.fromJson(json)).toList();
  }
}
