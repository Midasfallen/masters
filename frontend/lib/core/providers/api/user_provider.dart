import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/models/api/user_model.dart';
import 'package:service_platform/core/repositories/user_repository.dart';

part 'user_provider.g.dart';

/// User by ID Provider
@riverpod
Future<UserModel> userById(UserByIdRef ref, String userId) async {
  final repository = ref.watch(userRepositoryProvider);
  return await repository.getUserById(userId);
}

/// Current User Profile Provider
@riverpod
Future<UserModel> currentUserProfile(CurrentUserProfileRef ref) async {
  final repository = ref.watch(userRepositoryProvider);
  return await repository.getMe();
}

/// User List Provider
@riverpod
Future<List<UserModel>> userList(
  UserListRef ref, {
  int page = 1,
  int limit = 20,
  String? search,
}) async {
  final repository = ref.watch(userRepositoryProvider);
  return await repository.getUsers(
    page: page,
    limit: limit,
    search: search,
  );
}

/// User Notifier for mutations
@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  FutureOr<UserModel?> build() async {
    return null;
  }

  /// Update user profile
  Future<UserModel> updateProfile(UpdateUserRequest request) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(userRepositoryProvider);
      final user = await repository.updateUser(request);

      // Refresh auth state
      ref.invalidate(currentUserProfileProvider);

      return user;
    }).then((asyncValue) {
      state = asyncValue;
      return asyncValue.requireValue;
    });
  }

  /// Upload avatar
  Future<UserModel> uploadAvatar(String filePath) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(userRepositoryProvider);
      final user = await repository.uploadAvatar(filePath);

      // Refresh auth state
      ref.invalidate(currentUserProfileProvider);

      return user;
    }).then((asyncValue) {
      state = asyncValue;
      return asyncValue.requireValue;
    });
  }
}
