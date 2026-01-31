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

/// Master by Profile ID Provider
/// Gets master profile by master profile ID (not userId!)
@riverpod
Future<MasterProfileModel> masterByProfileId(
  MasterByProfileIdRef ref,
  String masterId,
) async {
  final repository = ref.watch(masterRepositoryProvider);
  return await repository.getMasterById(masterId);
}

/// Master by User ID Provider
/// Gets master profile by user ID (authorId from post)
/// 
/// Использует эндпоинт GET /masters/:id, который теперь поддерживает
/// поиск как по ID профиля мастера, так и по user_id.
@riverpod
Future<MasterProfileModel> masterByUserId(
  MasterByUserIdRef ref,
  String userId,
) async {
  final repository = ref.watch(masterRepositoryProvider);
  return await repository.getMasterByUserId(userId);
}

/// Master by ID Provider (deprecated - use masterByProfileId or masterByUserId)
/// 
/// ⚠️ DEPRECATED: Этот провайдер больше не должен использоваться.
/// Используйте masterByProfileId для поиска по ID профиля мастера
/// или masterByUserId для поиска по ID пользователя.
@Deprecated('Use masterByProfileId or masterByUserId instead')
@riverpod
Future<MasterProfileModel> masterById(MasterByIdRef ref, String id) async {
  final repository = ref.watch(masterRepositoryProvider);
  return await repository.getMasterById(id);
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
