import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:service_platform/core/models/api/user_model.dart';
import 'package:service_platform/core/providers/api/auth_provider.dart';
import 'package:service_platform/core/repositories/auth_repository.dart';

import 'auth_provider_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockRepo;
  late ProviderContainer container;

  final mockAuthResponse = AuthResponseModel(
    accessToken: 'access_token',
    refreshToken: 'refresh_token',
    tokenType: 'Bearer',
    expiresIn: 3600,
    user: AuthUserModel(
      id: 'user1',
      email: 'test@test.com',
      firstName: 'Test',
      lastName: 'User',
      isMaster: false,
      isVerified: false,
      isPremium: false,
    ),
  );

  final mockUser = UserModel(
    id: 'user1',
    email: 'test@test.com',
    firstName: 'Test',
    lastName: 'User',
  );

  setUp(() {
    mockRepo = MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthNotifier', () {
    test('initial state — not authenticated when not logged in', () async {
      when(mockRepo.isLoggedIn()).thenAnswer((_) async => false);

      final state = await container.read(authNotifierProvider.future);

      expect(state.isAuthenticated, false);
      expect(state.user, null);
    });

    test('initial state — authenticated when logged in', () async {
      when(mockRepo.isLoggedIn()).thenAnswer((_) async => true);
      when(mockRepo.getMe()).thenAnswer((_) async => mockUser);

      final state = await container.read(authNotifierProvider.future);

      expect(state.isAuthenticated, true);
      expect(state.user, mockUser);
    });

    test('login — sets authenticated state', () async {
      when(mockRepo.isLoggedIn()).thenAnswer((_) async => false);
      when(mockRepo.login(any)).thenAnswer((_) async => mockAuthResponse);
      when(mockRepo.getMe()).thenAnswer((_) async => mockUser);

      // Ожидаем начальную загрузку
      await container.read(authNotifierProvider.future);

      // Вызываем login
      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.login('test@test.com', 'password123');

      final state = container.read(authNotifierProvider);
      expect(state.value?.isAuthenticated, true);
      expect(state.value?.user?.email, 'test@test.com');
    });

    test('logout — clears authenticated state', () async {
      when(mockRepo.isLoggedIn()).thenAnswer((_) async => true);
      when(mockRepo.getMe()).thenAnswer((_) async => mockUser);
      when(mockRepo.logout()).thenAnswer((_) async => {});

      await container.read(authNotifierProvider.future);

      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.logout();

      final state = container.read(authNotifierProvider);
      expect(state.value?.isAuthenticated, false);
      expect(state.value?.user, null);
    });

    test('login sets error state on failure', () async {
      when(mockRepo.isLoggedIn()).thenAnswer((_) async => false);
      when(mockRepo.login(any)).thenThrow(Exception('Auth failed'));

      await container.read(authNotifierProvider.future);

      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.login('bad@email.com', 'wrong');

      final state = container.read(authNotifierProvider);
      expect(state, isA<AsyncError<AuthState>>());
    });
  });

  group('currentUser provider', () {
    test('returns null when not authenticated', () async {
      when(mockRepo.isLoggedIn()).thenAnswer((_) async => false);

      await container.read(authNotifierProvider.future);

      final user = container.read(currentUserProvider);
      expect(user, null);
    });

    test('returns user when authenticated', () async {
      when(mockRepo.isLoggedIn()).thenAnswer((_) async => true);
      when(mockRepo.getMe()).thenAnswer((_) async => mockUser);

      await container.read(authNotifierProvider.future);

      final user = container.read(currentUserProvider);
      expect(user, mockUser);
    });
  });

  group('isAuthenticated provider', () {
    test('returns false when not logged in', () async {
      when(mockRepo.isLoggedIn()).thenAnswer((_) async => false);

      await container.read(authNotifierProvider.future);

      final isAuth = container.read(isAuthenticatedProvider);
      expect(isAuth, false);
    });

    test('returns true when logged in', () async {
      when(mockRepo.isLoggedIn()).thenAnswer((_) async => true);
      when(mockRepo.getMe()).thenAnswer((_) async => mockUser);

      await container.read(authNotifierProvider.future);

      final isAuth = container.read(isAuthenticatedProvider);
      expect(isAuth, true);
    });
  });
}
