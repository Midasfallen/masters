import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/models/api/auto_proposal_model.dart';
import 'package:service_platform/core/repositories/auto_proposal_repository.dart';

part 'auto_proposals_provider.g.dart';

// ============ SETTINGS ============

/// Auto Proposal Settings Provider
@riverpod
Future<AutoProposalSettingsModel> autoProposalSettings(
  AutoProposalSettingsRef ref,
) async {
  final repository = ref.watch(autoProposalRepositoryProvider);
  return await repository.getSettings();
}

/// Settings Notifier for mutations
@riverpod
class AutoProposalSettingsNotifier extends _$AutoProposalSettingsNotifier {
  @override
  FutureOr<AutoProposalSettingsModel?> build() async {
    return null;
  }

  /// Update settings
  Future<AutoProposalSettingsModel> updateSettings(
    UpdateAutoProposalSettingsDto dto,
  ) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(autoProposalRepositoryProvider);
      final settings = await repository.updateSettings(dto);

      // Invalidate settings
      ref.invalidate(autoProposalSettingsProvider);

      return settings;
    }).then((asyncValue) {
      state = asyncValue;
      return asyncValue.requireValue;
    });
  }
}

// ============ PROPOSALS ============

/// All Proposals List Provider
@riverpod
Future<List<AutoProposalModel>> autoProposalsList(
  AutoProposalsListRef ref,
) async {
  final repository = ref.watch(autoProposalRepositoryProvider);
  return await repository.getProposals();
}

/// Active Proposals List Provider
@riverpod
Future<List<AutoProposalModel>> activeProposalsList(
  ActiveProposalsListRef ref,
) async {
  final repository = ref.watch(autoProposalRepositoryProvider);
  return await repository.getActiveProposals();
}

/// Proposal by ID Provider
@riverpod
Future<AutoProposalModel> autoProposalById(
  AutoProposalByIdRef ref,
  String proposalId,
) async {
  final repository = ref.watch(autoProposalRepositoryProvider);
  return await repository.getProposalById(proposalId);
}

/// Proposal Notifier for mutations
@riverpod
class AutoProposalNotifier extends _$AutoProposalNotifier {
  @override
  FutureOr<AutoProposalModel?> build() async {
    return null;
  }

  /// Accept proposal (create booking)
  Future<Map<String, dynamic>> acceptProposal(
    String proposalId,
    AcceptProposalDto dto,
  ) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(autoProposalRepositoryProvider);
      final result = await repository.acceptProposal(proposalId, dto);

      // Invalidate proposals lists
      ref.invalidate(autoProposalsListProvider);
      ref.invalidate(activeProposalsListProvider);
      ref.invalidate(autoProposalByIdProvider);

      return result;
    }).then((asyncValue) {
      state = AsyncValue.data(
        asyncValue.value?['proposal'] as AutoProposalModel?,
      );
      return asyncValue.requireValue;
    });
  }

  /// Reject proposal
  Future<AutoProposalModel> rejectProposal(String proposalId) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(autoProposalRepositoryProvider);
      final proposal = await repository.rejectProposal(proposalId);

      // Invalidate proposals lists
      ref.invalidate(autoProposalsListProvider);
      ref.invalidate(activeProposalsListProvider);
      ref.invalidate(autoProposalByIdProvider);

      return proposal;
    }).then((asyncValue) {
      state = asyncValue;
      return asyncValue.requireValue;
    });
  }

  /// Generate proposals manually
  Future<List<AutoProposalModel>> generateProposals() async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(autoProposalRepositoryProvider);
      final proposals = await repository.generateProposals();

      // Invalidate proposals lists
      ref.invalidate(autoProposalsListProvider);
      ref.invalidate(activeProposalsListProvider);

      return proposals;
    }).then((asyncValue) {
      state = const AsyncValue.data(null);
      return asyncValue.requireValue;
    });
  }
}
