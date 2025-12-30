import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/models/api/master_model.dart';
import 'package:service_platform/core/models/api/service_model.dart';
import 'package:service_platform/core/models/api/review_model.dart';
import 'package:service_platform/core/repositories/master_repository.dart';

part 'masters_provider.g.dart';

/// Masters List Provider
@riverpod
Future<List<MasterProfileModel>> mastersList(
  MastersListRef ref, {
  int page = 1,
  int limit = 20,
  String? categoryId,
  double? lat,
  double? lng,
  int? radius,
}) async {
  final repository = ref.watch(masterRepositoryProvider);
  return await repository.getMasters(
    page: page,
    limit: limit,
    categoryId: categoryId,
    lat: lat,
    lng: lng,
    radius: radius,
  );
}

/// Master by ID Provider
@riverpod
Future<MasterProfileModel> masterById(MasterByIdRef ref, String masterId) async {
  final repository = ref.watch(masterRepositoryProvider);
  return await repository.getMasterById(masterId);
}

/// Master Services Provider
@riverpod
Future<List<ServiceModel>> masterServices(
  MasterServicesRef ref,
  String masterId,
) async {
  final repository = ref.watch(masterRepositoryProvider);
  return await repository.getMasterServices(masterId);
}

/// Master Reviews Provider
@riverpod
Future<List<ReviewModel>> masterReviews(
  MasterReviewsRef ref,
  String masterId, {
  int page = 1,
  int limit = 20,
}) async {
  final repository = ref.watch(masterRepositoryProvider);
  return await repository.getMasterReviews(
    masterId,
    page: page,
    limit: limit,
  );
}

/// My Master Profile Provider
@riverpod
Future<MasterProfileModel?> myMasterProfile(MyMasterProfileRef ref) async {
  final repository = ref.watch(masterRepositoryProvider);
  try {
    return await repository.getMyMasterProfile();
  } catch (e) {
    return null;
  }
}

/// Master Notifier for mutations
@riverpod
class MasterNotifier extends _$MasterNotifier {
  @override
  FutureOr<MasterProfileModel?> build() async {
    return null;
  }

  /// Create master profile
  Future<MasterProfileModel> createProfile(
    CreateMasterProfileRequest request,
  ) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(masterRepositoryProvider);
      final profile = await repository.createMasterProfile(request);

      // Refresh master profile
      ref.invalidate(myMasterProfileProvider);

      return profile;
    }).then((asyncValue) {
      state = asyncValue;
      return asyncValue.requireValue;
    });
  }

  /// Update master profile
  Future<MasterProfileModel> updateProfile(
    UpdateMasterProfileRequest request,
  ) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(masterRepositoryProvider);
      final profile = await repository.updateMasterProfile(request);

      // Refresh master profile
      ref.invalidate(myMasterProfileProvider);

      return profile;
    }).then((asyncValue) {
      state = asyncValue;
      return asyncValue.requireValue;
    });
  }
}
