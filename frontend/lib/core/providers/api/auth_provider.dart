import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/models/api/user_model.dart';
import 'package:service_platform/core/repositories/auth_repository.dart';

part 'auth_provider.g.dart';

/// Auth State
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

/// Auth State Notifier
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<AuthState> build() async {
    final repository = ref.watch(authRepositoryProvider);
    final isLoggedIn = await repository.isLoggedIn();

    if (isLoggedIn) {
      try {
        final user = await repository.getMe();
        return AuthState(user: user, isAuthenticated: true);
      } catch (e) {
        return const AuthState(isAuthenticated: false);
      }
    }

    return const AuthState(isAuthenticated: false);
  }

  /// Login
  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      await repository.login(
        LoginRequest(email: email, password: password),
      );

      // Convert AuthUserModel to UserModel
      final user = await repository.getMe();

      return AuthState(user: user, isAuthenticated: true);
    });
  }

  /// Register
  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      await repository.register(
        RegisterRequest(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
        ),
      );

      final user = await repository.getMe();

      return AuthState(user: user, isAuthenticated: true);
    });
  }

  /// Logout
  Future<void> logout() async {
    final repository = ref.read(authRepositoryProvider);
    await repository.logout();
    state = const AsyncValue.data(AuthState(isAuthenticated: false));
  }

  /// Refresh user data
  Future<void> refreshUser() async {
    final repository = ref.read(authRepositoryProvider);
    try {
      final user = await repository.getMe();
      state = AsyncValue.data(AuthState(user: user, isAuthenticated: true));
    } catch (e) {
      // Keep current state on error
    }
  }
}

/// Current User Provider
@riverpod
UserModel? currentUser(CurrentUserRef ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.whenOrNull(data: (state) => state.user);
}

/// Is Authenticated Provider
@riverpod
bool isAuthenticated(IsAuthenticatedRef ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.whenOrNull(data: (state) => state.isAuthenticated) ?? false;
}
